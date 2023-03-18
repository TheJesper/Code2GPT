# Make sure you've imported Utils.ps1
. .\Utils.ps1

# BuildTree: Recursive function that generates a tree structure based on the given tree items and parent path.
function BuildTree($treeItems, $parentPath) {
    $children = @()

    foreach ($item in $treeItems) {
        $path = Join-Path $parentPath $item
        $isDirectory = -not $item.Contains('.')
        $node = @{
            Path     = $path
            Children = @()
        }

        if ($isDirectory) {
            $node.Children = BuildTree $treeItems -split [regex]::Escape($item + '\') | Where-Object { $_ } | ForEach-Object { $_.Substring($item.Length + 1) } $path
        }

        $children += $node
    }

    return $children
}

# GetTreeItems: Function that retrieves the tree items using the GetListItems function from Utils.ps1
function GetTreeItems($WorkingFolderParameter, $ExcludedFolders, $AllowedFiles) {
    $output = GetListItems -path $WorkingFolderParameter -level 0 -ExcludedFolders $ExcludedFolders -AllowedFiles $AllowedFiles -WorkingFolderParameter $WorkingFolderParameter
    return $output -replace [regex]::Escape($WorkingFolderParameter), ''
}

$WorkingFolderParameter = "C:\Jesper\Conzeon\Walley\Repos\KTCL\kibanana-frontend"
$ExcludedFolders = @()
$AllowedFiles = @("*.*")

$treeItems = GetTreeItems $WorkingFolderParameter $ExcludedFolders $AllowedFiles

$treeData = @{
    Path     = $WorkingFolderParameter
    Children = @()
}

$treeData.Children = BuildTree $treeItems $treeData.Path

# Set the culture information for the current thread
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture
[System.Threading.Thread]::CurrentThread.CurrentUICulture = [System.Globalization.CultureInfo]::InvariantCulture

# Create a new TreeView and set its dimensions to fill the available space
$treeView = New-Object Terminal.Gui.TreeView
$treeView.Width = Terminal.Gui.Dim.Fill()
$treeView.Height = Terminal.Gui.Dim.Fill()

# AddNodes: Function to add nodes to the tree view
function AddNodes($treeView, $nodes) {
    foreach ($node in $nodes) {
        $treeNode = New-Object Terminal.Gui.TreeNode($node.Path)
        if ($node.Children.Count -gt 0) {
            AddNodes $treeNode $node.Children
        }
        $treeView.AddNode($treeNode)
    }
}

# Add the nodes to the tree view
AddNodes $treeView $treeData.Children

# Show the selected item in the tree view
$treeView.SelectedItem
