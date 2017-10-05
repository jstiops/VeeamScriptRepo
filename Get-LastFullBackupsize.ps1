#get the latest Full Backupsize or Datasize for a specific job.
$job = get-vbrbackup -Name "jobname"
$getDatasize = $false
$vmList = ($job | Select @{n="vm";e={$_.GetObjectOibsAll() | %{@($_.name,"")}}} | Select -ExpandProperty vm);
[int]$sum = 0
foreach ($vmname in $vmlist){

if($getDatasize){
  $lastFullSize = get-vbrrestorepoint | where-object {$_.IsFull -eq $true -and $_.vmname -eq $vmname} | select -last 1 | % {[math]::truncate($_.GetStorage().stats.Datasize / 1GB)}
}else{
  $lastFullSize = get-vbrrestorepoint | where-object {$_.IsFull -eq $true -and $_.vmname -eq $vmname} | select -last 1 | % {[math]::truncate($_.GetStorage().stats.Backupsize / 1GB)}
}
$sum += [int]$lastFullSize
}
Write-host "Total Full backup size(GB): " $sum
