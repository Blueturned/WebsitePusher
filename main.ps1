$config = & .\config.ps1

if (-not $config.ModuleSucces) {
    Write-Error "Config failed, exiting script"
    exit 1
}

$ftpServer = "192.168.2.69"

$cred = Get-Credential
$sessionOption = New-WinSCPSessionOption -HostName $ftpServer -Protocol ftp -Credential $cred

New-WinSCPSession -SessionOption $sessionOption

New-WinSCPItem -Path '/home/blueturned/Documents/test' -ItemType Directory

Remove-WinSCPSession