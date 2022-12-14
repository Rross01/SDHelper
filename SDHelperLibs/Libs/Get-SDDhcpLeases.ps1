function Get-SDDhcpLeases {
    
    <#
.Synopsis
    Функция поиска по записям в DHCP сервере.

.Description
    Ищет по записям DHCP сервера. В качестве фильтра принимает зарезервированный IP адрес, MAC адрес или имя устройства (одно из!). Также может оказаться полезным при поиске старой подсети, в случае перемещения компьютера (например в другой кабинет), если из новой подсети потерялся доступ к разным системам.
    
.Parameter IpAddress
    Означает ассоциированный IP адрес с записью.
    
.Parameter ComputerName
    Означает ассоциированное имя с записью. Принимает только полное имя (с *corp.example.loc)!

.Parameter MacAddress
    Означает ассоциированный MAC адрес с записью. ОБЯЗАТЕЛЬНО должен иметь формат xx-xx-xx-xx-xx-xx (например 80-e8-2c-30-9b-51).

.Parameter DhcpServer
    Опциональный параметр, принимает короткое имя DHCP сервера, из которого будут грузиться записи (по умолчанию стоит corp-dc-01).

.Example
    Get-SDDhcpLeases -ComputerName "test-pc.corp.example.loc"
    Вернёт все записи в DHCP, ассоциированные с этим именем.
    
.Example
    Get-SDDhcpLeases -MacAddress "80-e8-2c-30-9b-51"
    Вернёт все записи в DHCP, ассоциированные с этим физическим (MAC) адресом.
    
.Example
    Get-SDDhcpLeases -IpAddress "10.125.50.15"
    Вернёт все записи в DHCP, ассоциированные с этим IP адресом.
    
.Outputs
    Объект типа PSCustomObject.

.Link
    https://kb.ertelecom.ru/display/~rossamakhin.ra/SDHelperLibs
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ByIP')]
        [string]$IpAddress,
        [Parameter(Mandatory, ParameterSetName = 'ByMacAddress')]
        [string]$MacAddress,
        [Parameter(Mandatory, ParameterSetName = 'ByHostName')]
        [string]$hostname
    )

    $DhcpServer = (Get-ADDomainController).HostName

    $AllLeases = (
        Get-DhcpServerv4Scope -ComputerName $Dhcpserver | 
        ForEach-Object { Get-DhcpServerv4Lease -computername $DhcpServer -allleases -ScopeId ($_.ScopeId) }
    )
    if ($ipaddress) {
        $AllLeases | Where-Object IPAddress -eq $ipaddress
    }
    if ($hostname) {
        $AllLeases | Where-Object hostname -like $hostname
    }
    if ($MacAddress) {
        $AllLeases | Where-Object ClientId -eq $MacAddress
    }
}