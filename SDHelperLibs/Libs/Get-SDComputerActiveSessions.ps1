Function Get-SDComputerActiveSessions {

    <#
.Synopsis
Вывод активных сессий.

.Description
Функция-обёртка над qwinsta через psexec, пытающаяся обуздать всю шакальность вывода этих команд. 

.Parameter ComputerName
Объект типа String.

.Example
Get-SDComputerActiveSessions test-pc 

.Example
Get-SDComputerActiveSessions test-pc.corp.example.loc

.Example
Get-SDComputerActiveSessions 10.125.50.15

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

    Begin {
        $return = @()
    }
    Process {

        If (!(Test-Connection $ComputerName -Quiet -Count 1)) {
            Write-Error -Message "Unable to contact $ComputerName. Please verify its network connectivity and try again." -Category ObjectNotFound -TargetObject $ComputerName
            Return
        }

        $result = psexec \\$ComputerName qwinsta
        If ($result) {
            ForEach ($line in $result[6..$result.count]) {
                #avoiding the line 0-5, don't want the headers
                $tmp = $line.split(" ") | Where-Object { $_.length -gt 0 }
                If (($line[19] -ne " ")) {
                    #username starts at char 19
                    If ($line[48] -eq "A") {
                        #means the session is active ("A" for active)
                        $return += New-Object PSObject -Property @{
                            "ComputerName" = $ComputerName
                            "SessionName"  = $tmp[0]
                            "UserName"     = $tmp[1]
                            "ID"           = $tmp[2]
                            "State"        = $tmp[3]
                            "Type"         = $tmp[4]
                        }
                    }
                    Else {
                        $return += New-Object PSObject -Property @{
                            "ComputerName" = $ComputerName
                            "SessionName"  = $null
                            "UserName"     = $tmp[0]
                            "ID"           = $tmp[1]
                            "State"        = $tmp[2]
                            "Type"         = $null
                        }
                    }
                }
            }
        }
        Else {
            Write-Error "Unknown error, cannot retrieve logged on users"
        }
    }
    End {
        If ($return) {
            Return $return
        }
        Else {
            Return $false
        }
    }
}