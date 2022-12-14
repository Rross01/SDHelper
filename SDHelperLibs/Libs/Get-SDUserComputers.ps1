function Get-SDUserComputers {
        
    <#
.Synopsis
    Вывод компьютеров пользоватея.

.Description
    С SCCM сервера берёт список компьютеров, с которыми ассоциированна учётная запись. В выводе может храниться несколько компьютеров из-за специфики работы Comfiguration Manager. В выводе указывается логин ТЕКУЩЕГО авторизованного пользователя на компьютере, так что по исходя из этой информации можно найти необходимый компьютер.
    
    Важно! Для работы требуется установленная консоль администрирования Microsoft Configuration Manager, так как с ним идут библиотеки для Powershell.

.Parameter Identifier

.Example
    Get-SDUserComputers "Россамахин Роман Андреевич" 
    
.Example
    Get-SDUserComputers "rossamakhin.ra"  
    
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

    if (Get-Module | Select-Object Name | Where-Object Name -eq "ConfigurationManager") {}
    else {
        Import-Module `
            "${env:ProgramFiles(x86)}\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"
    }

    $login = Get-SDUserValidate -Identifier $Identifier
    Write-Verbose "Target user - $login"
    Write-Verbose 'Connecting to SCCM...'
    Set-Location PR1:

    Write-Verbose -Message 'Searching computers...'

    $UserComputers = Get-CMUserDeviceAffinity -UserName "corp\$login" | Select-Object ResourceName
    
    $ReturnArray = @()

    foreach ($item in $UserComputers) {
        if ($item.ResourceName -notlike "*VDI*") {
            $ReturnArray += [PSCustomObject]@{
                ComputerName = $item.ResourceName;
                CurrentUser  = Get-SDComputerCurrentUser -ComputerName $item.ResourceName 
            }
        }
    }
    
    Set-Location C:
    return $ReturnArray
}



