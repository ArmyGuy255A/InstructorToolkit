Function Get-FileName()
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $initialDirectory,
        # Filter
        [Parameter()]
        [string]
        $Filter = "All Files (*.*)| *.*"
    )
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = $Filter
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}

function Copy-File {
    param (
        # Parameter help description
        [Parameter(ParameterSetName='File')]
        [Parameter(ParameterSetName='Directory')]
        [string]
        $SourceFile,
        # Parameter help description
        [Parameter(ParameterSetName='File')]
        [string]
        $DestinationFile,
        # Parameter help description
        [Parameter(ParameterSetName='Directory')]
        [string]
        $DestinationDirectory
    )

    $SourceFileItem = Get-Item $SourceFile

    if ($PSCmdlet.ParameterSetName -eq 'Directory') {
        $DestinationDirectory = $DestinationDirectory.TrimEnd('\')
        $DestinationFile = "{0}\{1}{2}" -f $DestinationDirectory,$SourceFileItem.BaseName,$SourceFileItem.Extension
    } 

    If (Test-Path $DestinationFile) {
        $i = 0   
        $BaseDestFile = Get-Item $DestinationFile     
        While (Test-Path $DestinationFile) {
            $i += 1
            $DestinationFile = "{0}\{1}($i){2}" -f $BaseDestFile.DirectoryName,$BaseDestFile.BaseName,$BaseDestFile.Extension
        }
    } Else {
        New-Item -ItemType File -Path $DestinationFile -Force
    }
    
    Copy-Item -Path $SourceFile -Destination $DestinationFile -Force
}

Copy-File -SourceFile C:\Scripts\InstructorToolkit\PDFTemplates\a1059.pdf -DestinationDirectory C:\Scripts\InstructorToolkit\PDFTemplates
