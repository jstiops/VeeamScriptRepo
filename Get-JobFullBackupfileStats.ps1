Get-VBRbackup -name "Backup Job 24Hour RPO Citrix"  | ForEach-Object {$_.getallstorages()} | Where-Object {$_.isfull -eq $true -and $_.isAvailable -eq $true} |select creationtime,Filepath,stats
