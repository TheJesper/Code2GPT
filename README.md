# ChatGPT Repo Tools

This PowerShell script helps users transfer their code project to ChatGPT by providing a nice tree structure view of their project files and allowing them to copy the content of specific files to the clipboard.

## Features

1. List and copy the folder structure to clipboard, respecting the allowed files and excluded folders defined in `config.json`.
2. List the folder structure with numbers in front of each file, allowing users to select a file to copy its relative path, a blank line, and the content to the clipboard.

## Usage

1. Configure the `config.json` file to include the desired file types in `allowedFiles` and folders to exclude in `excludedFolders`.
2. Run the `CGPTRepoTools.ps1` script and provide the path to the source folder when prompted.
3. Select the desired option from the menu to list the folder structure or browse and copy specific files.

## Exit

Press 'X' to exit both menu option 2 and the complete application.

Enjoy the user-friendly GUI enhanced with emojis and line separators!

## ToDo

1. Add option to copy all code in one go

## Installation

To install the required dependencies, follow these steps:

1. Open PowerShell as Administrator.
2. Run the following command to install Terminal.Gui:

```powershell
Install-Package -Name Terminal.Gui -Scope CurrentUser
```
