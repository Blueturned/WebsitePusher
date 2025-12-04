New-Module -Name Config -ScriptBlock  {
    function ChangeConfigEntry {
        param (
            $config,
            $entry,
            $msg
        )
        try {
            $msg = if ($msg) { $msg } else {"$entry selected to be changed"}
            Write-Host $msg
            $customEntry = Read-Host -Prompt "Please input the $entry"
            $config.$entry = $customEntry
            Write-Host "$entry edited successfully"
        }
        catch {
            Write-Warning "Failed to edit the $entry : $_"
        }
        Start-Sleep -Seconds 1
    }
    
    function SaveConfig {
        param (
            $config
        )
        try {
            $config = ConvertTo-Json $config
            Set-Content -Value $config -Path "CustomConfig.json"
            Write-Host "Sucesfully saved the config"
        }
        catch {
            Write-Warning "Error occured writing to CustomConfig.json: $_"
            return $false
        }
        return $true 
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
            Clear-Host
            Write-Host "Pick one of the following options:"
            Write-Host "0) Exit config"
            Write-Host "1) Change host name"
            Write-Host "2) Change default pushdirectory"
            Write-Host "3) Change default ignore directory"
            Write-Host "4) Change destination directory"
            Write-Host "5) Change back-up directory"
            $userInput = Read-Host "Pick your option"
            switch ($userInput) {
                0 {
                    Write-Host "Exiting config..."
                    SaveConfig -config $config
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
                5 {
                    ChangeConfigEntry -config $config -entry "BackUpDirectory"
                    break
                }
                Default {
                    "No valid input detected."
                }
            }
        }
    }

    Export-ModuleMember -Function EditConfig
    Export-ModuleMember -Function Initialize
}