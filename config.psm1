New-Module -Name Config -ScriptBlock  {
    function ChangeConfigEntry {
        param (
            $config
            $entry,
            $msg
        )
        $msg = if ($msg) { $msg} else {"$entry selected to be changed"}
        Write-Host $msg
        $customEntry = Read-Host -Prompt "Please input the $entry"
        $config[$entry] = $customEntry
    }
    
    function SaveConfig {
        param (
            $config
        )
        try {
            $config = ConvertTo-Json $config
            Set-Content -Value $config -Path "CustomConfig.json"
        }
        catch {
            Write-Warning "Error occured writing to CustomConfig.json: $_"
            return $false
        }
    }

    function Initialize { 
        $config = Get-Content -Raw "CustomConfig.json" | ConvertFrom-Json

        Write-Host "Running config."
        Write-Host "Checking if necessary modules have been installed..."
        if (!(Get-InstalledModule -Name "WinSCP" -ErrorAction SilentlyContinue)) {
            Write-Host "WinSCP has not been installed, attempting to install..."
            try {
                Install-Module -Name "WinSCP" -Scope CurrentUser -Force
                Write-Host "WinSCP has been installed!"
            }
            catch {
                Write-Warning "Couldn't install 'WinSCP' Module: $_"
                return $false
            }
        }

        if (!$config.HostName) {
            ChangeConfigEntry -config $config -entry "HostName" -msg "No hostname found in the custom config"
        }

        if (!$config.DestinationDirectory) {
            ChangeConfigEntry -config $config -entry "DestinationDirectory" -msg "No destination directory found in the custom config"
        }

        $success = SaveConfig -config $config
        if (!$success) { return $false }
        Write-Host "Config succesful" -ForegroundColor Green
        return $true
    }

    function EditConfig {
        $config = Get-Content -Raw "CustomConfig.json" | ConvertFrom-Json
        $running = $true
        while ($running) {
            cls
            Write-Host "Pick one of the following options:"
            Write-Host "0) Exit config"
            Write-Host "1) Change host name"
            Write-Host "2) Change default pushdirectory"
            Write-Host "3) Change default ignore directory"
            Write-Host "4) Change destination directory"
            $userInput = Read-Host "Pick your option"
            switch ($userInput) {
                0 {
                    Write-Host "Exiting config..."
                    return
                    break
                }
                1 {
                    ChangeConfigEntry -config $config -entry "HostName"
                    break
                }
                2 {
                    ChangeConfigEntry -config $config -entry "PushDirectory"
                    break
                }
                3 {
                    ChangeConfigEntry -config $config -entry "IgnoreDirectory"
                    break
                }
                4 {
                    ChangeConfigEntry -config $config -entry "DestinationDirectory"
                    break
                }
                Default {
                    "No valid input detected."
                }
            }
        }
        SaveConfig -config $config
    }

    Export-ModuleMember -Function EditConfig
    Export-ModuleMember -Function Initialize
}