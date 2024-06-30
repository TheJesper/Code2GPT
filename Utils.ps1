# 📏 GetIndentation: Returns indentation spaces based on the provided level.
function GetIndentation($level) {
    if ([string]::IsNullOrEmpty($level)) {
        return "0"
    }
    
    $indentation = ""
    for ($i = 0; $i -lt $level; $i++) {
        $indentation += "   "
    }
    return $indentation
}

# 📚 ListItems: Recursively lists files and folders, filtering by allowedFiles, excludedFolders, and gitignore patterns.
function ListItems($path, $level, $output, $ExcludedFolders, $AllowedFiles, $WorkingFolderParameter, $GitIgnorePatterns) {
    # Get all items from the given path
    try {
        $items = Get-ChildItem -Path $path -ErrorAction Stop
    }
    catch {
        Write-Host "❌ Error while accessing path: $path"
        Write-Host "Error details: $_"
        Read-Host
        return
    }

    # Loop through each item in the current path
    foreach ($item in $items) {
        $exclude = $false

        # Check if the item is in the excluded folders list or matches a gitignore pattern
        foreach ($excludedFolder in $ExcludedFolders) {
            if ($item.FullName -match [regex]::Escape("\$excludedFolder\")) {
                $exclude = $true
                break
            }
        }

        # Check against gitignore patterns
        if (!$exclude) {
            foreach ($pattern in $GitIgnorePatterns) {
                $regexPattern = [regex]::Escape($pattern).Replace("\*", ".*").Replace("\?", ".")
                $regexPattern = "^" + $regexPattern + "$"
                if ($item.FullName -match $regexPattern) {
                    $exclude = $true
                    break
                }
            }
        }

        # If the item is not excluded, process it
        if (!$exclude) {
            $relativePath = $item.FullName -ireplace [regex]::Escape($WorkingFolderParameter), ''
            $relativePath = $relativePath.TrimStart('\')

            # If the item is a directory, process its contents recursively
            if ($item -is [System.IO.DirectoryInfo]) {
                $row = "$(GetIndentation $level)📦$relativePath"
                [void]$output.Add($row)
                Write-Host "Added row: $row"
                ListItems -path $item.FullName -level ($level + 1) -output $output -ExcludedFolders $ExcludedFolders -AllowedFiles $AllowedFiles -WorkingFolderParameter $WorkingFolderParameter -GitIgnorePatterns $GitIgnorePatterns
            }
            # If the item is a file, check if it's in the allowed files list and add it to the output
            elseif ($item -is [System.IO.FileInfo]) {
                foreach ($allowedFile in $AllowedFiles) {
                    if ($item.Name -like $allowedFile) {
                        $row = "$(GetIndentation $level)┣ 📜$($item.Name)"
                        [void]$output.Add($row)
                        break
                    }
                }
            }
        }
    }
}

# Get-GitIgnorePatterns: Reads .gitignore file and returns an array of patterns.
function Get-GitIgnorePatterns($path) {
    $gitignorePath = Join-Path -Path $path -ChildPath ".gitignore"
    if (Test-Path -Path $gitignorePath) {
        $patterns = Get-Content -Path $gitignorePath -ErrorAction SilentlyContinue |
                    Where-Object { -not [string]::IsNullOrWhiteSpace($_) -and -not $_.StartsWith("#") }
        return $patterns
    }
    return @()
}
