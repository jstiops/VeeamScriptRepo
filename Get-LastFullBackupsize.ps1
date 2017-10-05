
$job = get-vbrbackup -Name "jobname"
$vmList = ($job | Select @{n="vm";e={$_.GetObjectOibsAll() | %{@($_.name,"")}}} | Select -ExpandProperty vm);
[int]$sum = 0
foreach ($vmname in $vmlist){
#$lastFullDataSize = get-vbrrestorepoint | where-object {$_.IsFull -eq $true -and $_.vmname -eq $vmname} | select -last 1 | % {[math]::truncate($_.GetStorage().stats.Datasize / 1GB)}
$lastFullBackupSize = = get-vbrrestorepoint | where-object {$_.IsFull -eq $true -and $_.vmname -eq $vmname} | select -last 1 | % {[math]::truncate($_.GetStorage().stats.Backupsize / 1GB)}
$sum += [int]$lastFullBackupSize
}
$sum

