#get the latest Full Backupsize or Datasize for a specific job.
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$jobname
)

if ((Get-PSSnapin -Name VeeamPSSnapIn -ErrorAction SilentlyContinue) -eq $null) {
    Add-PsSnapin -Name VeeamPSSnapIn

}

$getDatasize = $true
$jobObject = Get-VBRJob -Name $jobname
$vmList = $jobObject.GetObjectsInJob().name
$vmCount = $vmList.count

Write-host "Getting VM statistics for $vmCount VMs. Please wait...."
[int]$sumDatasize = 0
[int]$sumBackupsize = 0
foreach ($vmname in $vmlist){

$fullStats = get-vbrrestorepoint | where-object {$_.IsFull -eq $true -and $_.vmname -eq $vmname} | select -last 1 | % {$_.GetStorage().stats}
$fullDataSize = [math]::truncate($fullStats.Datasize / 1GB)
$fullBackupSize = [math]::truncate($fullStats.Backupsize / 1GB)

$sumDatasize += [int]$fullDataSize
$sumBackupsize += [int]$fullBackupSize
}
[int]$reducedByPercentage = ($sumDatasize - $sumBackupsize) / $sumDatasize * 100
$reducedByFactor = [math]::Round(($sumDatasize / $sumBackupsize),2)
Write-host "Total Full (uncompressed) datasize(GB): " $sumDatasize
Write-host "Total Full (compressed) backupsize(GB): " $sumBackupsize
Write-host "Reduced by $reducedByPercentage % or factor $reducedByFactor"


