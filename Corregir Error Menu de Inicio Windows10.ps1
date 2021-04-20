Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName PresentationFramework


function Filter-PSTranscriptHeaderAndFooter 
{ 
    [CmdletBinding()] 
    param ( 
        [Parameter( 
                Mandatory = $true, 
                ParameterSetName = 'Path', 
                Position = 0 
        )] 
        [string]$Path 
    ) 
 
    $ErrorActionPreference = 'stop' 
 
    [System.Collections.ArrayList]$fileContents = Get-Content -Path $Path 
 
    $rowOfAsterixes = '^**********************$' -replace '\*', '\*' 
 
    $fiftyLinesShouldBeEnough = 50 
 
    # find the SECOND instance of the delimiter because PSTranscripts START with that string 
    # so we start our index at 1 instead of the traditional 0.  ergo, we skip the first line 
    #  
    # (start of file) 
    # ********************** 
    # Windows PowerShell transcript start 
    # Start time: 20160813152245 
    # (header stuff) 
    #  
    for ( 
        $i = 1  
        ( 
            ($i -lt $fiftyLinesShouldBeEnough) -and 
            ($i -lt $fileContents.Count) 
        )  
        $i++ 
    ) 
    { 
        if ($fileContents[$i] -match $rowOfAsterixes) 
        { 
            break 
        }    
    } 
 
    # add 2 more lines because we're stopping AT the line that matches, but we want the NEXT line 
    # actually, we don't, because the next line is still part of the header (sounds like a bug 
    # to me, but I'm sure they have a reason. Anyhow, we want the line AFTER the next line. it 
    # helps if you see the section of the log in question: 
    #  
    # (PSTranscript header stuff) 
    # WSManStackVersion: 3.0 
    # PSRemotingProtocolVersion: 2.3 
    # SerializationVersion: 1.1.0.1 
    # ********************** 
    # Transcript started, output file is C:\Users\timdunn\desktop\foo.txt 
    # [PASS]: DataDataData BlahBlahBlah 
    # (actual transcribed data) 
    # 
    $firstLineAfterHeader = $i + 2 
 
    # we're now looking at the file from the bottom up 
    $fileContents.Reverse() 
 
    # find the SECOND instance of the delimiter because PSTranscripts END with that string, too 
    #  
    # (actual transcribed data) 
    # [PASS]: DataDataData BlahBlahBlah 
    # ********************** 
    # Windows PowerShell transcript end 
    # End time: 20160813152450 
    # ********************** 
    # (end of file) 
    #  
    for ( 
        $i = 1  
        ( 
            ($i -lt $fiftyLinesShouldBeEnough) -and 
            ($i -lt $fileContents.Count) 
        )  
        $i++ 
    ) 
    { 
        if ($fileContents[$i] -match $rowOfAsterixes) 
        { 
            break 
        }    
    } 
 
    # subtract 2 more lines because we're stopping AT the line that matches, but we want the NEXT line 
    # and subtract 1 more because the array is REVERSED, so the offest is increased by 1 
    $lastLineBeforeFooter = $fileContents.Count - $i - 2 
 
    # re-reverse the arraylist (is that just 'versing', then?) so we output it in the correct order 
    $fileContents.Reverse() 
 
    # array slices are cool 
    $fileContents[$firstLineAfterHeader..$lastLineBeforeFooter] 
}


$ScriptDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('.\')
cd $ScriptDir

$ScriptName = $MyInvocation.MyCommand.Name
$nombreHost = $env:computername
$FechaHora = (Get-Date).tostring(“dd-MM-yyyy HH mm ss”)

$FileLogsE = "$ScriptDir\Logs_$nombreHost $FechaHora.log"
$fileErrores = "$ScriptDir\Log_Erorres.log"

try{
Start-Transcript -Path $FileLogsE -Force -ErrorAction Ignore
}
Catch {
Add-Content $fileErrores -Value "not found because $($Error[0])"
}

$FechaHoraSistema = $FechaHora = (Get-Date).tostring(“dd-MM-yyyy HH:mm:ss”)
Write-Host "$FechaHoraSistema | Iniciando Tools Mike Mike 2021" -foregroundcolor "gree"

$FechaHoraSistema = $FechaHora = (Get-Date).tostring(“dd-MM-yyyy HH:mm:ss”)
Write-Host "$FechaHoraSistema | Corrigiendo User Load" -foregroundcolor "gree"

$Agrega1 = REG ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v BingSearchEnabled /t REG_DWORD /d 0 /f
$Agrega2 = REG ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v CortanaConsent /t REG_DWORD /d 0 /f

$FechaHoraSistema = $FechaHora = (Get-Date).tostring(“dd-MM-yyyy HH:mm:ss”)
Write-Host "$FechaHoraSistema | Corrigiendo User Load: $Agrega1" -foregroundcolor "gree"
Write-Host "$FechaHoraSistema | Corrigiendo User Load: $Agrega2" -foregroundcolor "gree"



$FechaHoraSistema = $FechaHora = (Get-Date).tostring(“dd-MM-yyyy HH:mm:ss”)
Write-Host "$FechaHoraSistema | Corrigiendo User Default" -foregroundcolor "gree"

 $UserDafulRuta = "$env:HOMEDRIVE\Users\Default\NTUSER.DAT"

 if (Test-Path -Path $UserDafulRuta){
    try {
    $SalidaA = & REG LOAD HKLM\DEFAULT $UserDafulRuta

    $Salida1 = REG ADD HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v CortanaConsent /t REG_DWORD /d 0 /f
    $Salida2 = REG ADD HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v BingSearchEnabled /t REG_DWORD /d 0 /f

    $SalidaB = & REG UNLOAD HKLM\DEFAULT
        }
        catch {
        
        }
 }else{

  $UserDafulRuta = "C:\Users\Default\NTUSER.DAT"
   if (Test-Path -Path $UserDafulRuta){
        $SalidaA = & REG LOAD HKLM\DEFAULT $UserDafulRuta

        $Salida1 = REG ADD HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v CortanaConsent /t REG_DWORD /d 0 /f
        $Salida2 = REG ADD HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v BingSearchEnabled /t REG_DWORD /d 0 /f

        $SalidaB = & REG UNLOAD HKLM\DEFAULT  
   }
 }
 
$FechaHoraSistema = $FechaHora = (Get-Date).tostring(“dd-MM-yyyy HH:mm:ss”)
Write-Host "$FechaHoraSistema | Corrigiendo User Default Mount: $SalidaA" -foregroundcolor "gree"
Write-Host "$FechaHoraSistema | Corrigiendo User Default Des-Mount: $SalidaB" -foregroundcolor "gree"
Write-Host "$FechaHoraSistema | Corrigiendo User Default: $Salida1" -foregroundcolor "gree"
Write-Host "$FechaHoraSistema | Corrigiendo User Default: $Salida2" -foregroundcolor "gree"



$FechaHoraSistema = $FechaHora = (Get-Date).tostring(“dd-MM-yyyy HH:mm:ss”)
Write-Host "$FechaHoraSistema | Buscando Usarios Locales" -foregroundcolor "gree"

#$stringOutput = Invoke-Command -ScriptBlock {quser.exe}
$UserLoginns = quser 2>&1
#$UserLoginns = $UserLoginns | ForEach-Object -Process {$_ -replace '\s{2,}',','}
#$UserLoginns = $UserLoginns | ConvertFrom-String

$PatternSID = 'S-1-5-21-\d+-\d+\-\d+\-\d+$'
 
# Get Username, SID, and location of ntuser.dat for all users
$ProfileList = gp 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*' | Where-Object {$_.PSChildName -match $PatternSID} | 
    Select  @{name="SID";expression={$_.PSChildName}}, 
            @{name="UserHive";expression={"$($_.ProfileImagePath)\ntuser.dat"}}, 
            @{name="Username";expression={$_.ProfileImagePath -replace '^(.*[\\\/])', ''}} | sort Username
 
$CantidadUser = $ProfileList.Count
$FechaHoraSistema = $FechaHora = (Get-Date).tostring(“dd-MM-yyyy HH:mm:ss”)
Write-Host "$FechaHoraSistema | Buscando Usarios Locales: Se encontraron un total de $CantidadUser" -foregroundcolor "gree"


$FechaHoraSistema = $FechaHora = (Get-Date).tostring(“dd-MM-yyyy HH:mm:ss”)
Write-Host "$FechaHoraSistema | Corrigiendo Usarios Locales" -foregroundcolor "gree"

$Cuentaa = 1
foreach ($unProfile in ($ProfileList)){
 $ArchivoHive = $unProfile.UserHive
 $NomUser = $unProfile.Username


$ExisteFile = Test-Path -Path $ArchivoHive
$ExisteUserr = $UserLoginns -like "*$NomUser*" 


    if ($ExisteFile -eq $true -and !$ExisteUserr){

    try {
    Write-Host "$FechaHoraSistema | Corrigiendo Usarios Locales -> $Cuentaa de $CantidadUser UserName: $NomUser Detalle: Analizando" -foregroundcolor "gree"
    $Salida1 = & REG LOAD HKLM\DEFAULT $ArchivoHive

    $Salida2 = REG ADD HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v CortanaConsent /t REG_DWORD /d 0 /f
    $Salida3 = REG ADD HKLM\DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Search /v BingSearchEnabled /t REG_DWORD /d 0 /f

    $Salida4 = & REG UNLOAD HKLM\DEFAULT 
    $FechaHoraSistema = $FechaHora = (Get-Date).tostring(“dd-MM-yyyy HH:mm:ss”)
    Write-Host "$FechaHoraSistema | Corrigiendo Usarios Locales -> $Cuentaa de $CantidadUser UserName: $NomUser Detalle Mount: $Salida1" -foregroundcolor "gree"
    Write-Host "$FechaHoraSistema | Corrigiendo Usarios Locales -> $Cuentaa de $CantidadUser UserName: $NomUser Detalle Set: $Salida2" -foregroundcolor "gree"
    Write-Host "$FechaHoraSistema | Corrigiendo Usarios Locales -> $Cuentaa de $CantidadUser UserName: $NomUser Detalle Set: $Salida3" -foregroundcolor "gree"
    Write-Host "$FechaHoraSistema | Corrigiendo Usarios Locales -> $Cuentaa de $CantidadUser UserName: $NomUser Detalle Des-Mount: $Salida4" -foregroundcolor "gree"
        }
       catch {
        
        }
    }else{
    Write-Host "$FechaHoraSistema | Corrigiendo Usarios Locales -> $Cuentaa de $CantidadUser UserName: $NomUser Detalle: NO FILE" -foregroundcolor "gree"
    }

$Cuentaa +=1
}


$FechaHoraSistema = $FechaHora = (Get-Date).tostring(“dd-MM-yyyy HH:mm:ss”)
Write-Host "$FechaHoraSistema | Fin Tools Mike Mike 2021 :)" -foregroundcolor "gree"


try{
Stop-Transcript -Verbose
}
Catch {
Add-Content $fileErrores -Value "not found because $($Error[0])"
}

$Filtross = Filter-PSTranscriptHeaderAndFooter -Path $FileLogsE 
$Filtross >$FileLogsE 

sleep 5