

[string]$file = Get-Item "PDFTemplates\a4856.pdf"
[string]$destfile = "PDFTemplates\FILLEDa4856.pdf"

[iText.Kernel.Pdf.PdfReader]$pdfReader = [iText.Kernel.Pdf.PdfReader]::new($file)
[iText.Kernel.Pdf.PdfWriter]$pdfWriter = [iText.Kernel.Pdf.PdfWriter]::new($destfile)
[object]$pdfDocument = [iText.Kernel.Pdf.PdfDocument]::new($pdfReader,$pdfWriter)
$pdfAcroForm = [iText.Forms.PdfAcroForm]::GetAcroForm($pdfDocument,$false)

#Get the form fields
$pdfAcroFormFields = $pdfAcroForm.GetFormFields()

#Set the value of the field.
$pdfAcroFormFields["form1[0].Page1[0].Name[0]"].SetValue("Dieppa, Phillip A.")
$pdfAcroFormFields["form1[0].Page1[0].Rank_Grade[0]"].SetValue("CW3")

$pdfReader.Close()
$pdfWriter.Close()
$pdfDocument.Close()
$pdf.Close()

Function Get-PDFFields () {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $FilePath = "PDFTemplates\a4856.pdf" ,

        [Parameter(Mandatory=$false)]
        [string]
        $OutputDirectory = "PDFTemplates"
    )

    [iText.Kernel.Pdf.PdfReader]$pdfReader = [iText.Kernel.Pdf.PdfReader]::new($FilePath)
    [object]$pdfDocument = [iText.Kernel.Pdf.PdfDocument]::new($pdfReader)
    $pdfAcroForm = [iText.Forms.PdfAcroForm]::GetAcroForm($pdfDocument,$false)

    #Get the form fields
    $pdfAcroFormFields = $pdfAcroForm.GetFormFields()
    $pdfAcroFormFields | ConvertTo-Json | Set-Content -Path ("{0}\{1}-Mapping.json" -f $OutputDirectory,(Get-Item $FilePath).BaseName)

}