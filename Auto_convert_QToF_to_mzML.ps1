Write-Host "Auto mzML conversion script"
Write-Host "Now running..."
##Note: Can't use mounted drives. E.g. S:/... See here: https://stackoverflow.com/questions/4055704/how-can-i-convince-powershell-run-through-task-scheduler-to-find-my-network-dr
Write-Host "Iterating over MS data storage directory. Depending on how slow your filesystem is this might take awhile..."
$files = Get-ChildItem -recurse -ea 0 -directory -filter '*.d' '\\sio-smb.ucsd.edu\moorelab\MS_data\QToF\F_drive_MooreLab_QToF_LCMS\Tim_Fallon\'
foreach ($f in $files)
{
$outfile = ($f.PSPath -split '::')[1]
    $convfile = $outfile.Substring(0,$outfile.Length-2)+".mzML" ## remove .d and add mzML
    Get-Date ##Just prints out the date + time
   if ( -not [System.IO.File]::Exists($convfile)  )
     {
        $parDir = $f.Parent.FullName
        Write-Host "Converting" $outfile "to" $convfile
        Start-Process -Wait -FilePath "C:\Program Files\ProteoWizard\ProteoWizard 3.0.20303.44b358877\msconvert.exe" -ArgumentList "--zlib -o $parDir $outfile" ##Adding --filter "zeroSamples removeExtra" didn't work
     }
     else
    {
    Write-Host "Skipping" $convfile
    }
}
Write-Host "Done running."
sleep 30 
