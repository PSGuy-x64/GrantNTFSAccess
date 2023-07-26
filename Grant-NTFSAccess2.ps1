<#
.SYNOPSIS
    Grant NTFS full acess for RootFolder include subfolders.

.DESCRIPTION
    Expoert report for subfolders missingfull access for specified group

.PARAMETER Param1
    RootFolder
    Identity

.EXAMPLE
    PS .\Grant-NTFSAccess.ps1 -RootFolder 'C:\Share\' -Identity 'CONTOSO\ShareAdmin'

.INPUTS
    NA

.OUTPUTS
    'Grant-NTFSAcces_yyyymmdd_hhmmss.csv'

.NOTES
    Author            : PS Guy.
    Owner Contact     : psguy-x64@outlook.com.
    Version           : 1.0
    Script send mail  : False.
    Script export csv : true.
    Script Nick Name  : London

    Version 1.0 - 2023/07/11 by Ahmed Samir, initial release.
#>


#---------------------------------------------------------[      Parameters   ]--------------------------------------------------------
[cmdletbinding()]
Param (
[Parameter(Mandatory=$true,Position=0)]
[string]$RootFolder,
[Parameter(Mandatory=$true,Position=1)]
[string]$Identity
)

#---------------------------------------------------------[   Initialisations  ]--------------------------------------------------------
 cls
 if (!([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544')) { clear-host; Read-Host "Please run PowerShell As Administrator and rerun this commands, Press any key to exit"; exit }
 $date      = Get-Date -Format yyyyMMdd_HHmmss
 $log       = 'log' + $date + '.csv'
 Start-Transcript -Path $log | Out-Null
 $Report    = 'Grant-NTFSAccess_' + $date + '.csv'
 $log       = 'log' + $date + '.csv'
 $Folder    = dir $RootFolder -Directory -Recurse 
 $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
 Write-Host ' '
 Write-Host 'Script run with user: ' $user -b White -f Black
 Write-Host ' '
 Write-Host 'Checking ' $Identity ' Access on ' $RootFolder -b Yellow -f Black
 Write-Host ' '
 if ($user -ne 'NT AUTHORITY\SYSTEM'){ Write-Host -b Red -f White 'NOTE: script not run with NT AUTHORITY\SYSTEM access'}
 Write-Host ' '
 Write-Host 'Getting report...' -f Black -b White ; Write-Host ' '
 $Final = @()
 $i     = 1 
 $i2    = 1
#---------------------------------------------------------[      Execution     ]--------------------------------------------------------

#---------------------------------------------------------[     Functions      ]--------------------------------------------------------  
     
 foreach ($path in $Folder.FullName) {
 Write-Host [$i]$path -f Green
         $acl = (Get-Acl $Path).Access | ? {$_.IdentityReference -eq $Identity} | select IdentityReference,FileSystemRights
         if (($acl.IdentityReference.Value -eq $Identity) -and ($acl.FileSystemRights -eq 'FullControl')) {$Acess='True'} else {$Acess='False'}
          $temp =  New-Object System.Object
                   $temp | Add-Member -MemberType NoteProperty -Name I        -Value $i
                   $temp | Add-Member -MemberType NoteProperty -Name Path     -Value $path
                   $temp | Add-Member -MemberType NoteProperty -Name ITAccess -Value $Acess
         $Final += $temp
  
 $i++}
  $Final | select |Export-Csv -NoTypeInformation $Report ; $Final | ft
  $action = $Final| ? {$_.ITAccess -eq 'False'}
  Write-Host ' '
  if ($Action) {
  Write-Host 'Granting Access for...' $action.count -f Black -b White ; Write-Host ' '
 foreach ($folder in ($action).Path) {
  Write-Host [$i] $folder -f Green
 $Identity1  = $Identity + ':(OI)(CI)f'
 icacls $folder /grant $Identity1 /T /C /L /Q
 $i2++}
 } else {Write-Host 'no action needed..' -f Gray}
#---------------------------------------------------------[      Notfication   ]--------------------------------------------------------


#---------------------------------------------------------[      Finish UP     ]--------------------------------------------------------
Stop-Transcript | Out-Null
