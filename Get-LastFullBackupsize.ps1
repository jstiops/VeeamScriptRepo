#get the latest Full Backupsize or Datasize for a specific job.
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$jobname
)

if ((Get-PSSnapin -Name VeeamPSSnapIn -ErrorAction SilentlyContinue) -eq $null) {
    Add-PsSnapin -Name VeeamPSSnapIn

}

$getDatasize = $false
$jobObject = Get-VBRJob -Name $jobname
$vmList = $jobObject.GetObjectsInJob().name
$vmCount = $vmList.count

Write-host "Getting VM statistics for $vmCount VMs. Please wait...."
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

