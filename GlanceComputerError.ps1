<#

.NAME
GlanceComputerError

.SYNOPSIS
This cmdlet gathers system errors from a computer.

.SYNTAX
GlanceComputerError [-computer <string>] [-newest <int>]

.DESCRIPTION
This cmdlet gathers system errors from a computer. You can set the number of recent errors 
returned.

.PARAMETERS
-computer <string>
	Specifies the computer where the errors are returned from.

	Required?                   False
	Default value               $env:ComputerName
	Accept pipeline input?      False
	Accept wildcard characters? False

-newest <int>
    Specifies the numbers of errors returned.

    Required?                   False
    Default value               5
    Accept pipeline input?      False
	Accept wildcard characters? False

.INPUTS
None. You cannot pipe input to this cmdlet.

.OUTPUTS
Returns PS objects for computer system errors with Computer, TimeWritten, EventID, InstanceId, 
and Message.

.NOTES
Requires "Printer and file sharing", "Network Discovery", and "Remote Registry" to be enabled on computers 
that are searched.

.EXAMPLE 1
GlanceComputerError

This cmdlet returns the last 5 system errors from localhost.

.EXAMPLE 2
GetComputerError -computer Server -newest 2

This cmdlet returns the last 2 system errors from server.

.RELATED LINKS
By Ben Peterson
linkedin.com/in/benpetersonIT
https://github.com/BenPetersonIT

#>

[CmdletBinding()]
Param(

    [string]$ComputerName = "$env:COMPUTERNAME",

    [int]$newest = 5

)

#Main code

if((Test-Connection $ComputerName -Quiet) -eq $true){
#Tests to see if the computer is online.

    $errors = Get-EventLog -ComputerName $ComputerName -LogName System -EntryType Error -Newest $Newest |
        Select-Object -Property @{n="Computer";e={$ComputerName}},TimeWritten,EventID,InstanceID,Message

}else{
    
    Write-Host "$ComputerName is not online."

}

$errors

return