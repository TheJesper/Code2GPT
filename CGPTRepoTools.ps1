param (
    [string]$WorkingFolder = ""
)

. .\Utils.ps1
. .\ListAndCopy.ps1
. .\BrowseAndCopy.ps1

$config = Get-Content -Path "config.json" -Raw | ConvertFrom-Json

function ShowMenu($WorkingFolderParameter) {
    $showMenu = $true
    while ($showMenu) {
        Clear-Host
        Write-Host "──────────────────────────────────────"
        Write-Host "📂  File Management Script"
        Write-Host "─────────────────────────────────────"
        Write-Host "Select an option:"
        Write-Host "1. 📋 Copy folder structure to clipboard (excluding folders from config.json)"
        Write-Host "2. 🔎 Browse and copy files (filtered by allowedFiles from config.json)"
        Write-Host "X. 🚪 Quit"
        Write-Host "──────────────────────────────────────"
        $choice = Read-Host "Enter your choice"
        switch ($choice) {
            "1" {
                $result = ListAndCopy -WorkingFolderParameter $WorkingFolderParameter -ExcludedFolders $config.excludedFolders -AllowedFiles $config.allowedFiles
                Clear-Host
                Write-Host "──────────────────────────────────────"
                Write-Host "📂 Folder Structure:"
                Write-Host "──────────────────────────────────────"
                $result -join "`r`n" | Write-Host
                $result -join "`r`n" | Set-Clipboard
                Write-Host
                Write-Host "📋 Copied folder structure to clipboard."
                Start-Sleep -Seconds 4
            }
            "2" {
                BrowseAndCopy -AllowedFiles $config.allowedFiles -ExcludedFolders $config.excludedFolders -WorkingFolderParameter $WorkingFolderParameter -ShowNumbers $false
            }
            "X" { $showMenu = $false }
            "x" { $showMenu = $false }
            default {
                Write-Host "❌ Invalid choice. Please try again."
                Start-Sleep -Seconds 2
            }
        }
    }   
}


if (-not $WorkingFolder) {
    $WorkingFolder = Read-Host "Enter the source folder path"
}

if ([string]::IsNullOrWhiteSpace($WorkingFolder)) {
    Write-Host "❌ Error: No source folder provided. Please provide a valid folder path."
    exit
}

try {
    ShowMenu -WorkingFolderParameter $WorkingFolder
}
catch {
    Write-Host "An error occurred: $_"
    Write-Host "Press Enter to exit."
    Read-Host
}