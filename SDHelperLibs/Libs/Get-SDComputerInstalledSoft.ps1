function Get-SDComputerInstalledSoft {

    <#
.Synopsis
    Вывод установленного софта на компьютере.

.Description
    Через прослойку WMI запрашивает список всего зарегистрированного в системе софта, его разработчика, версию и описание.

.Parameter ComputerName
    Объект типа String.

.Example
    Get-SDComputerInstalledSoft test-pc 
    
.Example
    Get-SDComputerInstalledSoft test-pc.corp.example.loc  
    
.Inputs
    Принимает через пайплайн объект типа String.

.Outputs
    Объект типа PSCustiomObject.

.Link
    https://kb.ertelecom.ru/display/~rossamakhin.ra/SDHelperLibs
#>

    [CmdletBinding()]
    param(

        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String]$ComputerName
    )

    Try {
    
        if (Get-SDComputerValidate $ComputerName) {}
        else {
            break;
        }

        $ReturnArray = (
            Get-WmiObject `
                -Namespace root\cimv2 `
                -ComputerName $ComputerName `
                -Query "SELECT Name,Vendor,Version,Caption FROM Win32_Product" |
            Select-Object Name, Vendor, Version, Caption
        )

        return $ReturnArray

    }

    Catch {
        Write-Host "В вызове к WMI произошла ошибка"
    }
}