<#
.SYNOPSIS
    Build and setup minecraft server and host it using ngrok
.PARAMETER Name
    name of server
.PARAMETER Location
    location (parent folder) to make server
.PARAMETER Type
    type of server one of Fabric|Paper|Forge
.PARAMETER RAM_MB
    amount of RAM in MB allocated to server to run    
.PARAMETER AllowOffline
    whether to allow offline (cracked) players to play
.PARAMETER JavaArgs
    extra args to pass to java executable (in addition to memory allocation)
.PARAMETER JarArgs
    extra args to pass to server jar file
.PARAMETER NgrokArgs
    extra args to pass to ngrok executable (example: -region=uk or -region=in)
.EXAMPLE
    ./awesome-mc-server-builder.ps1 -Name="MineCity" -Location="C:\servers" -Type="Forge" -RAM_MB=2048 -JavaArgs="-XX:+UseG1GC" -NgrokArgs="-region=uk"
    # Create new Forge server named 'MineCity' in C:\servers folder with 2048M RAM allocated, passing args to java exeuctable and passing args to ngrok executable
.EXAMPLE
    ./awesome-mc-server-builder.ps1 -Name="home" -Location="D:\" -Type="Fabric" -RAM_MB=1024 -AllowOffline -JarArgs="-bonusChest"
    # Create new Fabric server named 'home' on D: drive with 1024M RAM allocated and use a gui (bcz it overwrites default value of "-nogui") and bonusChest
.NOTES
    Prerequisites:
    - Java pre-downloaded on the system (see https://minecraft.fandom.com/wiki/Tutorials/Update_Java#Where_to_download to see which java version and build is best for your OS and architecture for minecraft)
    - A free account on https://ngrok.com
.LINK
    Fabric server: https://fabricmc.net/wiki/tutorial:installing_minecraft_fabric_server
    Paper server: https://papermc.io
    Forge server: https://minecraft.fandom.com/wiki/Tutorials/Setting_up_a_Minecraft_Forge_server
    Ngrok: https://ngrok.com
    Java download options : https://minecraft.fandom.com/wiki/Tutorials/Update_Java#Where_to_download
    Setting up a minecraft server: https://minecraft.fandom.com/wiki/Tutorials/Setting_up_a_server
#>
param(
    [string]
    [Parameter(HelpMessage="name of server",Mandatory)]
    $Name
    ,
    [string]
    [Parameter(HelpMessage="location (parent folder) to make server")]
    $Location=$HOME
    ,
    [string]
    [ValidateSet('Fabric','Paper','Forge')]
    [Parameter(HelpMessage="type of server, one of Fabric|Paper|Forge")]
    $Type='Fabric'
    ,
    [Int16]
    [Parameter(HelpMessage="amount of RAM in MB allocated to server to run")]
    $RAM_MB=2048
    ,
    [switch]
    [Parameter(HelpMessage="whether to allow offline (cracked) players to play")]
    $AllowOffline
    ,
    [string]
    [Parameter(HelpMessage="extra args to pass to java executable (in addition to memory allocation)")]
    $JavaArgs=""
    ,
    [string]
    [Parameter(HelpMessage="extra args to pass to server jar file")]
    $JarArgs="-nogui"
    ,
    [string]
    [Parameter(HelpMessage="extra args to pass to ngrok executable (example: -region=uk or -region=in)")]
    $NgrokArgs=""
)

If (!($env:OS -eq "Windows_NT")){
    throw "This script only works on Windows OS currently :("
}

If ($PSEdition -eq "Core"){
    throw "Use executable ``powershell.exe`` instead of ``pwsh.exe```nThis script only works with Windows Powershell v5 currently :("
}

If (!(Test-Path $Location)){
    throw "Location '$Location' does not exist"
}

function Get-PaperServer() {
    throw "Sorry installing paper server does not work yet :("
}

function Get-FabricServer() {
    <#
    .SYNOPSIS
    Download fabric-installer.jar file and run it for making server
    #>
    $UrlPrefix="https://maven.fabricmc.net/net/fabricmc/fabric-installer/"
    $DownloadPath="$Path\fabric-installer.jar"
    
    $FabricBuild=(Read-Host "fabric installer version to download?`n(Note: this is different from minecraft version, i.e., not something like 1.16.5 or 1.14.4)`n(Leave this empty to use the default latest stable version)")
    
    ## Automatic Download
    $Links=(Invoke-WebRequest -Uri $UrlPrefix).Links
    If ($FabricBuild -in "","latest","0"){
        $Latest=(Get-LatestVersionFromLinks -Links $Links).href.Trim('/')
        $FabricBuild=$Latest
    }
    $DownloadUrl="${UrlPrefix}${FabricBuild}/fabric-installer-$FabricBuild.jar"
    
    Write-Host "Downloading latest fabric server installer ... "
    try{
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $DownloadPath
    } catch {
        throw "Could not download fabric version. `$DownloadUrl: $DownloadUrl `$DownloadPath: $DownloadPath"
    }
    Write-Host "Done."
    
    Write-Host "Installing fabric server ..."
    Start-Sleep 5
    $Command={cmd /c "java -jar ""$DownloadPath"" server -dir ""$Path"" -downloadMinecraft >""installing-fabric-server.log"" "}
    Start-Job $Command | Show-Progress
    Write-Host "Done."
    
    Write-Host "Running fabric server ..."
    $JarFile="$Path\fabric-server-launch.jar"
    $Commmand={cmd /c "java -Xmx${RAM_MB}M -jar ""$JarFile"" -initSettings -nogui >""running-fabric-server.log"""}
    Start-Job $Command | Show-Progress
    $global:JarFile=$JarFile
    Write-Host "Done."
}

function Get-ForgeServer($Version) {
    throw "Sorry installing forge server does not work yet :("
}

function Get-Server($Type) {
    Write-Host "1 DOWNLOADING AND SETTING UP SERVER ..." -ForegroundColor Green
    switch ($Type) {
        "Fabric" { Get-FabricServer }
        "Paper" { Get-PaperServer }
        "Forge" { Get-ForgeServer }
        Default {}
    }
    Write-Host "1 DONE" -ForegroundColor Green
    Write-Host ""
}

function Get-ngrok {
    <#
    .SYNOPSIS
        Setup ngrok
        Requires an ngrok account
    #>
    Write-Host "2 DOWNLOADING AND SETTING UP NGROK ..." -ForegroundColor Green
    $Login="https://dashboard.ngrok.com/login"
    $GetAuthtoken="https://dashboard.ngrok.com/get-started/your-authtoken"
    $DownloadUrl="https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-windows-amd64.zip"
    $DownloadPath="$Path\ngrok.zip"

    Write-Host "Downloading ngrok..."
    try {
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $DownloadPath
    } catch {
        throw "Could not download ngrok. `$DownloadUrl: $DownloadUrl `$DownloadPath: $DownloadPath"
    }
    Write-Host "Done."

    Write-Host "Unpacking ngrok.zip..."
    Expand-Archive -Path $DownloadPath -DestinationPath $Path -Force
    Write-Host "Done."

    Write-Host "Cleaning up ngrok.zip..."
    Remove-Item -Path $DownloadPath -Force
    Write-Host "Done."
    
    $AccExists=(Read-Host "Do you have an ngrok (https://ngrok.com) account? [Y/n] ")
    If ($AccExists -eq "n"){ $AccExists=$false } else { $AccExists=$true }
    IF ($AccExists -eq $false){
        Write-Host "Login on the site that appears"
        Start-Sleep 5
        Start-Process -FilePath $Login
        Read-Host "[press enter to continue]"
    }

    Write-Host "On the following site, look for the authtoken and copy it"
    Start-Sleep 5
    Start-Process -FilePath $GetAuthtoken
    $Authtoken=(Read-Host "Paste the authtoken here")

    Write-Host "Setting up ngrok..."
    cmd /c ".\ngrok authtoken $Authtoken" > "ngrok-auth.log"
    Write-Host "Done."
    Write-Host "2 DONE" -ForegroundColor Green
    Write-Host ""
}

function Setup {}

function New-configure_server_ps1 {
    <#
    .SYNOPSIS
        Create `configure_server.ps1` file
    #>
    Write-Host "3 CREATING configure_server.ps1 ..." -ForegroundColor Green
    Write-Host "Run the configure_server.ps1 file after running the server atleast once"

    $contents = {
Write-Host "Configuring Server..."

`$Name="$Name"
`$Path="$Path"
`$Type="$Type"
`$RAM_MB=$RAM_MB
`$AllowOffline=`$$AllowOffline

try {

    If (`$AllowOffline){
        (Get-Content "`$Path\server.properties" -Raw) -replace "online-mode=true","online-mode=false" | Set-Content "`$Path\server.properties"
    }

    (Get-Content "`$Path\server.properties" -Raw) -replace "motd=A Minecraft Server","motd=\u00A7a---\u00A76>\u00A7b\u00A7l `$Name \u00A76<\u00A7a---" | Set-Content "`$Path\server.properties"

    (Get-Content "`$Path\eula.txt" -Raw) -replace 'false','true' | Set-Content "`$Path\eula.txt"
} catch {
    throw "Could not change server.properties and/or eula.txt.`nCheck if these files exist, and have write permissions."
}

Write-Host "Done."
}
    # substitute variable values
    $contentsString=$ExecutionContext.InvokeCommand.ExpandString($contents)
    Set-Content -Path "$Path\configure_server.ps1" -Value $contentsString
    Write-Host "3 DONE" -ForegroundColor Green
    Write-Host ""
}

function New-start_ps1 {
    <#
    .SYNOPSIS
        Create `start.ps1` file to start server
    #>
    Write-Host "4 CREATING start.ps1 ..." -ForegroundColor Green
    Write-Host "Run the start.ps1 file after the server setup is complete and after running configure_server.ps1"

    $contents = {
Write-Host "Starting server..."

`$Name="$Name"
`$Path="$Path"
`$Type="$Type"
`$RAM_MB=$RAM_MB
`$AllowOffline=`$$AllowOffline
`$JarFile="$JarFile"
`$JavaArgs="$JavaArgs"
`$JarArgs="$JarArgs"
`$NgrokArgs="$NgrokArgs"

Start-Process -FilePath "cmd" -ArgumentList "/k .\ngrok tcp `$NgrokArgs 25565"

cmd /c "java -Xms`${RAM_MB}M -Xmx`${RAM_MB}M `$JavaArgs -jar `$JarFile `$JarArgs"
}
    # substitute variable values
    $contentsString=$ExecutionContext.InvokeCommand.ExpandString($contents)
    Set-Content -Path "$Path\start.ps1" -Value $contentsString
    Write-Host "4 DONE" -ForegroundColor Green
    Write-Host ""
}

function Cleanup {
    Write-Host "5 FINISHING ..." -ForegroundColor Green
    Set-Location $CWD
    Write-Host ""
@"
INSTRUCTIONS:
    - run configure_server.ps1 to configure server
    - run start.ps1 to start server
    - a new cmd windows will spawn showing ngrok logs
      on that windows find the ip address
      it will look something like this
      eg: `e[1m 0.tcp.ngrok.io:17456 `e[0m
    - to connect to the minecraft server
      copy the entire ip address and paste it in the 'server address' box
      and run
      (note: the final 5 digits of the address will change each time you close and start serveragain)
    - if you are playing on the same computer as the server
      you can use the ip address "localhost:25565" instead of the above
    - to stop the server, run the command "stop" or "/stop" in the server console
      and close the ngrok cmd window
    - have fun playing!
"@ | Write-Host

Write-Host "5 DONE" -ForegroundColor Green
Write-Host ""
}

function Get-LatestVersionFromLinks($Links) {
    # remove alphabetic text links
    $Links = $Links | ForEach-Object {if ($_.outerText -match ".*[a-z].*"){} else {return $_}}
    $LatestLink=$Links[1]
    # find latest link by comparing strings
    foreach ($L in $Links) {
        If ($L.outerText -gt $LatestLink.outerText){$LatestLink=$L}
    }
    return $LatestLink
}

function Show-Progress {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [System.Management.Automation.Job]
        $Job
        ,
        [string]
        [ValidateSet('basic_spinner','wave')]
        $Type="basic_spinner"
    )

    Write-Host "`b`b" -NoNewline
    $SB = switch ($Type) {
        "basic_spinner" {
                {
                $chrs=@('-','\','|','/')
                foreach ($c in $chrs){
                    Write-Host $c -NoNewLine
                    Start-Sleep 1
                    Write-Host "`b" -NoNewLine
                }
            }
        }
        "wave" {
                {}
        }
        Default { {} }
    }
    while ($Job.State -notin $JobEndStates) {
        $SB.Invoke()
    }
}


Write-Host ""

Write-Host "STARTING" -ForegroundColor Yellow

Write-Host ""

@"This script will help you build your own minecraft server and host it using ngrok! (inspired by https://github.com/SirDankenstien/dank.serverbuilder)

Prerequisites:
    - Java pre-downloaded on the system (see https://minecraft.fandom.com/wiki/Tutorials/Update_Java#Where_to_download to see which java version and build is best for your OS and architecture for minecraft)
    - A free account on https://ngrok.com
"@ | Write-Host

Write-Host ""

$CWD=(Get-Location)

$Path=(Join-Path $Location $Name)

try {
    if (!(Test-Path $Path)){
        New-Item -Path $Location -Name $Name -ItemType Directory -Force *> $null
    }
} catch { throw "Could not create path '$Path'" }

Set-Location $Path

$global:JobEndStates="Completed","Failed","Stopped","Suspended","Disconnected"
$global:BadJobEndStates="Failed","Stopped","Suspended","Disconnected"
$global:JarFile="$Path\server.jar"

Write-Host ""

Start-Sleep 3

Get-Server -Type $Type

Start-Sleep 3

Get-ngrok

New-configure_server_ps1

Start-Sleep 3

New-start_ps1

Start-Sleep 3

Cleanup

Start-Sleep 3

Write-Host "FINISHED" -ForegroundColor Yellow
