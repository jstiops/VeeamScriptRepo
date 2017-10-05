#get the latest Full Backupsize or Datasize for a specific job.
#using suggestions from https://forums.veeam.com/powershell-f26/list-vm-s-which-are-backed-up-by-job-t39525.html

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$jobname
)

if ((Get-PSSnapin -Name VeeamPSSnapIn -ErrorAction SilentlyContinue) -eq $null) {
    Add-PsSnapin -Name VeeamPSSnapIn

}

$jobObject = Get-VBRJob -Name $jobname
$vms_in_jobs = new-object System.Collections.ArrayList
$allsessions = get-vbrbackupsession

foreach ($job in $jobObject){
    echo $job.name
    $vms_protected_by_job = $null
    $vms_protected_by_job = ($allsessions | where {($_.jobname -like $job.Name) -and ($_.name -notlike "*Retry*") } | sort-object CreationTimeUTC -Descending)[0] | get-vbrtasksession
    foreach ($vm_protected_by_job in $vms_protected_by_job){
        $vm_in_job = New-Object PSObject
        Add-Member -InputObject $vm_in_job -MemberType NoteProperty -Name Name -Value $vm_protected_by_job.name
        Add-Member -InputObject $vm_in_job -MemberType NoteProperty -Name JobName -value $vm_protected_by_job.jobname
        $vms_in_jobs.add($vm_in_job) | out-null
    }
   
}

$vms_in_jobs_compare1 = $vms_in_jobs.name
$vms_in_jobs_compare2 = $vms_in_jobs_compare1 | select -unique

Compare-Object $vms_in_jobs_compare1 $vms_in_jobs_compare2
$vmlist = $vms_in_jobs_compare2
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



