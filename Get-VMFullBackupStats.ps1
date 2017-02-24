if ((Get-PSSnapin -Name VeeamPSSnapIn -ErrorAction SilentlyContinue) -eq $null) {
    Add-PsSnapin -Name VeeamPSSnapIn
}
Get-VBRRestorePoint | Where-Object {$_.IsFull -eq $true -and $_.vmname -eq "svr-sqlbackup-001"} | ForEach-Object { write-host "Backupsizes:"; $_.GetStorage().stats.Backupsize / 1GB ; write-host "Datasizes:" ; $_.GetStorage().stats.Datasize / 1GB}
