Remove-Item $HOME\AppData\Local\secman -Recurse -Force
Remove-Item $HOME\sm -Recurse -Force

$ClearData = Read-Host -Prompt "Clear all data?\n[y/N]"

switch($ClearData) {
    {($_ -eq "y") -or ($_ -eq "yes") -or ($_ -eq "Y") -or ($_ -eq "Yes")} {
        Remove-Item $HOME\.secman -Recurse -Force
    }

    {($_ -eq "n") -or ($_ -eq "no") -or ($_ -eq "N") -or ($_ -eq "No") -or ($_ -eq "")} {
        $SM_GH_UN = git config user.name

        Write-Host "after clear, if you want to restore .secman you can clone it from your private repo in https://github.com/$SM_GH_UN/.secman"
    }

    default {
        Write-Host "wrong input"
    }
}

Write-Host "secman was uninstalled successfully... thanks you to trying secman 👋"
