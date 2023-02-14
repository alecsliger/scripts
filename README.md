# Scripts
General use scripts and shortcuts


## Linux

  `grepip.sh`

Pipe this into a concatenated file to grab anything that looks like an IP address. It can technically return invalid IP's too but it 'just works' _-Todd Howard_



  `scp.sh`

I personally hate the scp syntax so I made this to avoid using it entirely. The best way to use it is to make a copy of the script for each server you intend on establishing a copy relationship with, and editing the OPTIONS lines accordingly. These can probably be exploited for privilege escalation, so just keep them on a thumb drive to minimize exposure in that regard.



## Windows

  `MoveSubfilesToMain.bat`

Self explanitory



  `GitSystemSpecs.ps1`

Executes a set of commands to output a very specific set of system specifications and Windows key(s) in CSV format

One liner:
powershell -ExecutionPolicy Bypass -Command "[scriptblock]::Create((Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/alecsliger/scripts/main/Windows/GitSystemSpecs.ps1").Content).Invoke();"
