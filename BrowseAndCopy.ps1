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

    function DisplayFiles($workingFolderParameter, $fileList, $showNumbers) {
        $fileIndex = 1
        $level = 0
        $prevDir = ""
        foreach ($file in $fileList) {
            $relativePath = $file.DirectoryName.Replace($WorkingFolderParameter, '').TrimStart('\')
            $splitPath = $relativePath -split '\\'
            $level = $splitPath.Count

            # Write-Host "relativePath - $relativePath"
            # Write-Host "WorkingFolderParameter - $WorkingFolderParameter"
            # Write-Host "file.DirectoryName - $file.DirectoryName"
            # Write-Host $file.DirectoryName
            # Write-Host "splitPath - $splitPath"
            # Write-Host "level - $level"
            # Write-Host "splitPath.Count - $splitPath.Count"
            # Write-Host "Intendet: $(GetIndentation ($level - 1))"
            # Read-Host

            if ($prevDir -ne $relativePath) {
                Write-Host "$(GetIndentation ($level - 1))📂 $relativePath"
                $prevDir = $relativePath
            }

            $fileText = "[$fileIndex] $(GetIndentation ($level - 1))┣ 📄 $($file.Name)"
            if ($showNumbers) {
                Write-Host "$fileText"
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

        DisplayFiles -workingFolderParameter $WorkingFolderParameter -fileList $files -showNumbers $ShowNumbers
        Write-Host "──────────────────────────────────────"
        Write-Host "Enter the number corresponding to the file you want to copy or type 'X' to quit."
        Write-Host "Type 'A' to copy all filenames with relative paths followed by the code."
        Write-Host ">" -NoNewline

        $keyInput = Read-Host
        if ($keyInput -eq 'X' -or $keyInput -eq 'x') {
            break
        }
        elseif ($keyInput -eq 'A' -or $keyInput -eq 'a') {
            $allFilesContent = ""
            foreach ($file in $files) {
                $relativePath = $file.DirectoryName -ireplace [regex]::Escape($WorkingFolderParameter), ''
                $relativePath = $relativePath.TrimStart('\')
                $content = Get-Content -Path $file.FullName -Raw
                $allFilesContent += "$relativePath`r`n`r`n$content`r`n`r`n"
            }
            $allFilesContent | Set-Clipboard
            Write-Host "📋 Copied all filenames with relative paths followed by the code to clipboard."
            Write-Host "▶️ Press any key to continue."
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        }
        elseif ($keyInput -match '^\d+$' -and [int]$keyInput -ge 1 -and [int]$keyInput -le $files.Count) {
            $currentIndex = [int]$keyInput - 1
            $selectedFile = $files[$currentIndex]
            $relativePath = $selectedFile.DirectoryName -ireplace [regex]::Escape($WorkingFolderParameter), ''
            $relativePath = $relativePath.TrimStart('')
            $content = Get-Content -Path $selectedFile.FullName -Raw
            
            $config = Get-Content -Path "config.json" -Raw | ConvertFrom-Json
            $formattedContent = "$($config.prepareForCodeMessage)`r`n"
            $formattedContent += $relativePath + "`r`n"

            if ($content) {
                $formattedContent += $content
                $formattedContent | Set-Clipboard
                Write-Host "📋 Copied relative path and content of $($selectedFile.Name) to clipboard."
                Write-Host "▶️ Press any key to continue."
                $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
            }
            else {
                Write-Host "❌ Error: file content is empty."
                Write-Host "▶️ Press any key to continue."
                $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
            }
        }
    }
}