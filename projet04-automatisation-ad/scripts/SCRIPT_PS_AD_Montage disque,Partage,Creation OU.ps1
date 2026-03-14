
$ErrorActionPreference = "Stop"
Start-Transcript -Path "$env:USERPROFILE\Desktop\script.log"

Import-Module NTFSSecurity
Import-Module ActiveDirectory



#==================================================================================
# Montage disque virtuel (deux disques physiques de 10Go) RAID 1 (miroir) de 1TO
# Puis initialisation,partitionnement, formatage, attribuer lettre E:
#==================================================================================

#Paramètre GLOBAL:
$Lecteur ="E"



$RAIDPool = "RAIDPool1"
$RAID = "RAID1"
$Size = 1GB
$CheckDisks = (Get-PhysicalDisk | Where-Object {$_.CanPool -eq $True}) #Permet de selectionner nos disques (Attention)

try {
    New-StoragePool `
        -FriendlyName $RAIDPool `
        -StorageSubSystemFriendlyName (Get-StorageSubSystem).FriendlyName `
        -PhysicalDisks $CheckDisks 
} catch {
    Write-Host "Erreur lors du New-StoragePool: $_"
}
try {
    New-VirtualDisk `
        -FriendlyName $RAID `
        -StoragePoolFriendlyName $RAIDPool `
        -ResiliencySettingName Mirror `
        -Size $Size
} catch {
    Write-Host "Erreur lors du New-VirtualDisk: $_"
}
#Initialiser, partitionner, formater et attribuer la lettre E:

try {
    $disk = Get-Disk | Where-Object PartitionStyle -eq 'RAW'

    Initialize-Disk -Number $disk.Number -PartitionStyle GPT
    New-Partition -DiskNumber $disk.Number -UseMaximumSize -DriveLetter $Lecteur | Format-Volume -FileSystem NTFS -NewFileSystemLabel $RAID -Confirm:$false
} catch {
    Write-Host "Erreur lors de initialisation formatage etc...: $_"
}

#========================================
#Crée les dossiers puis on les partagera
#=========================================

#Fonction pour mettre sous format login les utilisateurs du fichier CSV
function login($Nom) {
    $Initiale = $Nom.substring(0,1) 
    $Nom = $Nom.split()[1]
    $InitialePointNom = $Initiale+"."+$Nom
    return $InitialePointNom
}

#Paramètres:
$CheminPartages = "${Lecteur}:\Partages"
$CheminCommuns = "$CheminPartages\Communs"
$CheminUtilisateurs = "$CheminPartages\Utilisateurs"
$DomaineDN = "DC=barzini,DC=local"

$CSV = Import-Csv -Path "$env:USERPROFILE\Desktop\Organigramme.csv" -Delimiter ";"
$OUs = $CSV.OU | Sort-Object -Unique
$NOMS = $CSV.Nom

#Creation du Lecteur $Lecteur et des dossiers

New-Item -ItemType Directory -Path $CheminPartages | Out-Null
Disable-NTFSAccessInheritance -Path $CheminPartages
Clear-NTFSAccess -Path $CheminPartages
Add-NTFSAccess -Path $CheminPartages -Account "NT AUTHORITY\SYSTEM" -AccessRights FullControl -AppliesTo ThisFolderSubfoldersAndFiles
Add-NTFSAccess -Path $CheminPartages -Account "Admins du domaine" -AccessRights FullControl -AppliesTo ThisFolderSubfoldersAndFiles

New-Item -ItemType Directory -Path $CheminCommuns | Out-Null
Clear-NTFSAccess -Path $CheminCommuns
Enable-NTFSAccessInheritance -Path $CheminCommuns
Add-NTFSAccess -Path $CheminCommuns -Account "Utilisateurs du domaine" -AccessRights ReadAndExecute -AppliesTo ThisFolderOnly

New-Item -ItemType Directory -Path $CheminUtilisateurs | Out-Null
Clear-NTFSAccess -Path $CheminUtilisateurs
Enable-NTFSAccessInheritance -Path $CheminUtilisateurs
Add-NTFSAccess -Path $CheminUtilisateurs -Account "Utilisateurs du domaine" -AccessRights ReadAndExecute -AppliesTo ThisFolderOnly
#creation des groupes pour les autorisations NTFS

foreach ($OU in $OUs) {
    try {
        if (($OU) -and -not (Get-ADGroup -filter "Name -eq 'GDL_${OU}_RW'") -and -not (Get-ADGroup -filter "Name -eq 'GDL_${OU}_RO'")) {
            New-ADGroup -Name "GDL_${OU}_RW" `
                        -GroupScope "DomainLocal" `
                        -GroupCategory "Security" `
                        -Path "OU=Groupes,$DomaineDN"

            New-ADGroup -Name "GDL_${OU}_RO" `
                        -GroupScope "DomainLocal" `
                        -GroupCategory "Security" `
                        -Path "OU=Groupes,$DomaineDN"
        }
    } catch {
    Write-Host "Erreur lors de la creation des groupes AD locaux: $_"
    }
}
#Exportation CSV pour crée les Partages Communs

foreach ($OU in $OUs) {
    try {
        $Path = "$CheminCommuns\$OU"
        if (($OU) -and -not (Test-Path $Path)) {
            New-Item -ItemType Directory -Path $Path | Out-Null
            Clear-NTFSAccess $Path
            Enable-NTFSAccessInheritance $Path
            Add-NTFSAccess -Path $Path -Account "GDL_${OU}_RW" -AccessRights ReadAndExecute, ListDirectory, ReadAttributes, ReadExtendedAttributes, WriteAttributes, WriteExtendedAttributes, CreateFiles, CreateDirectories, WriteData, AppendData, DeleteSubdirectoriesAndFiles
            Add-NTFSAccess -Path $Path -Account "GDL_${OU}_RO" -AccessRights ReadAndExecute
        }
    } catch {
        Write-Host "Erreur lors de la creation des dossiers commun:   $_"
    }    
}
New-SmbShare -Name "Communs" -Path $CheminCommuns -FullAccess "Tout le monde" | Out-Null

foreach ($NOM in $NOMS ) {
    try {    
        $NOM = $NOM.ToLower()
        $login = $(login $NOM)
        $Path = "$CheminUtilisateurs\$login"
        if (($NOM) -and -not (Test-Path $Path)) {
            New-Item -ItemType Directory -Path $Path | Out-Null 
            Clear-NTFSAccess $Path
            Enable-NTFSAccessInheritance $Path
            Add-NTFSAccess -Path $Path -Account "$login" -AccessRights ReadAndExecute, ListDirectory, ReadAttributes, ReadExtendedAttributes, WriteAttributes, WriteExtendedAttributes, CreateFiles, CreateDirectories, WriteData, AppendData, DeleteSubdirectoriesAndFiles
        }
    } catch {
        Write-Host "Erreur lors de la creation des dossiers utilisateurs: $_ "
    }    
}
New-SmbShare -Name "Utilisateurs" -Path $CheminUtilisateurs -FullAccess "Tout le monde" | Out-Null