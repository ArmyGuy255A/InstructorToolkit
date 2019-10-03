
Function Show-EnterClass () {
    
    $menuChoices = @(
        ""
    )
    $result = Show-STMenu -Title "Class name" -Choices $menuChoices -Back
    Clear-Host
    switch ($result) {
        1 { Show-EnterClass }
        2 { Show-NewClass}
        3 { Show-RemoveClass}
        "B" {return}
        Default {}
    }
}

Function Show-NewClass ( $classInfo ) {
    Clear-Host
    $result = Show-STReadHostMenu -Title "Enter a Class Name" -Prompt "Name"
    Clear-Host
    $confirmed = Show-STConfirmationMenu -selection $result -title "Is the Class Name Correct?"
    Clear-Host
    if (!$confirmed) { return }

    #Make the directory for the class
    New-Item -ItemType Directory ("{0}{1}\{2}" -f $configData.ToolRootDirectory, $configData.ClassDirectory.TrimStart('.'), $result) -ErrorAction SilentlyContinue | Out-Null

    #Add the class to the list of available classes and update the json file
    $classInfo.AvailableClasses += $result
    [array]$classInfo.AvailableClasses = [array]$classInfo.AvailableClasses | Sort-Object -Unique
    $classInfo | ConvertTo-Json -Depth 5 | Out-File $configData.ClassInfo
}

Function Show-SelectClass ( $classInfo ) {
    Clear-Host
    $menuChoices = $classInfo.AvailableClasses

    if ($classInfo.AvailableClasses.Count -eq 0) {
        return
    }

    $result = Show-STMenu -Title "Select Class" -Choices $menuChoices -Back
    Clear-Host
    if ($result -eq "B") { return }

    #Set the active class and update the json file
    $classInfo.ActiveClass = $menuChoices[$result - 1]
    $classInfo | ConvertTo-Json -Depth 5 | Out-File $configData.ClassInfo
}

Function Show-RemoveClass ( $classInfo ) {
    Clear-Host
    $menuChoices = $classInfo.AvailableClasses

    if ($classInfo.AvailableClasses.Count -eq 0) {
        return
    }

    $result = Show-STMenu -Title "Select a Class to Remove" -Choices $menuChoices -Back
    Clear-Host
    if ($result -eq "B") { return }
    
    $confirmed = Show-STConfirmationMenu -selection $menuChoices[$result - 1]  -title "Is the Class Name Correct?"

    if (!$confirmed) { return }
    Clear-Host

    #Ensure the current class isn't selected. If it is, change it to 'None'
    if ($classInfo.ActiveClass -eq $menuChoices[$result - 1]) {
        $classInfo.ActiveClass = "None"
    }

    [System.Collections.ArrayList]$availableClasses = $classInfo.AvailableClasses
    $availableClasses.Remove($menuChoices[$result - 1])
    $classInfo.AvailableClasses = $availableClasses.ToArray()
    #Set the active class and update the json file
    $classInfo | ConvertTo-Json -Depth 5 | Out-File $configData.ClassInfo
}

Function Show-ClassMenu () {
    while (-1) {
        $menuChoices = @(
        "Generate Class Documents",
        "Generate Individual Document",
        "Custom Form Actions"
        )

        $activeClassInfo
        $result = Show-STMenu -Title "Class Menu" -Choices $menuChoices -Back

        switch ($result) {
            1 { Show-EnterClass }
            2 { Show-SelectClass  }
            3 { Show-CustomFormActionsMenu }
            "B" {return}
            Default {}
        }
    }
}

