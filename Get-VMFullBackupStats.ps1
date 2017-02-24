Get-VBRRestorePoint | Where-Object {$_.IsFull -eq $true -and $_.vmname -eq "svr-sqlbackup-001"}
