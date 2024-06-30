# ChatGPT Repo Tools

This PowerShell script helps users transfer their code project to ChatGPT by providing a tree structure view of their project files and allowing them to copy the content of specific files to the clipboard.

## Features

1. List and copy the folder structure to clipboard, respecting the allowed files and excluded folders defined in `config.json` and patterns specified in `.gitignore`.
2. Browse and copy specific files with their relative paths and content to the clipboard.

## Usage

1. Configure the `config.json` file to include the desired file types in `allowedFiles` and folders to exclude in `excludedFolders`.
2. Ensure you have a `.gitignore` file in your project directory if you want to exclude files/folders based on those patterns.
3. Run the appropriate script (`Code2GPT.ps1`, `BrowseAndCopy.ps1`, or `NavigateAndCopy.ps1`) and provide the path to the source folder when prompted.
4. Follow the on-screen instructions to list the folder structure, browse, or copy specific files.

## Exit

Press 'X' to exit the browsing and copying scripts and the complete application.

Enjoy the user-friendly GUI enhanced with emojis and line separators!

## Installation

To install the required dependencies, follow these steps:

1. Open PowerShell as Administrator.
2. Run the following command to install Terminal.Gui:

````powershell
Install-Package -Name Terminal.Gui -Scope CurrentUser


## ToDo

-- Include the behold text in the folder tree listing
-- Make it possible to keep a config file int he project directory to select excluded allowed and so on
-- Excluded folders should work with relative path:s

```powershell
Install-Package -Name Terminal.Gui -Scope CurrentUser
````
