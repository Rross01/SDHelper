function Get-SDComputerCommonInfo {

    <#
.Synopsis
    Вывод основной информации о компьютере.

.Description
    Через прослойку WMI запрашивает основные параметры о операционной системе и железе (включая серийники).    
    Внимание! WMI очень инертен, и например для обновления актуальной информации о подключённом мониторе может потребоваться перезагрузка.

.Parameter ComputerName
    Объект типа String.

.Example
    Get-SDComputerCommonInfo test-pc 
    
.Example
    Get-SDComputerCommonInfo test-pc.corp.example.loc  
    
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
 
    try {
    
        if (Get-SDComputerValidate $ComputerName) {}
        else {
            break;
        }

        $BaseBoardWmiObject = Get-WmiObject -ComputerName $ComputerName Win32_BaseBoard
        $CpuWmiObject = Get-WmiObject -ComputerName $ComputerName win32_processor
        $GpuWmiObject = Get-WmiObject -ComputerName $ComputerName Win32_VideoController
        $OsWmiObject = Get-WmiObject -ComputerName $ComputerName win32_operatingsystem
        $BiosWmiObject = Get-WmiObject -Class 'win32_bios' -ComputerName $ComputerName

        $IpAddress = ([System.Net.Dns]::GetHostAddresses("$ComputerName")).IPAddressToString
        
        $ReturnArray = @()

        # Добавление основной информации, единой для большинства систем
        $ReturnArray += [PSCustomObject]@{

            # BaseBoard
            BaseBoard_manufacturer = $BaseBoardWMIObject.manufacturer
            BaseBoard_product      = $BaseBoardWMIObject.product
            BaseBoard_SN           = $BaseBoardWMIObject.SerialNumber

            # CPU
            CPU_caption            = $CpuWmiObject.caption
            CPU_description        = $CpuWmiObject.Description
            CPU_name               = $CpuWmiObject.Name
            CPU_manufacturer       = $CpuWmiObject.manufacturer

            # GPU
            GPU_name               = $GpuWmiObject.Name

            # OS
            OS_version             = $OsWmiObject.version
            OS_caption             = $OsWmiObject.caption
        
            # BIOS
            BIOS_SN                = $BiosWmiObject.SerialNumber

            # Network
            IP_Address             = $IpAddress
        }

        # Добавление информации, которая может отличаться от системы к системе
        # Такой как информация о мониторе, которых может быть 0, 1 или 2, или
        # Информация о видеоядре, которых в системе может быть 1 или 2.

        # Проверка на наличие подключённых мониторов
        if (Get-WmiObject WmiMonitorID -ComputerName $ComputerName -Namespace root\wmi) {

            # Если мониторов больше чем 0, то делает запрос к WMI.
            $MonitorsWmiObject = Get-WmiObject WmiMonitorID -ComputerName $ComputerName -Namespace root\wmi
    
            # Костыльное решение: из-за того, что массив с одним объектом перестаёт быть массивом
            # Разделил на два случая - если запрос вернул два монитора, то обращаюсь по индексу,
            # если один, то напрую к объекту.

            if ($MonitorsWmiObject.Count -eq 2) {

                $ReturnArray += [PSCustomObject]@{
                    FirstMonitorName  = -join [char[]] ($MonitorsWmiObject[0].ManufacturerName -ne 0)
                    FirstMonitorSN    = -join [char[]] ($MonitorsWmiObject[0].SerialNumberID -ne 0)
                    SecondMonitorName = -join [char[]] ($MonitorsWmiObject[1].ManufacturerName -ne 0)
                    SecondMonitorSN   = -join [char[]] ($MonitorsWmiObject[1].SerialNumberID -ne 0)
                }
            }
            else {
                $ReturnArray += [PSCustomObject]@{
                    FirstMonitorName = -join [char[]] ($MonitorsWmiObject.ManufacturerName -ne 0)
                    FirstMonitorSN   = -join [char[]] ($MonitorsWmiObject.SerialNumberID -ne 0)
                }
            }
        }

        return $ReturnArray
    }
    catch {
        Write-Host "Произошла ошибка во время WMI запроса"
    }
}