#=========================================================================================
# WebsitePusher
# Made by Blueturned
# V0.2
#=========================================================================================

Import-Module ".\config.psm1" #Import the config module

$config = Initialize #Running the config initialization
if ($config -eq $false) { #Quits script if config fails
    Write-Error "initialization failed, exiting script"
    exit 1
}

$userInput = Read-Host -Prompt "Would you like to run the config? [y/n]"
if ($userInput -eq "y" -or $userInput -eq "yes") {
    EditConfig #opens the config editor in the config.psm1 module
}

$userConfig = Get-Content -Raw "CustomConfig.json" | ConvertFrom-Json #Reads the data from the json file

$cred = Get-Credential #Gets the username and password for the server

$sessionType = Read-Host -Prompt "Would you like to use: 1) SFTP 2) FTP? (Defaults to FTP)"
if ($sessionType -eq "1" -or $sessionType -eq "SFTP" -or $sessionType -eq "sftp") {
    $sessionOption = New-WinSCPSessionOption -HostName $userConfig.HostName -Protocol Sftp -Credential $cred -SshHostKeyFingerprint "ssh-ed25519 255 IGwcV+vWUNpu4CTFrU8uMHnH2quLJv4wYx6ltB+mZB8" #Opens the session in SFTP, using the sshhostkeyfingerprint
}
else {
    $sessionOption = New-WinSCPSessionOption -HostName $userConfig.HostName -Protocol ftp -Credential $cred #Opens the session in FTP mode
}

try {
    Write-Host "Creating back-up... " -NoNewline

    New-WinSCPSession -SessionOption $sessionOption | Out-Null #Opens the session

    Receive-WinSCPItem  -RemotePath $userConfig.DestinationDirectory -LocalPath $userConfig.BackUpDirectory -ErrorAction Stop #Gets files from the remote directory
    
    Write-Host "Done!"
    Write-Host "Pushing new files to the server... " -NoNewline
    
    Send-WinSCPItem -RemotePath $userConfig.DestinationDirectory -LocalPath $userConfig.PushDirectory -ErrorAction Stop #Uploads files from the local directory to the remote directory

    Write-Host "Done!"
}
catch {
    Write-Warning "Failed to create a back-up and/or pushing files: $_, exiting script."
    exit 1
}
finally {
    Remove-WinSCPSession
}

