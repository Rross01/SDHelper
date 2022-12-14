function Get-SDUserValidate {

    <#
.Synopsis
    Служебная функция валидации пользователя.

.Description
    Через запросы к AD проверяет корректность введённого ФИО или логина. Возвращает всегда логин, чем упрщает использование этой функции в других скриптах.
    
.Parameter Identifier
    Объект типа String.

.Example
    Get-SDUserValidate "Россамахин Роман Андреевич" 
    
.Example
    Get-SDUserValidate "rossamakhin.ra"  
    
.Inputs
    Принимает через пайплайн объект типа String.

.Outputs
    Объект типа String.

.Link
    https://kb.ertelecom.ru/display/~rossamakhin.ra/SDHelperLibs
#>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]
        $Identifier
    )
        
    $arr = @("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
        "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x",
        "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K",
        "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
        "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
    try {
        if ($Identifier[0] -in $arr) {
            return $Identifier
        }

        else {
            $login = (Get-ADUser -Filter { (DisplayName -eq $Identifier) -and (Enabled -eq $true) } -Properties DisplayName).SamAccountName
            return $login
        }
    }

    catch {
        Write-Host "Данного пользователя нет в AD"
    }
}