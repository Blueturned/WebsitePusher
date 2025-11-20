$config = @{
    ModuleSucces = $true
}

Write-Output "Running config."
Write-Output "Checking if necessary modules have been installed..."
if (!(Get-InstalledModule -Name "WinSCP" -ErrorAction SilentlyContinue)) {
    Write-Output "WinSCP has not been installed, attempting to install..."
    try {
        Install-Module -Name "WinSCP" -Scope CurrentUser -Force
        Write-Output "WinSCP has been installed!"
    }
    catch {
        Write-Warning "Couldn't install 'WinSCP' Module: $_"
        $config.ModuleSucces = $false
    }
}

return $config