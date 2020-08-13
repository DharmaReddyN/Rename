$a = new-object -comobject wscript.shell 
Add-Type -AssemblyName System.Windows.Forms
$path = ""
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{ ShowNewFolderButton  = $false }
$null = $FolderBrowser.ShowDialog()
$path = $FolderBrowser.SelectedPath
if($path -ne ""){
$confirmpath = $a.popup("Do you want to make changes in `n$path", ` 0,"Delete Files",4) 
}
if($path -eq "" -or $confirmpath -ne 6){exit} 
Write-host "1. Rename all files to a format (Only Current Folder)`n2. Rename all files to a format (Including sub folders)`n3. Rename all files to name based on folder name"
$switch = Read-Host -Prompt "Select an option"
if($switch -eq 1){
$files = Get-ChildItem -path $path -File
} 
else{
$files = Get-ChildItem -path $path -Recurse -File
}
$c = 1
if($switch -eq 3){
$Directoryflag = $true
$prefix = ""
$suffix = ""
} 
else{
$Directoryflag = $false
do{
	$prefix = Read-Host -Prompt "Enter prefix"
	$suffix = Read-Host -Prompt "Enter Suffix"
	$intAnswer = $a.popup("Do you want these files to be renamed as $prefix<counter>$suffix ?", ` 0,"Delete Files",4) 
	}while($intAnswer -ne 6 -OR ($prefix -eq "" -AND $suffix -eq ""))
}
foreach ($file in $files) {
	$fname = $file.Name
	$fpath = $file.FullName
	$fdir = $file.Directory.Name
	if($Directoryflag){
		$pdir = (get-item $fpath ).Directory.Name
		if($prefix -ne $pdir){
		$c = 1
		}
	$prefix = $file.Directory.Name
	}
	$newname = $prefix+"$c"+$suffix+$file.extension
	if($fname -ne $newname){ 
		$q = Split-Path -Path $fpath
		$q = $q + "\$newname"
		$exists = Test-Path -Path $q
		if(!$exists){
			Rename-Item $fpath "$newname" -ErrorAction Stop
		}
	}
	$c++
}