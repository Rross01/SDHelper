write-host "Importing..."
$Path = "$PSScriptRoot"
Get-ChildItem "$Path\Libs\" | ForEach-Object -Process {
    . $Path\libs\"$_"
    write-host $_.name.split(".")[0] | Export-ModuleMember
}