<#
    File Management Script
    ======================

    This script is an interactive PowerShell script for file management tasks.
    It provides the following options:

    1. Display ChatGPT Instruction: Displays the ChatGPT instruction and copies it to the clipboard.
    2. Copy folder structure to clipboard: Lists the folder structure (excluding folders specified in config.json) and copies it to the clipboard.
    3. Browse and copy files: Allows browsing of files (filtered by allowedFiles from config.json) and copying their content and relative paths.
    X. Quit: Exits the script.

    Usage:
    ------
    Run the script and provide a working folder path when prompted, or pass it as a parameter when calling the script.

    Example:
    -------
    .\Code2GPT.ps1 "C:\Full\Path\To\Project"
#>

param (
    [string]$WorkingFolder = ""
)

# Remove trailing slash from WorkingFolderParameter
$WorkingFolder = $WorkingFolder.TrimEnd('\')

. .\Utils.ps1
. .\ListAndCopy.ps1
. .\BrowseAndCopy.ps1

$config = Get-Content -Path "config.json" -Raw | ConvertFrom-Json

function ShowMenu($WorkingFolderParameter) {
    $showMenu = $true

    # Läs in .gitignore-mönster
    $gitIgnorePatterns = Get-GitIgnorePatterns -path $WorkingFolderParameter

    while ($showMenu) {
        Clear-Host
        Write-Host "──────────────────────────────────────"
        Write-Host "📂  File Management Script"
        Write-Host "─────────────────────────────────────"
        Write-Host "Select an option:"
        Write-Host "1. 💬 Display ChatGPT Instruction"
        Write-Host "2. 📋 Copy folder structure to clipboard (excluding folders from config.json)"
        Write-Host "3. 🔎 Browse and copy files (filtered by allowedFiles from config.json)"
        Write-Host "X. 🚪 Quit"
        Write-Host "──────────────────────────────────────"
        $choice = Read-Host "Enter your choice"
        switch ($choice) {
            "1" {
                DisplayChatGPTInstruction
                Write-Host
                Write-Host "📋 Instruction copied to clipboard! 😊"
                Write-Host "▶️ Press any key to continue."
                $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
            }
            "2" {
                $result = ListAndCopy -WorkingFolderParameter $WorkingFolderParameter -ExcludedFolders $config.excludedFolders -AllowedFiles $config.allowedFiles -GitIgnorePatterns $gitIgnorePatterns
                Clear-Host
                Write-Host "──────────────────────────────────────"
                Write-Host "📂 Folder Structure:"
                Write-Host "──────────────────────────────────────"
                $text = "Behold, I will now paste a visualization of the folder structure for my coding project. If you understand it just answer '🤖 Understood', otherwise let me know what you need to know.`r`n`r`n"
                $text += $result -join "`r`n"
                
                $text | Write-Host
                $text | Set-Clipboard
                Write-Host
                Write-Host "📋 Copied folder structure to clipboard."
                Write-Host "▶️Press any key to continue."
                $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
                Read-Host
            }
            "3" {
                BrowseAndCopy -AllowedFiles $config.allowedFiles -ExcludedFolders $config.excludedFolders -WorkingFolderParameter $WorkingFolderParameter -ShowNumbers $false -GitIgnorePatterns $gitIgnorePatterns
                Write-Host "▶️Press any key to continue."
                $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
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

function DisplayChatGPTInstruction {
    $config = Get-Content -Path "config.json" -Raw | ConvertFrom-Json
    $instruction = $config.chatGPTInstruction
    Write-Host "──────────────────────────────────────"
    Write-Host "💬 ChatGPT Instruction:"
    Write-Host "──────────────────────────────────────"
    Write-Host $instruction
    $instruction | Set-Clipboard
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
    Write-Host "Press any key to exit."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    Read-Host
}
