.\Utils.ps1

# 🎯 ListAndCopy: Main function that calls GetListItems to retrieve the list of files and folders.
function ListAndCopy($WorkingFolderParameter, $ExcludedFolders, $AllowedFiles, $GitIgnorePatterns) {
    # Call GetListItems to get the list of items and return the result
    $output = GetListItems -path $WorkingFolderParameter -level 0 -ExcludedFolders $ExcludedFolders -AllowedFiles $AllowedFiles -WorkingFolderParameter $WorkingFolderParameter -GitIgnorePatterns $GitIgnorePatterns

    return $output
}

# 🧰 GetListItems: Wrapper function that calls ListItems and returns the output directly.
function GetListItems($path, $level, $ExcludedFolders, $AllowedFiles, $WorkingFolderParameter, $GitIgnorePatterns) {
    # Create a new ArrayList to store the output
    $output = New-Object System.Collections.ArrayList
    # Call the ListItems function with the required parameters
    ListItems -path $path -level $level -output $output -ExcludedFolders $ExcludedFolders -AllowedFiles $AllowedFiles -WorkingFolderParameter $WorkingFolderParameter -GitIgnorePatterns $GitIgnorePatterns
    return $output
}
