Import-Module "$PSScriptRoot/UniversalDashboard.psd1"
Import-Module "$PSScriptRoot/UniversalDashboard.CodeEditor/UniversalDashboard.CodeEditor.psd1"
Import-Module "$PSScriptRoot/ud-chatroom.psd1"

$Env:PSModulePath = "$Env:PSModulePath;$PSScriptRoot"

Start-UDChatroom -Wait