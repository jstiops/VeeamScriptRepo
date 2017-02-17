#display backup size on repo disk for each job and full backup day
Get-VBRJob | select @{N="Job Name";E={$_.Name}}, @{N="Size";E={[math]::Round(((Get-VBRBackup -name ($_.Name)).GetAllStorages().Stats.BackupSize | Measure-Object -sum).Sum/1gb,1)}}, @{N="Full Backup Days";E={$_.BackupTargetOptions.FullBackupDays}} | Sort-Object -Property "Job Name" 
