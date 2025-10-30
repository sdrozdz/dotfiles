
#Aliases
Set-Alias ll ls
Set-Alias vim nvim
#Set-Alias docker podman

#Prompt
oh-my-posh init pwsh --config "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/json.omp.json" | Invoke-Expression

#Terminal Icons
Import-Module Terminal-Icons

#Imports PSReadLine
Import-Module PSReadLine
Set-PSReadLineOption -EditMode Emacs

#Tab - Gives a menu of suggestions
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

#UpArrow will show the most recent command
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

#DownArrow will show the least recent command
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

#During auto completion, pressing arrow key up or down will move the cursor to the end of the completion
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

#Shows tooltip during completion
Set-PSReadLineOption -ShowToolTips

#Gives completions/suggestions from historical commands
Set-PSReadLineOption -PredictionSource History
