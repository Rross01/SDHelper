function Get-SDComputerRDPLog {

  <#
.Synopsis
  Вывод лога RDP подключений.

.Description
  Запрашивает события входа на компьютер по RDP.

.Parameter ComputerName
  Объект типа String.

.Example
  Get-SDComputerRDPLog test-pc 
  
.Example
  Get-SDComputerRDPLog test-pc.corp.example.loc  

.Example
  Get-SDComputerRDPLog 10.125.50.15
  
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
    $XPath = '<QueryList><Query Id="0"><Select>*[System[EventID=1149]]</Select></Query></QueryList>'
    $RDPAuths = Get-WinEvent `
      -ComputerName $ComputerName `
      -LogName 'Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational' `
      -FilterXPath $XPath

    # Get specific properties from the event XML
    [xml[]]$xml = $RDPAuths | ForEach-Object { $_.ToXml() }

    $EventData = Foreach ($event in $xml.Event) { 

      # Create custom object for event data
      New-Object PSObject -Property @{
        TimeCreated = (Get-Date ($event.System.TimeCreated.SystemTime) -Format 'yyyy-MM-dd hh:mm:ss K')
        User        = $event.UserData.EventXML.Param1
        Domain      = $event.UserData.EventXML.Param2
        Client      = (GetDnsNameIfExist -ComputerName ($event.UserData.EventXML.Param3))
        #Client      = $event.UserData.EventXML.Param3
      }

    }
    return $EventData 

  }
}

function GetDnsNameIfExist {
  param(
    [parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [String]$ComputerName
  )
  process {

    if ($return = Resolve-DnsName $ComputerName -Type PTR -DnsOnly -QuickTimeout 2> $null) {
      return $return.NameHost
    }
    else { return $ComputerName }

  }
}