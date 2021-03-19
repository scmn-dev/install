# iwr -useb https://secman-team.github.io/install/install.ps1 | iex

$loc = "$HOME\AppData\Local\secman"
$smShUrl = "https://raw.githubusercontent.com/secman-team/tools/HEAD/sm.sh"
$sm_winLoc = "$HOME\sm"

if (Test-Path -path $loc) {
  Remove-Item $loc -Recurse -Force
}

if (Test-Path -path $sm_winLoc) {
  Remove-Item $sm_winLoc -Recurse -Force
}

Invoke-WebRequest $smShUrl -outfile sm.sh

$lv = bash sm.sh

Write-Host "Installing secman..." -ForegroundColor DarkCyan

Invoke-WebRequest https://github.com/secman-team/secman/releases/download/$lv/secman_windows_${lv}_x64.zip -outfile secman_windows.zip

Expand-Archive secman_windows.zip

New-Item $loc

Move-Item secman_windows\bin $loc

$env:Path += ";$HOME\$loc\bin"

git clone https://github.com/secman-team/sm-win $sm_winLoc

Invoke-WebRequest $smShUrl -outfile $sm_winLoc\sm.sh

Write-Host "Installing ruby deps.."  -ForegroundColor DarkYellow

gem install colorize optparse

Remove-Item secman_windows* -Recurse -Force
Remove-Item sm.sh

if (Test-Path -path $loc) {
  Write-Host "Yessss, secman was installed successfully, run secman --help"  -ForegroundColor DarkGreen
} else {
  Write-Host "Download failed 😔"
}
