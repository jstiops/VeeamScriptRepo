
$job = get-vbrbackup -Name "jobname"
$vmList = ($job | Select @{n="vm";e={$_.GetObjectOibsAll() | %{@($_.name,"")}}} | Select -ExpandProperty vm);
foreach ($vmname in $vmlist){
get-vbrrestorepoint | where-object {$_.IsFull -eq $true -and $_.vmname -eq $vmname} | select -last 1 | % {[math]::truncate($_.GetStorage().stats.Datasize / 1GB)}
}
