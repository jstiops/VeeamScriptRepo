#display the size that backup file occupies on a repository for every job.
Get-VBRBackup | Select @{N="Job Name";E={$_.Name}}, @{N="Size (GB)";E={[math]::Round(($_.GetAllStorages().Stats.BackupSize | Measure-Object -Sum).Sum/1GB,1)}} | Format-Table -AutoSize
