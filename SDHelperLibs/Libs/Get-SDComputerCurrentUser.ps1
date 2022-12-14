function Get-SDComputerCurrentUser {

    <#
.Synopsis
    Вывод текущего пользователя на компьютере.

.Description
    Через прослойку WMI запрашивает логин текущего пользователя, авторизованного на компьютере.

.Parameter ComputerName
    Объект типа String.

.Example
    Get-SDComputerCurrentUser test-pc 
    
.Example
    Get-SDComputerCurrentUser test-pc.corp.example.loc  
    
.Inputs
    Принимает через пайплайн объект типа String.

.Outputs
    Объект типа String.

.Link
    https://kb.ertelecom.ru/display/~rossamakhin.ra/SDHelperLibs
#>

    [CmdletBinding()]
    param(

        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String]$ComputerName
    )

    process {

        Write-Verbose "=== CHECK USER ON $ComputerName ==="

                
        if (Test-Connection -ComputerName $ComputerName -Count 2 -delay 1 -quiet) {
            $query = (Get-WmiObject -class Win32_ComputerSystem -ComputerName $ComputerName).Username
                    
            if ($Null -ne $query) {
                $username = $query.Split("\")[1]
                Write-Verbose "Query return $username"
            }

            else {
                $username = ""
                Write-Verbose 'No user logged or host is down'
            }

            return $username                
        }
    }
}