.\Utils.ps1

function BrowseAndCopy($AllowedFiles, $ExcludedFolders, $WorkingFolderParameter, $ShowNumbers = $true) {
    $files = Get-ChildItem -Path $WorkingFolderParameter -Recurse -File |
    Where-Object {
        $includeFile = $false
        foreach ($pattern in $AllowedFiles) {
            if ($_.Name -like $pattern) {
                $includeFile = $true
                break
            }
        }

        if ($includeFile) {
            foreach ($excludedFolder in $ExcludedFolders) {
                if ($_.DirectoryName -like "*\$excludedFolder\*") {
                    $includeFile = $false
                    break
                }
            }
        }

        return $includeFile
    }

    function DisplayFiles($fileList, $showNumbers) {
        $fileIndex = 1
        $level = 0
        $prevDir = ""
        foreach ($file in $fileList) {
            $relativePath = $file.DirectoryName.Replace($WorkingFolderParameter, '').TrimStart('\')
            $splitPath = $relativePath -split '\\'
            $level = $splitPath.Count
            if ($prevDir -ne $relativePath) {
                Write-Host "$(GetIndentation ($level - 1))📂 $relativePath"
                $prevDir = $relativePath
            }

            $fileText = "$(GetIndentation $level)┣ 📄 $($file.Name)"
            if ($showNumbers) {
                Write-Host "[$fileIndex] $fileText"
            }
            else {
                Write-Host "$fileText"
            }

            $fileIndex++
        }
    }

    while ($true) {
        Clear-Host
        Write-Host "──────────────────────────────────────"
        Write-Host "📂  Browse and Copy Files"
        Write-Host "──────────────────────────────────────"
        Write-Host "Enter the number corresponding to the file you want to copy or type 'X' to quit."

        DisplayFiles -fileList $files -showNumbers $ShowNumbers
        Write-Host "──────────────────────────────────────"

        $keyInput = Read-Host
        if ($keyInput -eq 'X' -or $keyInput -eq 'x') {
            break
        }
        elseif ($keyInput -match '^\d+$' -and [int]$keyInput -ge 1 -and [int]$keyInput -le $files.Count) {
            $currentIndex = [int]$keyInput - 1
            $selectedFile = $files[$currentIndex]
            $relativePath = $selectedFile.DirectoryName -ireplace [regex]::Escape($WorkingFolderParameter), ''
            $relativePath = $relativePath.TrimStart('\')
            $content = Get-Content -Path $selectedFile.FullName -Raw
            $formattedContent = "$relativePath`r`n`r`n$content"

            $formattedContent | Set-Clipboard
            Write-Host "📋 Copied relative path and content of $($selectedFile.Name) to clipboard."
            Start-Sleep -Seconds 2
        }
       
        else {
            Write-Host "❌ Invalid keyInput. Please enter a number between 1 and $($files.Count) or 'X' to quit."
            Start-Sleep -Seconds 2
        }
    }
}