Import-Module ".\config.psm1"

$config = Initialize
if ($config -eq $false) {
    Write-Error "initialization failed, exiting script"
    exit 1
}

$userInput = Read-Host -Prompt "Would you like to run the config? [y/n]"
if ($userInput -eq "y" -or $userInput -eq "yes") {
    EditConfig
}

#$ftpServer = "192.168.2.69"

#$cred = Get-Credential
#$sessionOption = New-WinSCPSessionOption -HostName $ftpServer -Protocol ftp -Credential $cred

#New-WinSCPSession -SessionOption $sessionOption

#New-WinSCPItem -Path '/home/blueturned/Documents/test' -ItemType Directory

#Remove-WinSCPSession