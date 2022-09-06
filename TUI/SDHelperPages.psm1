write-host "Importing..."
Get-ChildItem "$PSScriptRoot\Files\" | ForEach-Object -Process {
    . $PSScriptRoot\Files\"$_"
    write-host $_.name.split(".")[0] | Export-ModuleMember
}