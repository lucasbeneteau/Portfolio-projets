<#
========================
Description : Création OUs, utilisateurs et groupes dans Active Directory
Version : 1.0
Auteur : Lucas Beneteau
========================
#>

# Enregistrer tous les flux de sortie
Start-Transcript -Path "C:\Users\Administrateur\Desktop\log_creation_utilisateurs.txt"

# Modules
Import-Module ActiveDirectory

# Paramètres globaux
$Fichier_CSV = "C:\Users\Administrateur\Desktop\Organigramme.csv"
$CSV = Import-Csv -Path $Fichier_CSV -Delimiter ";"
$DomaineDN = "DC=barzini,DC=local"

# Fonction de génération de login
function FormatLogin($Nom) {
    $Initiale = $Nom.Substring(0,1)
    $InitialePointNom = "$Initiale.$($Nom.split()[1])".ToLower()
    return $InitialePointNom
}

# ========================
# Traitement ligne par ligne
# ========================

foreach ($ligne in $CSV) {

    # Lecture des champs
    $OU = $ligne.OU
    $Groupe_primaire = $ligne.Groupe_primaire
    $Groupe_secondaire = $ligne.Groupe_secondaire
    $Poste = $ligne.Poste
    $Nom = $ligne.Nom
    $ouDN = "OU=$OU,$DomaineDN"
    $login = FormatLogin $Nom

    # CrÃ©ation de lâ€™OU
    if ($OU) {
    try {
        if (-not (Get-ADOrganizationalUnit -SearchBase $DomaineDN -Filter "Name -eq '$OU'" -ErrorAction SilentlyContinue)) {
            New-ADOrganizationalUnit -Name $OU -Path $DomaineDN
            Write-Host "âœ… OU crÃ©Ã©e : $ouDN"
        }
    } catch {
        Write-Host "âŒ Erreur lors de la crÃ©ation de lâ€™OU : $_"
        continue
    }
    }

if (-not (Get-ADOrganizationalUnit -Filter "Name -eq 'Groupes'" -SearchBase $DomaineDN -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name Groupes -Path $DomaineDN
        Write-Host "âœ… OU 'Groupes' crÃ©Ã©e"
    }



    # Creation du groupe principal
if ($Groupe_primaire) {
    try {
        if (-not (Get-ADGroup -Filter "Name -eq '$Groupe_primaire'" -ErrorAction SilentlyContinue)) {
            New-ADGroup -Name $Groupe_primaire `
                        -GroupScope Global `
                        -GroupCategory Security `
                        -Path "OU=Groupes,$DomaineDN"
            Write-Host "âœ… Groupe principal crÃ©Ã© : $Groupe_primaire"
        }
    } catch {
        Write-Host "âŒ Erreur crÃ©ation groupe principal : $_"
    }
}
    # Creation du groupe secondaire si necessaire
if ($Groupe_secondaire) {
    try {
        if (-not (Get-ADGroup -Filter "Name -eq '$Groupe_secondaire'" -ErrorAction SilentlyContinue)) {
            New-ADGroup -Name $Groupe_secondaire `
                        -GroupScope Global `
                        -GroupCategory Security `
                        -Path "OU=Groupes,$DomaineDN"
            Write-Host "âœ… Groupe secondaire crÃ©Ã© : $Groupe_secondaire"
        }
    } catch {
        Write-Host "âŒ Erreur crÃ©ation groupe secondaire : $_"
    }

    # Creation de l'utilisateur
    
}
# Vérifie si l'utilisateur existe déjà
$user = Get-ADUser -Filter "SamAccountName -eq '$login'" -ErrorAction SilentlyContinue

if (-not $user) {
    try {
        New-ADUser -Name "$Nom" `
            -SamAccountName $login `
            -UserPrincipalName "$login@barzini.local" `
            -AccountPassword (ConvertTo-SecureString "Temp123!" -AsPlainText -Force) `
            -Enabled $true `
            -ChangePasswordAtLogon $true `
            -Path $ouDN `
            -Title $Poste
        Write-Host "Utilisateur créé : $Nom ($login)"
    } catch {
        Write-Host "Erreur création utilisateur : $_"
        continue
    }
}

    # Ajout aux groupes
    try {
        if ($Groupe_primaire -and -not (Get-ADGroupMember $Groupe_primaire | Where-Object { $_.SamAccountName -eq $login })) {
            Add-ADGroupMember -Identity $Groupe_primaire -Members $login ; if ($?) { Write-Host "$login ajoute aux groupes : $Groupe_primaire" }
        }
        if ($Groupe_secondaire -and -not (Get-ADGroupMember $Groupe_secondaire | Where-Object { $_.SamAccountName -eq $login })) {
        Add-ADGroupMember -Identity $Groupe_secondaire -Members $login ; if ($?) { Write-Host "$login ajoute aux groupes : $Groupe_secondaire" }
        }
    } catch {
        Write-Host "Erreur ajout aux groupes : $_"
    }

}
Write-host "Fin du script !"
# Fin du script
Stop-Transcript