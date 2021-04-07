# awesome-mc-server-builder

sets up and hosts an awesome minecraft easily

builds a [minecraft](https://minecraft.net) server with all the necessary files, and hosts it using [ngrok](https://ngrok.com)

## Installation

Prerequisites:
    - Java pre-downloaded on the system (see https://minecraft.fandom.com/wiki/Tutorials/Update_Java#Where_to_download to see which java version and build is best for your OS and architecture for minecraft)
    - A free account on https://ngrok.com

This script can be downloaded in two ways:

1. **BASIC**
    Download source code zip

2. **ADVANCED**
    `git clone` the repo

## Usage

Run the script `awesome-mc-server-builder.ps1` with [Windows PowerShell v5](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/install/installing-windows-powershell?view=powershell-5.1) [†](#notes) [††](#notes)

To see the options available for the script, `cd` into the directory containing the script, then run

```powershell
powershell "./awesome-mc-server-builder.ps1" -?
```

Then run the script with the desired options.

## Todo

- [ ] add interactive setup wizard
- [ ] support for paper, forge and vanilla minecraft servers

## License

MIT

## Notes

†: Windows PowerShell is pre-downloaded on most Windows systems, check by pressing <kbd>Win+R</kbd> and typing `powershell`.
    If a window appears, it is downloaded.
††: Windows PowerShell is different from PowerShell Core, make sure you download the correct version
