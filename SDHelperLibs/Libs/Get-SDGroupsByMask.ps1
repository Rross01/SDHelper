function Get-SDGroupsByMask {
      
    <#
.Synopsis
    Функция поиска групп по маске. 

.Description
    Принимает строку формата "sometext*anithertext*", и ищет по совпадениям в имени, описании или заметке.
    
.Parameter Mask
    Объект типа String.

.Example
    Get-SDGroupsByMask "sccm*notepad*"
    Поиск по имени.
    
.Example
    Get-SDGroupsByMask "*Documents*Отдел продаж*"
    В этом случае вернёт список групп, в описании которых есть полный путь к сетевой шаре отдела.

.Example
    Get-SDGroupsByMask "*Масалкин*"
    В этом случае вернёт список групп, в заметке которой указан некоторый согласователь.
    
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
    [String]$Mask
)

    Get-ADGroup `
        -Filter {
            (info -like $mask)
        -or (samaccountname -like $mask)
        -or (description -like $mask)
    } `
        -Properties Info, description | Select-Object Name, ObjectClass, Info, description
}
