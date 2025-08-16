
# Throw error if DOTFILES environment variable is not set
if (-not $env:DOTFILES) {
    throw "The DOTFILES environment variable is not set. Please set it to the path of your DOTFILES repository."
}

# Elevate to run as administrator if not already
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb RunAs -ArgumentList $arguments
    exit
}

New-Item -ItemType SymbolicLink -Path "$env:APPDATA\Code\User\settings.json" -Target "$env:DOTFILES\vscode\settings.json"
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\Code\User\keybindings.json" -Target "$env:DOTFILES\vscode\keybindings.json"
