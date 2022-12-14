function Get-SDUserCommonInfo {
        
    <#
.Synopsis
    Вывод основной информации о пользователе.

.Description
    Принимает полное ФИО или логин сотрудника. Возвращает выборку самых нужных атрибутов учётки, таких как должность, подразделение, номер, статус блокировки, дату рождения и т.д.
    
.Parameter Identifier

.Example
    Get-SDUserCommonInfo "Россамахин Роман Андреевич" 
    
.Example
    Get-SDUserCommonInfo "rossamakhin.ra"  
    
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
        [String]$Identifier
    )

    Try {
        Get-ADUser (Get-SDUserValidate -Identifier $Identifier) -Properties * |
        Select-Object DisplayName, Department, Description, 
        City, EmailAddress, mobile, mobilephone, OfficePhone,
        telephoneNumber, Created, Modified, Enabled, extensionAttribute2, Manager,
        MemberOf, PasswordExpired, SamAccountName
    }
    Catch {
        Write-Host "В AD нет такого пользователя"
    }
}