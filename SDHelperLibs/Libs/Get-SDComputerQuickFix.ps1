function Get-SDComputerQuickFix {

    <#
.Synopsis
Вывод лога RDP подключений.

.Description
Запрашивает события входа на компьютер по RDP.

.Parameter ComputerName
Объект типа String.

.Example
Get-SDComputerQuickFix test-pc 

.Example
Get-SDComputerQuickFix test-pc.corp.example.loc

.Example
Get-SDComputerQuickFix 10.125.50.15

.Inputs
Принимает через пайплайн объект типа String.

.Outputs
Объект типа PSCustomObject.

.Link
https://kb.ertelecom.ru/display/~rossamakhin.ra/SDHelperLibs
#>

    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String]$ComputerName
    )

    process {
        return (Get-WmiObject -Class "win32_quickfixengineering" -ComputerName $ComputerName)
    }
}