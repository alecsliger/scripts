# Get all info required from Get-ComputerInfo and store to var
$ALLINFO = Get-ComputerInfo -Property CsDNSHostName, WindowsRegisteredOwner, BiosSeralNumber, CsManufacturer, CsModel, CsProcessors, CsPhyicallyInstalledMemory, WindowsProductName

# Get Hostname and format
$DNSHOST = $ALLINFO.CsDNSHostName | Out-String
$DNSHOST = $DNSHOST.Split('',[System.StringSplitOptions]::RemoveEmptyEntries)
$DNSHOST = [string]::join(" ",($DNSHOST.Split(" ")))

# Get username and format
$USRNAME = $ALLINFO.WindowsRegisteredOwner | Out-String
$USRNAME = $USRNAME.Split('',[System.StringSplitOptions]::RemoveEmptyEntries)
$USRNAME = [string]::join(" ",($USRNAME.Split(" ")))

# Get BIOS S/N and format
$BIOSSN = $ALLINFO.BiosSeralNumber | Out-String
$BIOSSN = $BIOSSN.Split('',[System.StringSplitOptions]::RemoveEmptyEntries)
$BIOSSN = [string]::join(" ",($BIOSSN.Split(" ")))

# Get BIOS Manufacturer and format
$MANUFAC = $ALLINFO.CsManufacturer | Out-String
$MANUFAC = $MANUFAC.Split('',[System.StringSplitOptions]::RemoveEmptyEntries)
$MANUFAC = [string]::join(" ",($MANUFAC.Split(" ")))

# Get BIOS Model and format
$MODEL = $ALLINFO.CsModel | Out-String
$MODEL = $MODEL.Split('',[System.StringSplitOptions]::RemoveEmptyEntries)
$MODEL = [string]::join(" ",($MODEL.Split(" ")))

# Get CPU clock and format
$CPU_CLOCK = wmic cpu get maxclockspeed | Out-String
$CPU_CLOCK = $CPU_CLOCK.Split()
$CPU_CLOCK = $CPU_CLOCK[6]
$CPU_CLOCK = [int64]$CPU_CLOCK
$CPU_CLOCK = ($CPU_CLOCK/1024) + 0.1
$CPU_CLOCK = [math]::Round($CPU_CLOCK,1)

# Get CPU and format
$CPUMODEL = Get-WmiObject win32_Processor | Select-Object Name | Out-String
$CPUMODEL = $CPUMODEL.Split('',[System.StringSplitOptions]::RemoveEmptyEntries)
$CPUMODEL = $CPUMODEL[2..25]
$CPUMODEL = [string]::join(" ",($CPUMODEL.Split(" ")))

# Get RAM voltage, format, and convert to DDR type
$RAM_DDR = Get-WmiObject Win32_PhysicalMemory | Select-Object ConfiguredVoltage | Out-String
$RAM_DDR = $RAM_DDR.Split('',[System.StringSplitOptions]::RemoveEmptyEntries)
$RAM_DDR = $RAM_DDR[2]
$DDR = '2500'
$DDR2 = '1800'
$DDR3 = '1500'
$DDR4 = '1200'
If ($RAM_DDR -eq $DDR) {
	$RAM_DDR = 'DDR'
}ElseIf ($RAM_DDR -eq $DDR2) {
        $RAM_DDR = 'DDR2'
}ElseIf ($RAM_DDR -eq $DDR3) {
        $RAM_DDR = 'DDR3'
}ElseIf ($RAM_DDR -eq $DDR4) {
        $RAM_DDR = 'DDR4'
}Else {}
$RAM_DDR = [string]::join(" ",($RAM_DDR.Split(" ")))

# Get RAM clock and format
$RAM_SPEED = Get-CimInstance -Class CIM_PhysicalMemory | Select-Object Speed | Format-List | Out-String
$RAM_SPEED = $RAM_SPEED.Split()
$RAM_SPEED = $RAM_SPEED[6]
$RAM_SPEED = [string]::join(" ",($RAM_SPEED.Split(" ")))

# Get Installed RAM and format
$RAMGB = $ALLINFO.CsPhyicallyInstalledMemory | Out-String
$RAMGB = $RAMGB.Split('',[System.StringSplitOptions]::RemoveEmptyEntries)
$RAMGB = $RAMGB | Out-String
$RAMGB= [int64]$RAMGB
$RAMGB = ($RAMGB/1024)/1024

#Get RAM total slots and format
$RAM_SLOTS = Get-WmiObject -Class "Win32_PhysicalMemoryArray" | Select-Object MemoryDevices | Format-List | Out-String
$RAM_SLOTS = $RAM_SLOTS.Split('',[System.StringSplitOptions]::RemoveEmptyEntries)
$RAM_SLOTS = $RAM_SLOTS[2]
$RAM_SLOTS = [string]::join(" ",($RAM_SLOTS.Split(" ")))

# Get Disk Size and format
$DISK_SIZE_MB = Get-Volume -DriveLetter C | Select-Object Size | Format-List | Out-String
$DISK_SIZE_MB = $DISK_SIZE_MB.Split()
$DISK_SIZE = $DISK_SIZE_MB[6]
$DISK_SIZE_INT = [int64]$DISK_SIZE
$DISK_SIZE_INT = (($DISK_SIZE/1024)/1024)/1024
$DISK_SIZE_INT = [math]::Round($DISK_SIZE_INT)

# Get Windows version and format
$WINVER = $ALLINFO.WindowsProductName | Out-String
$WINVER = $WINVER.Split('',[System.StringSplitOptions]::RemoveEmptyEntries)
$WINVER = [string]::join(" ",($WINVER.Split(" ")))

# Get BIOS Key and format
$BIOSKEY = wmic path SoftwareLicensingService get Oa3xOriginalProductKey
$BIOSKEY = $BIOSKEY[2]

# Simplify path variables for 'specs' and temp file (Driveletter \ Hostname)
$SPECS = "$env:TEMP\specs.txt"
$PC_INFO = "$env:TEMP\specs1.txt"

# Insert '.' for blank cells x2
Write-Output '.,.,' > $SPECS

# Output specs to textfile
Write-Output $USRNAME | Out-string >> $SPECS
Write-Output $BIOSSN | Out-string >> $SPECS
Write-Output $MANUFAC | Out-string >> $SPECS
Write-Output $MODEL | Out-string >> $SPECS
Write-Output $DNSHOST | Out-string >> $SPECS
Write-Output "$($CPUMODEL) @ $($CPU_CLOCK)GHz" | Out-string >> $SPECS
Write-Output "$($RAM_DDR) @ $($RAM_SPEED)MHz" | Out-string >> $SPECS
Write-Output $RAM_SLOTS | Out-string >> $SPECS
Write-Output $RAMGB'GB' | Out-string >> $SPECS
Write-Output $DISK_SIZE_INT'GB' | Out-string >> $SPECS
Write-Output $WINVER | Out-string >> $SPECS

#Append key to textfile
Write-Output $BIOSKEY | Out-string >> $SPECS

# Ghetto CSV
(Get-Content $SPECS) -join "," >> $PC_INFO
$FINALOUTPUT = (Get-Content $PC_INFO) -replace ',,',','
Write-Host "`n ############################################## BEGIN CSV ############################################## `n"
Write-Host $FINALOUTPUT
Write-Host "`n ############################################### END CSV ############################################### `n"

# Cleanup
Remove-Item $SPECS
Remove-Item $PC_INFO