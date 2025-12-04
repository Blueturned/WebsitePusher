#=========================================================================================
# WebsitePusher
# Made by Blueturned
# V0.2
#=========================================================================================

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
$sessionOption

$sessionType = Read-Host -Prompt "Would you like to use: 1) SFTP 2) FTP? (Defaults to FTP)"
if ($sessionType -ne "1" -or $sessionType -ne "SFTP" -or $sessionType -ne "sftp") {
    $sessionOption = New-WinSCPSessionOption -HostName $userConfig.HostName -Protocol Sftp -Credential $cred
else {
    $sessionOption = New-WinSCPSessionOption -HostName $userConfig.HostName -Protocol ftp -Credential $cred
    }
}

New-WinSCPSession -SessionOption $sessionOption

try {
    Write-Host "Creating back-up... "
    $backUp = Get-WinSCPItem -Path $userConfig.DestinationDirectory
    Write-Host "Done!" -NoNewline
    Write-Host "Copying files to back-up folder... "

    Write-Host "Done!" -NoNewline
}
catch {
    Write-Warning "Failed to create a back-up: $_, exiting script."
    exit 1
}


New-WinSCPItem -Path $userConfig.DestinationDirectory -ItemType Directory

Remove-WinSCPSession