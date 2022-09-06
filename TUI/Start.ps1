$MyPSScriptRoot = "\\ekat-it-02\d$\PS\SDHelper"
$VerbosePreference = "Continue"


if (Get-Module SDHelperLibs) {}
else {
    Import-Module "$MyPSScriptRoot\SDHelperLibs\SDHelperLibs.psm1"
}

if (Get-Module SDHelperPages) {}
else {
    Import-Module "$MyPSScriptRoot\TUI\SDHelperPages.psm1"
}

if (Get-Module ActiveDirectory) {}
else {
    Import-Module ActiveDirectory
}

Clear-Host

while ($true) {
    $result = Show-MainMenu
    if ($result -eq $true) { break }
}
