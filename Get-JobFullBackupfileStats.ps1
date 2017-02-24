if ((Get-PSSnapin -Name VeeamPSSnapIn -ErrorAction SilentlyContinue) -eq $null) {
    Add-PsSnapin -Name VeeamPSSnapIn
}
$jobname = "put in jobname"
$vbkfiles = Get-VBRbackup -name $jobname | ForEach-Object {$_.getallstorages()} | Where-Object {$_.isfull -eq $true -and $_.isAvailable -eq $true} |select creationtime,Filepath,stats
$vbkfiles | Sort-Object -Property Filepath,CreationTime | select Filepath,stats | % {write-host $_.filepath ; write-host "Datasize:" ([math]::truncate($_.stats.datasize /1gb)) ; write-host "Backupsize:" ([math]::truncate($_.stats.backupsize /1gb)) }
