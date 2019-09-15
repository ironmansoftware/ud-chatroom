#Copy-Item ./ud-chatroom.psd1 $Env:Build_ArtifactStagingDirectory
#Copy-Item ./ud-chatroom.psm1 $Env:Build_ArtifactStagingDirectory
Save-Module -Name UniversalDashboard -Path "./" -AcceptLicense