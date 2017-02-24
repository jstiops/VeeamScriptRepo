if ((Get-PSSnapin -Name VeeamPSSnapIn -ErrorAction SilentlyContinue) -eq $null) {
    Add-PsSnapin -Name VeeamPSSnapIn
}
Get-VBRRestorePoint | Where-Object {$_.IsFull -eq $true -and $_.vmname -eq "insertVMName"}
