function Get-SDComputerValidate {
        
    <#
.Synopsis
    Служебная функция валидации компьютера.

.Description
    Шлёт простой запрос, чтобы убедиться, что в домене есть такой компьютер. Как результат возвращает значение True или False.
    
.Parameter ComputerName
    Объект типа String.

.Example
    Get-SDComputerValidate test-pc 
    
.Example
    Get-SDComputerValidate test-pc.corp.example.loc  
    
.Inputs
    Принимает через пайплайн объект типа String.

.Outputs
    Объект типа Boolean.

.Link
    https://kb.ertelecom.ru/display/~rossamakhin.ra/SDHelperLibs
#>

[CmdletBinding()]
param(

    [parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [String]$ComputerName
)

    try {
        Get-ADComputer -Identity $ComputerName.Split(".")[0] *> $null
        return $true
    }

    catch {
        Write-Host "Компьютера нет в AD"
        return $false
    }

}