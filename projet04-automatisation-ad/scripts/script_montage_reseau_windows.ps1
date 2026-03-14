<#
==================================
  Script       : script_montage_reseau_windows.ps1
  Version      : 1.0
  Auteur       : Lucas Beneteau
  Date         : 2025-07-11
  Description  : Montage automatique des partages en fonction des groupes AD de l'utilisateur courant.
==================================
#>

Start-Transcript -Path "$HOME\Desktop\montage.log"

Import-Module ActiveDirectory
$PartageCommuns = "\\srv-dc.barzini.local\Communs"
$PartageUtilisateurs = "\\srv-dc.barzini.local\Utilisateurs"
$User = $env:USERNAME
$UserGroups = Get-ADPrincipalGroupMembership -Identity $User |
              Select-Object -ExpandProperty Name

#     Format : LettreLecteur ; UNC ; GroupesAutorisés (séparés par des virgules)
$Shares = @(
    @{ Drive='Y:' ; UNC="$PartageCommuns\Developpement"  ;   Groups='GG_Developpeurs,GG_Managers'                }
    @{ Drive='X:' ; UNC="$PartageCommuns\Audio"          ;   Groups='GG_Audio,GG_Developpeurs,GG_Managers'       }
    @{ Drive='W:' ; UNC="$PartageCommuns\Graphisme"      ;   Groups='GG_Graphistes,GG_Developpeurs,GG_Managers'  }
    @{ Drive='V:' ; UNC="$PartageCommuns\Communication"  ;   Groups='GG_Communication,GG_Managers'               }
    @{ Drive='U:' ; UNC="$PartageCommuns\Direction"      ;   Groups='GG_Direction,GG_Managers'                   }
    @{ Drive='T:' ; UNC="$PartageCommuns\Informatique"   ;   Groups='GG_Informatique,GG_Managers'                }
    @{ Drive='S:' ; UNC="$PartageCommuns\Production"     ;   Groups='GG_Production,GG_Managers'                  }
    @{ Drive='R:' ; UNC="$PartageCommuns\Technique"      ;   Groups='GG_Technique,GG_Managers'                   }
    @{ Drive='Q:' ; UNC="$PartageCommuns\Test"           ;   Groups='GG_Test,GG_Managers'                        }
    @{ Drive='P:' ; UNC="$PartageUtilisateurs\$User"     ;   Groups='Utilisateurs du domaine'                    }
)

# MONTER CHAQUE PARTAGE SI L’UTILISATEUR EST DANS UN GROUPE AUTORISÉ
foreach ($S in $Shares) {

    $GroupesAutorises = $S.Groups -split ','

    # L’utilisateur appartient-il à au moins un groupe autorisé ?
    if ($GroupesAutorises | Where-Object { $UserGroups -contains $_.Trim() }) {

        # Lecteur déjà monté ?
        if ((Get-PSDrive -Name ($S.Drive.TrimEnd(':')) -ErrorAction SilentlyContinue)) {
            Write-Host "$($S.Drive) deja monte."
            continue
        }

        Write-Host "Montage de $($S.UNC) sur $($S.Drive)"
        try {
            net use $($S.Drive) $($S.UNC) /persistent:no >$null 2>&1
            Write-Host "Succes"
        }
        catch {
            Write-Warning "Echec : $_"
        }

    } else {
        Write-Host "Ignore $($S.UNC) (aucun groupe correspondant)"
    }
}

Stop-Transcript
