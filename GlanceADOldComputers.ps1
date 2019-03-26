<#

.NAME
GlanceADOldComputers

.SYNOPSIS
Returns a list of all the computers in AD that have not been online for 6 months.

.SYNTAX
GlanceADOldComputers

.DESCRIPTION
Returns a list of all the computers in AD that have not been online for 6 months and the last date 
they were seen online.

.PARAMETERS
None.

.INPUTS
None.

.OUTPUTS
List of Computer names and dates.

.NOTES
None.

.EXAMPLE 1
GetADComputerOldLogon
Lists all computers in the domain that have not checked in for more than 6 months.

.RELATED LINKS

By Ben Peterson
linkedin.com/in/benpetersonIT
https://github.com/BenPetersonIT

#>

[cmdletbinding()]
param(

    [int]$monthsOld = 6

)

$lastLogonList = @()

$computers = Get-ADComputer -Filter * | Get-ADObject -Properties lastlogon | Select-Object -Property name,lastlogon | 
    Sort-Object -Property name

foreach($computer in $computers){

    if(([datetime]::fromfiletime($computer.lastlogon)) -lt ((Get-Date).AddMonths(($monthsOld * -1)))){

        $lastLogonProperties = @{
            "Last Logon" = ([datetime]::fromfiletime($computer.lastlogon));
            "Computer" = ($computer.name)
        }

        $lastLogonObject = New-Object -TypeName PSObject -Property $lastLogonProperties
    
        $lastLogonList += $lastLogonObject
    
    }

}

$lastLogonList

return