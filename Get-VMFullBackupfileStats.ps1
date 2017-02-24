# display full vbk file stats for specific VM
if ((Get-PSSnapin -Name VeeamPSSnapIn -ErrorAction SilentlyContinue) -eq $null) {
    Add-PsSnapin -Name VeeamPSSnapIn
}
$vmname = "putVMNameHere"
Get-VBRRestorePoint | Where-Object {$_.IsFull -eq $true -and $_.vmname -eq $vmname} | ForEach-Object { Write-Host $_.creationtime; write-host "Backupsizes:"; [math]::truncate($_.GetStorage().stats.Datasize / 1GB) ; write-host "Datasizes:" ; [math]::truncate($_.GetStorage().stats.Datasize / 1GB)  ; Write-host "=========="}
