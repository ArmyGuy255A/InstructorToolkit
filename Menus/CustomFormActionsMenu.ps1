Function Show-CustomFormActionsMenu () {
    while (-1) {

        #Get the custom scripts from the CustomFormActions directory
        $customFormActions = Get-ChildItem -Path .\CustomFormActions -Filter *.ps1
        [array]$menuChoices = [array]$customFormActions.BaseName
        $result = Show-STMenu -Title "Custom Form Actions Menu" -Choices $menuChoices -Back -Info @("Active Class", $activeClassInfo.ActiveClass)

        if ($result -eq "B") { return }

        #TODO: Execute the script

    }
}

