
$loginPage = New-UDLoginPage -AuthenticationMethod @(
    New-UDAuthenticationMethod -Endpoint {
        param([PSCredential]$Credentials)

        New-UDAuthenticationResult -Success -UserName $Credentials.UserName
    }   
) 

$dashboard = New-UDDashboard -Title "PowerShell Universal Dashboard Chatroom" -Content {
    New-UDRow -Columns { 
        New-UDColumn -Size 12 {
            New-UDElement -Tag "ul" -Id "chatroom" -Attributes @{ className = "collection" }
        }
    }

    New-UDRow -Columns { 
        New-UDColumn -Size 8 {
            New-UDElement -Id "message" -Tag "input" -Attributes @{
                type = "text"
                value = ''
                placeholder = "Type a chat message"
            }
        }
        New-UDColumn -Size 2 {
            New-UDElement -Tag "a" -Attributes @{
                className = "btn"
                onClick = {
                    $message = New-UDElement -Tag "li" -Attributes @{ className = "collection-item" } -Content {
                        $txtMessage = Get-UDElement -Id "message" 
                        "$(Get-Date) $User : $($txtMessage.Attributes['value'])"
                    }
                    
                    Set-UDElement -Id "message" -Attributes @{ 
                        type = "text"
                        value = ''
                        placeholder = "Type a chat message" 
                    }

                    Add-UDElement -ParentId "chatroom" -Content { $message } -Broadcast
                }
            } -Content {"Send"}
        }

        New-UDColumn -Size 2 {
            New-UDElement -Tag "a" -Attributes @{
                className = "btn"
                onClick = {
                    Clear-UDElement -Id "chatroom"
                }
            } -Content {"Clear Messages"}
        }
    }
} -LoginPage $LoginPage

Start-UDDashboard -Port 10001 -Dashboard $dashboard -AllowHttpForLogin