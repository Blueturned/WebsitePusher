if (!(Get-InstalledModule -Name "WinSCP")) {
    try {
        Install-Module -Name "WinSCP"
    }
    catch {
        Write-Warning "Couldn't install 'WinSCP' Module: $_"
    }
}