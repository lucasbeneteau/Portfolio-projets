# Force l’arrêt du script en cas d’erreur
$ErrorActionPreference = "Stop"

# === INSTALLATION DU ROLE DHCP ===
Write-Host "Installation du rôle DHCP..."
Install-WindowsFeature -Name DHCP -IncludeManagementTools

# === AUTORISATION DANS L'AD ===
$hostname = "$env:COMPUTERNAME.barzini.local"
$ip = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Ethernet | Where-Object {$_.PrefixOrigin -eq "Manual"}).IPAddress

Write-Host "Autorisation du serveur DHCP dans l'AD..."
Add-DhcpServerInDC -DnsName $hostname -IPAddress $ip

Write-Host "Création des groupes de sécurités pour gérer le service DHCP..."
New-LocalGroup -Name "DHCP Administrators" -Description "Gérer le service DHCP"
New-LocalGroup -Name "DHCP Users" -Description "Accès lecture seule au service DHCP"

Add-LocalGroupMember -Group "DHCP Administrators" -Member "Administrateur"

# === CREATION DU SCOPE ===
Write-Host "Création de la plage DHCP..."
Add-DhcpServerv4Scope `
  -Name "LAN" `
  -StartRange 10.0.0.11 `
  -EndRange 10.0.0.253 `
  -SubnetMask 255.255.255.0 `
  -State Active

# === CONFIGURATION DES OPTIONS DHCP ===
Write-Host "Définition des options DHCP..."
Set-DhcpServerv4OptionValue -ScopeId 10.0.0.0 -Router 10.0.0.254
Set-DhcpServerv4OptionValue -ScopeId 10.0.0.0 -DnsServer 10.0.0.1 -DnsDomain "barzini.local"

# === CONFIGURATION DES REDIRECTEURS DNS ===
Write-Host "Configuration des redirecteurs DNS..."
Set-DnsServerForwarder -IPAddress 8.8.8.8, 1.1.1.1

# === VERIFICATIONS ===
Write-Host "Résumé de la configuration :"
Write-Host "Scopes DHCP :"
Get-DhcpServerv4Scope | Format-Table ScopeId, Name, StartRange, EndRange, LeaseDuration

Write-Host "Options du scope 10.0.0.0 :"
Get-DhcpServerv4OptionValue -ScopeId 10.0.0.0 | Format-Table OptionId, Name, Value

Write-Host "Redirecteurs DNS configurés :"
Get-DnsServerForwarder | Format-Table IPAddress

Write-Host "Terminé. DHCP et DNS sont configurés avec succès."
Read-Host "Appuyez sur Entrée pour fermer"
