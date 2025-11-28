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

$userConfig = Get-Content -Raw "CustomConfig.json" | ConvertFrom-Json

$cred = Get-Credential
$sessionOption = New-WinSCPSessionOption -HostName $userConfig.HostName -Protocol ftp -Credential $cred

New-WinSCPSession -SessionOption $sessionOption

New-WinSCPItem -Path $userConfig.DestinationDirectory -ItemType Directory

Remove-WinSCPSession