param($Staging)

Copy-Item ./ud-chatroom.psd1 $Staging
Copy-Item ./ud-chatroom.psm1 $Staging
Copy-Item ./dashboard.ps1 $Staging
Save-Module -Name UniversalDashboard -Path $Staging -AcceptLicense -RequiredVersion 2.6 
Copy-Item -Path "$Staging/UniversalDashboard/2.6.0/*" -Destination $Staging -Container
Remove-Item -Path "$Staging/UniversalDashboard/2.6.0" -Force -Recurse 