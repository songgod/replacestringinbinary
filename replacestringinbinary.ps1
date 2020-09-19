$inputfile = "inputfile"
$outputpath = [System.IO.Path]::GetDirectoryName($inputfile)
$filename = [System.IO.Path]::GetFileNameWithoutExtension($inputfile)
$ext = [System.IO.Path]::GetExtension($inputfile)
$searthstring = "searthstring"
$replacestring = "replacestring"

[Byte[]]$allbytes = [System.IO.File]::ReadAllBytes($inputfile)
$bcount = $allbytes.Count

[System.Text.EncodingInfo[]]$encodings = [system.Text.Encoding]::GetEncodings();
foreach($e in $encodings)
{
    $enc = [system.Text.Encoding]::GetEncoding($e.Name)

    [Byte[]]$stringToSearch = $enc.GetBytes($searthstring);
    [Byte[]]$replacementString = $enc.GetBytes($replacestring);
    $bsame = $true
    for ($j = 0; $j -lt $stringToSearch.Count; $j++) {
        if($stringToSearch[$j] -ne $replacementString[$j])
        {
            $bsame = $false
            break
        }
    } 
    if($bsame -eq $true)
    {
        continue
    }

    $scount = $stringToSearch.Count
    $count = $bcount-$scount+1
    $machcount = 0
    for ($i = 0; $i -lt $count; $i++) {
        
        $bmatch=$true;
        for ($j = 0; $j -lt $stringToSearch.Count; $j++) {
            
            if($allbytes[$i+$j] -ne $stringToSearch[$j])
            {
                $bmatch=$false
                break
            }
        }
        if($bmatch)
        {
            $machcount=$machcount+1
            for ($j = 0; $j -lt $replacementString.Count; $j++) {
                $allbytes[$i+$j]=$replacementString[$j]
            } 
        }
    }

    if($machcount -gt 0)
    {
        $outpath = $outputpath+"\"+$filename+$e.Name+$ext
        Write-Host "finded" $machcount "search string and replaced. save to: " $outpath
        [System.IO.File]::WriteAllBytes($outpath,$allbytes)
    }
}

Write-Host "finish"

