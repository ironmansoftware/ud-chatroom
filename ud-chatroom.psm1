function Start-UDChatroom {
    param($Port = 10000, [Switch]$AllowHttpForLogin)
    $loginPage = New-UDLoginPage -AuthenticationMethod @(
        New-UDAuthenticationMethod -Endpoint {
            param([PSCredential]$Credentials)
    
            New-UDAuthenticationResult -Success -UserName $Credentials.UserName
        }   
    ) 
    
    $dashboard = New-UDDashboard -Title "PowerShell Universal Dashboard Chatroom" -Content {
        New-UDRow -Columns { 
            New-UDColumn -Size 12 -Endpoint {
                $Messages = Invoke-PostgreSqlQuery -Sql "SELECT timestamp, message, user_name FROM chat_log ORDER BY Timestamp DESC LIMIT 10" -ConnectionString $ConnectionString
    
                [array]::Reverse($Messages)
    
                New-UDElement -Tag "ul" -Id "chatroom" -Attributes @{ className = "collection" } -Content {
                    Foreach($Message in $Messages) {
                        New-UDElement -Tag "li" -Attributes @{ className = "collection-item" } -Content {
                            "$($Message.timestamp) $($Message.user_name) : $($Message.message)"
                        }
                    }
                }
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
                        $MessageTimestamp = Get-Date
                        $txtMessage = Get-UDElement -Id "message" 
                        $MessageContent = $txtMessage.Attributes['value']
    
                        if ([String]::IsNullOrEmpty($MessageContent)) {
                            return
                        }
    
                        $params = @{"ts"=$MessageTimestamp; "m"=$MessageContent; "u"=$User}
    
                        "INSERT INTO chat_log (timestamp, message, user_name) VALUES (@ts, @m, @u);" | Invoke-PostgreSqlQuery -Parameters $params -ConnectionString $ConnectionString -CUD
    
                        $message = New-UDElement -Tag "li" -Attributes @{ className = "collection-item" } -Content {
                            
                            "$MessageTimestamp $User : $MessageContent "
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
    } -LoginPage $LoginPage -EndpointInitializationScript {
        Import-Module InvokeQuery
        $ConnectionString = "User Id=postgres;host=localhost;Database=udchatroom"
    }
    
    Start-UDDashboard -Port $Port -Dashboard $dashboard -AllowHttpForLogin:$AllowHttpForLogin
}

