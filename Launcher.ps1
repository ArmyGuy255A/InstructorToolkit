#requires -version 5
<#
.SYNOPSIS
The Launcher.ps1 is the starting point for the Instructor Toolkit.

.DESCRIPTION
This script should be used to interact with the Instructor Toolkit

.EXAMPLE
PS C:\InstructorToolkit> .\Launcher.ps1

.LINK
'https://github.com/ArmyGuy255A/InstructorToolkit'

#>

Set-Location $PSScriptRoot

#use dot-notation to pull commonly used functions.
. ".\Submodules\ScriptingToolkit\Libraries\STCommon.ps1"
. ".\Submodules\Restore-NuGet\Restore-NuGetPackage.ps1"
. ".\Libraries\Initialize-iText7.ps1"
Clear-Host

#get the config file's Fully Qualified name to pass into Get-ConfigData
$configFQName = Get-ChildItem -Path Config\config.ini -ErrorAction SilentlyContinue | Select-Object FullName

#load the config.ini
Test-ConfigFile $configFQName
$configData = @{}
$configData = Get-ConfigData $configFQName.FullName.ToString()

#make the log directory
if (!$(Test-Path $configData.LogDirectory)) { 
    mkdir $configData.LogDirectory | Out-Null
}

$LauncherLogFile = $configData.LogDirectory + "\Launcher.log"

#Create the log file.
Write-STLog -Message $("Started " + $configData.ToolkitName) -OutFile $LauncherLogFile

#Launch the Statup Menu.
