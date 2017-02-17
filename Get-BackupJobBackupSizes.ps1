#display the size that backup file occupies on a repository for every job together with the VM data size
if ((Get-PSSnapin -Name VeeamPSSnapIn -ErrorAction SilentlyContinue) -eq $null) {
    Add-PsSnapin -Name VeeamPSSnapIn
}
Get-VBRBackup | Select @{N="Job Name";E={$_.Name}}, @{N="VM Data Size (GB)";E={[math]::Round(($_.GetAllStorages().Stats.datasize | Measure-Object -Sum).Sum/1GB,1)}},@{N="Backupsize on Repo (GB)";E={[math]::Round(($_.GetAllStorages().Stats.backupsize | Measure-Object -Sum).Sum/1GB,1)}} | Sort-Object -Property "Job Name" | Format-Table -AutoSize
