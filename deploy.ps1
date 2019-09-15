param($Staging)

Copy-Item ./ud-chatroom.psd1 $Staging
Copy-Item ./ud-chatroom.psm1 $Staging
Save-Module -Name UniversalDashboard -Path $Staging -AcceptLicense