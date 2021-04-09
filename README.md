# awesome-mc-server-builder

sets up and hosts an awesome minecraft easily

builds a [minecraft](https://minecraft.net) server with all the necessary files, and hosts it using [ngrok](https://ngrok.com)

## Installation

Prerequisites:
- Java pre-downloaded on the system (see https://minecraft.fandom.com/wiki/Tutorials/Update_Java#Where_to_download to see which java version and build is best for your OS and architecture for minecraft)
- A free account on https://ngrok.com

This script can be downloaded in two ways:

1. **BASIC**
    
    Download source code zip and unzip it anywhere

2. **ADVANCED**
    
    `git clone` the repo

## Usage

### BASIC USAGE

- Open the directory in File Explorer.
- Double-click on the `awesome-mc-server-builder.bat` file to run it
- Follow the setup wizard on the script
- If at any point something goes wrong, press <kbd>Ctrl+C</kbd> and start again
- If you find any issues, please report them as an [issue](https://guides.github.com/features/issues/) under this repository (check if that issue already exists [here](./issues))

### ADVANCED USAGE

Run the script `awesome-mc-server-builder.ps1` with [Windows PowerShell v5](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-5.1) or [PowerShell Core](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-7) from a terminal [†](#notes)

To see the options available for the script, `cd` into the directory containing the script, then run

```powershell
powershell -c "./awesome-mc-server-builder.ps1 -?"
```

Then run the script with the desired options and arguments.

#### Options

```asciidoc
Name            [string]    name of server
Location        [string]    location to create server in (default: PS automatic variable - $HOME)
Type            [string]    type of server, one of Fabric|Paper|Forge (default: "Fabric")
RAM_MB          [Int16]     amount of RAM in MB allocated to server to run (default: 2048)
AllowOffline    [switch]    whether to allow offline (cracked) players to play
JavaArgs        [string]    extra args to pass to java executable (in addition to memory allocation) (default: "")
JarArgs         [string]    extra args to pass to server jar file (default: "-nogui")
NgrokArgs       [string]    extra args to pass to ngrok executable (example: -region=uk or -region=in) (default: "")
```

## Todo

- [ ] support for paper, forge and vanilla minecraft servers

## License

MIT

## Notes

†: Windows PowerShell is pre-downloaded on most Windows systems, check by pressing <kbd>Win+R</kbd> and typing `powershell`.
    If a window appears, it is downloaded.
