function Get-PDFTemplates () {
    
    [System.Collections.ArrayList]$TemplateObject = [System.Collections.ArrayList](Get-Content .\Files\Templates.json | ConvertFrom-Json)
    
    return $TemplateObject
}

Function Set-PDFTemplates () {
    [CmdletBinding()]
    param (
        [Parameter()]
        [System.Collections.ArrayList]
        $TemplateObject
    )

    ConvertTo-Json $TemplateObject -Depth 10 | Set-Content .\Files\Templates.json | Out-Null
}

Function Add-PDFFileReference () {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $File,
        [Parameter()]
        [string]
        $Title,
        [Parameter()]
        [array]
        $Mappings
    )

    #Build the PDF Template hashtable
    $template = @{
        "PDFFile" = $File;
        "Title" = $Title;
        "Mappings" = @(
            @{
                "File" = $null;
                "Title" = $null
            }
        )
    }
    $template = New-Object PSObject -Property $template

    #Get the Templates
    $Templates = Get-PDFTemplates

    if ($Templates.GetType() -ne [System.Collections.ArrayList]) {
        [System.Collections.ArrayList]$Templates = [System.Collections.ArrayList](Get-Content .\Files\Templates.json | ConvertFrom-Json)
    }

    $TemplateObject = $null
    #Ensure there is at least an array list to work with
    if ($null -eq $Templates) {
        [System.Collections.ArrayList]$Templates = @(
            $template
        )
    } elseif ($Templates.PDFFile.Contains($File) -and $Templates.Title.Contains($Title)) {
        #Ensure the file and title isn't already in the object
        Write-Warning "File already exists in the template. Try changing the file name or title of the file."
        Start-Sleep -Seconds 2
    } else {
        $Templates.Add($template) | out-null        
    }

    $TemplateObject = ConvertTo-Json $Templates -Depth 10 | ConvertFrom-Json
    Set-PDFTemplates -TemplateObject $TemplateObject
}

function Import-PDFTemplate () {
    #Get the file
    $file = Get-FileName -Filter "PDF (*.pdf) | *.pdf"

    #Ensure a file was selected
    if (!$file) {return $null}

    #Copy the file to the PDFTemplates directory
    $destinationFile = Copy-File -SourceFile $file -DestinationDirectory .\Files\Imports

    #Return if the process was cancelled
    if (!$destinationFile) { return }

    $destinationFile = Get-Item $destinationFile

    #Add the PDF to the templates file.
    Add-PDFFileReference -File $destinationFile.Name

}

Function Show-PDFManagerMenu () {
    while (-1) {
        $menuChoices = @(
        "Import PDF",
        "Generate PDF Field Map",
        "Test PDF Field Map",
        "Remove PDF"
        )

        $templates = Get-PDFTemplates

        #TODO: Ensure I get the correct number of PDFFiles and Mappings. Might need to do some quick enumeration to add counters
        
        #Get the total number of PDF documents
        $info = @(
            "Imported PDFs", $templates.PDFFile.Count,
            "Associated Mappings", $templates.Mappings.File.Count
        )
        
        $result = Show-STMenu -Title "PDF Manager" -Choices $menuChoices -Back -Info $info

        switch ($result) {
            1 { Import-PDFTemplate }
            2 { Show-GeneratePDFMapMenu }
            3 { Show-TestPDFMapMenu}
            4 { Show-RemovePDFMenu }
            "B" {return}
            Default {}
        }
    }
}
