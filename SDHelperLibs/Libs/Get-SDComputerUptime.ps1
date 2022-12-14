function Get-SDComputerUptime {
    
    <#
.Synopsis
    Вывод аптайма компьютера.

.Description
    Через прослойку WMI запрашивает дату загрузки и аптайм компьютера (скрипт стырил с инета как пример красивого кода, пока не редачил).

.Parameter ComputerName
    Объект типа String.

.Example
    Get-SDComputerUptime test-pc 
    
.Example
    Get-SDComputerUptime test-pc.corp.example.loc  
    
.Inputs
    Принимает через пайплайн объект типа String.

.Outputs
    Объект типа PSCustiomObject.

.Link
    https://kb.ertelecom.ru/display/~rossamakhin.ra/SDHelperLibs
#>

    [CmdletBinding()]
    param(

        [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        $ComputerName,
        
        [System.Management.Automation.PSCredential]
        $Credential
    )
    begin {
        function Out-Object {
            param(
                [System.Collections.Hashtable[]] $hashData
            )
            $order = @()
            $result = @{}
            $hashData | ForEach-Object {
                $order += ($_.Keys -as [Array])[0]
                $result += $_
            }
            New-Object PSObject -Property $result | Select-Object $order
        }

        function Format-TimeSpan {
            process {
                "{0:00} d {1:00} h {2:00} m {3:00} s" -f $_.Days, $_.Hours, $_.Minutes, $_.Seconds
            }
        }

        function Get-Uptime {
            param(
                $computerName,
                [SecureString] $credential
            )
            # In case pipeline input contains ComputerName property
            if ( $computerName.ComputerName ) {
                $computerName = $computerName.ComputerName
            }
            if ( (-not $computerName) -or ($computerName -eq ".") ) {
                $computerName = [Net.Dns]::GetHostName()
            }
            $params = @{
                "Class"        = "Win32_OperatingSystem"
                "ComputerName" = $computerName
                "Namespace"    = "root\CIMV2"
            }
            if ( $credential ) {
                # Ignore -Credential for current computer
                if ( $computerName -ne [Net.Dns]::GetHostName() ) {
                    $params.Add("Credential", $credential)
                }
            }
            try {
                $wmiOS = Get-WmiObject @params -ErrorAction Stop
            }
            catch {
                Write-Error -Exception (New-Object $_.Exception.GetType().FullName `
                    ("Cannot connect to the computer '$computerName' due to the following error: '$($_.Exception.Message)'",
                        $_.Exception))
                return
            }
            $lastBootTime = [Management.ManagementDateTimeConverter]::ToDateTime($wmiOS.LastBootUpTime)
            Out-Object `
            @{"ComputerName" = $computerName },
            @{"LastBootTime" = $lastBootTime },
            @{"Uptime" = (Get-Date) - $lastBootTime | Format-TimeSpan }
        }
    }

    process {
        if ( $ComputerName ) {
            foreach ( $computerNameItem in $ComputerName ) {
                Get-Uptime $computerNameItem $Credential
            }
        }
        else {
            Get-Uptime "."
        }
    }
}
