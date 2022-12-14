$VerbosePreference = "Continue"


if (Get-Module SDHelperLibs) {}
else {
    Import-Module "$PSScriptRoot\..\SDHelperLibs\SDHelperLibs.psm1"
}

if (Get-Module SDHelperPages) {}
else {
    Import-Module "$PSScriptRoot\SDHelperPages.psm1"
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