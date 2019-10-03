#Add the other menus
. .\Menus\ClassManagerMenu.ps1
. .\Menus\ClassMenu.ps1
. .\Menus\PDFManagerMenu.ps1
. .\Menus\CustomFormActionsMenu.ps1

Function Show-StartupMenu () {
    while (-1) {
        $menuChoices = @(
        "Enter Class",
        "Class Manager",
        "PDF Manager"
        )

        #Get the active class information
        $activeClassInfo = Get-Content $configData.ClassInfo | ConvertFrom-Json
        [array]$activeClassInfo.AvailableClasses = [array]$activeClassInfo.AvailableClasses | Sort-Object
        #Ensure AvailableClasses is always an array

        $activeClassInfo
        $result = Show-STMenu -Title "Main Menu" -Choices $menuChoices -Exit -Info @("Active Class", $activeClassInfo.ActiveClass)

        switch ($result) {
            1 { Show-ClassMenu }
            2 { Show-ClassManagerMenu $activeClassInfo }
            3 { Show-PDFManagerMenu $activeClassInfo}
            "E" {Exit}
            Default {}
        }
    }
}