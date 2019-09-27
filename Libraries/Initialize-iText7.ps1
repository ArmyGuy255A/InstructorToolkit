
$DependenciesDirectory = $null
if ($psISE) {
    $DependenciesDirectory = $(Get-Item $psISE.CurrentFile.FullPath).Directory.ToString() + "\Dependencies"
} else {
    $DependenciesDirectory = $PSScriptRoot + "\Dependencies"
}
#Test the dependency directory
if (!$(Test-Path $DependenciesDirectory)) {
    mkdir $DependenciesDirectory
}

$NugetPackages = @(
    @{Name = "iText7"; Version = "7.1.8"; Libraries = @(
        "iText7.7.1.8\lib\net40\itext.io.dll",
        "iText7.7.1.8\lib\net40\itext.kernel.dll",
        "iText7.7.1.8\lib\net40\itext.forms.dll"
    )},
    @{Name = "bouncycastle"; Version = "1.8.1"; Libraries = @("bouncycastle.1.8.1\lib\BouncyCastle.Crypto.dll")},
    @{Name = "common.logging"; Version = "3.4.1"; Libraries = @("common.logging.3.4.1\lib\netstandard1.3\Common.Logging.dll")},
    @{Name = "common.logging.core"; Version = "3.4.1"; Libraries = @("common.logging.core.3.4.1\lib\net40\Common.Logging.Core.dll")}
)

#Test to see if the libraries exist
Write-Host "Validating Dependencies..."
foreach ($Package in $NugetPackages) {
    foreach ($library in $Package.Libraries) {
        $assemblyPath = "{0}\{1}" -f $DependenciesDirectory,$library
        $isPresent = Get-Item $assemblyPath -ErrorAction SilentlyContinue
        $dll = $library.Split("\")[-1]
        if (!$isPresent) {
            #Download the dependency
            Write-Warning ("{0} not present. Restoring {1}" -f $dll,$Package.Name)
            Restore-NuGetPackage -Id $Package.Name -Version $Package.Version -OutputDirectory $DependenciesDirectory | Out-Null

        } else {
            #Write-Host "$dll found!" -ForegroundColor Green
        }
            #Unblock-File $assemblyPath

            #Load the assembly            
            [System.Reflection.Assembly]::LoadFrom($assemblyPath) | Out-Null
    }
}

Write-Host "All assemblies loaded" -ForegroundColor Green
