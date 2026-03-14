#Installation des roles AD
Install-WindowsFeature AD-Domains-Services

#Création du mot de passe
$SecurePassword = Read-Host "Entrez le mot de passe DSRM (mode sans échec AD)" -AsSecureString

#Promotion du serveur en contrôleur de domaine
Install -ADDSForest `
-DomainName "barzini.local" `
-DomainNetbiosName "BARZINI" `
-SafeModeAdministratorPassword $SecurePassword `
-InstallDNS ` #On  installe le rôle DNS ici. Il sera automatiquement configuré.
-Force