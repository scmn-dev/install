# iwr -useb https://raw.githubusercontent.com/secman-team/install/HEAD/win/install.ps1 | iex

$loc = "$HOME\AppData\Local\secman"
$smShUrl = "https://raw.githubusercontent.com/secman-team/tools/HEAD/sm.sh"
$sm_winLoc = "$HOME\sm"

curl $smShUrl -outfile sm.sh

$lv = bash sm.sh

echo "Installing secman..."

curl https://github.com/secman-team/secman/releases/download/$lv/secman_windows_${lv}_x64.zip -outfile secman_windows.zip

Expand-Archive secman_windows.zip

mkdir $loc

mv secman_windows\bin $loc

$env:Path += ";$HOME\AppData\Local\secman\bin"

echo "Cloning sm folder..."

git clone https://github.com/secman-team/sm-win $sm_winLoc

curl $smShUrl -outfile $sm_winLoc\sm.sh

echo "Installing ruby deps"

gem install colorize optparse

Remove-Item secman_windows* -Recurse -Force
Remove-Item sm.sh

echo "yessss, secman was installed successfully, run secman --help"
