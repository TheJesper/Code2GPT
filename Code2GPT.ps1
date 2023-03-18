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
                Write-Host "📋 Instruction copied to clipboard! 😊 Press Enter to continue..."
                Read-Host
            }
            "2" {
                $result = ListAndCopy -WorkingFolderParameter $WorkingFolderParameter -ExcludedFolders $config.excludedFolders -AllowedFiles $config.allowedFiles
                Clear-Host
                Write-Host "──────────────────────────────────────"
                Write-Host "📂 Folder Structure:"
                Write-Host "──────────────────────────────────────"
                $text = "Behold, I will now paste a visualization of the folder structure for my coding project. If you understand it just answer '🤖 Understood', otherwise let me know what you need to know.`r`n`r`n"
                $text += $result -join "`r`n"
                
                $text | Write-Host
                $text | Set-Clipboard
                Write-Host
                Write-Host "📋 Copied folder structure to clipboard. Press Enter to continue..."
                Write-Host ""
                Read-Host
            }
            "3" {
                BrowseAndCopy -AllowedFiles $config.allowedFiles -ExcludedFolders $config.excludedFolders -WorkingFolderParameter $WorkingFolderParameter -ShowNumbers $false
                Write-Host "Press Enter to continue..."
                Read-Host
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
    Write-Host "Press Enter to exit."
    Read-Host
}