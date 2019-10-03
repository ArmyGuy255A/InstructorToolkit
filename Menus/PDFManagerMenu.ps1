
function Import-PDFTemplate () {
    #Get the file
    $file = Get-FileName -Filter "PDF (*.pdf) | *.pdf"

    #Ensure a file was selected
    if (!$file) {return $null}

    #Copy the file to the PDFTemplates directory
    Copy-Item $file -Destination .\PDFTemplates -for
}

Function Show-PDFManagerMenu () {
    while (-1) {
        $menuChoices = @(
        "Import PDF",
        "Generate PDF Field Map",
        "Test PDF Field Map",
        "Remove PDF"
        )

        #Get the total number of PDF documents
        $info = @(
            "Imported PDFs", $(Get-ChildItem -Path .\PDFTemplates -Filter *.pdf).Count,
            "Associated Mappings", $(Get-ChildItem -Path .\PDFTemplates -Filter *.json).Count
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

