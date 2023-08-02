# ConnectionType,ConnectionSubType,SubMode,Name,Group,Description,Expiration,Parent,Host,Port,CredentialUserName,CredentialDomain,CredentialPassword,URL,OpenInConsole,WebUrl

# mettre le chemin du csv a importer
$csvFilename = 'C:\Users\jbaro\OneDrive\Bureau\Linux\MobaImport\spennet\EntryList.csv'

$outfile = 'C:\Users\jbaro\OneDrive\Bureau\Linux\MobaImport\spennet\MobaXterm_Sessions.mxtsessions'

$csv = Import-Csv -Path $csvFilename -Delimiter ','
$bookmarks = 1

@'
[Bookmarks]
SubRep=
ImgNum=42
'@ | Out-File -FilePath $outfile -Encoding ASCII
#'@ | Out-File -FilePath $outfile

$output = foreach ($line in $csv) {

    if ( $line.ConnectionType -eq 'Microsoft Remote Desktop (RDP)'){
    "[Bookmarks_$($bookmarks)]
    SubRep=$($line.Group)
    ImgNum=41"
    $bookmarks++
    #rdp
        if($line.Port -eq ''){
            $port = 3389}
        else{
            $port = $line.Port}
	# 0 = normal; -1 = /admin
	$admin = 0 

        #"$($line.Name)=#91#4%$($line.Host)%$port%[Domain Interway]%$admin%-1%-1%-1%-1%0%0%-1%%%22%%0%0%%-1%%-1%0%0%-1#MobaFont%10%0%0%0%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%-1%_Std_Colors_0_%80%24%0%1%-1%<none>%%0#0# #-1"
        "$($line.Name)=#91#4%$($line.Host)%$port%[Domain Interway]%$admin%-1%-1%-1%-1%0%1%-1%%%22%%0%0%%-1%%-1%0%0%-1#MobaFont%10%0%0%0%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%-1%_Std_Colors_0_%80%24%0%1%-1%<none>%%0#0# #-1"
    }

    if( $line.ConnectionType -eq 'Navigateur Web (http/https)'){
    "[Bookmarks_$($bookmarks)]
    SubRep=$($line.Group)
    ImgNum=41"
    $bookmarks++
    #http
        $line.URL = $($line.URL).Replace('=', '__EQUAL__')
        "$($line.Name)=#313#11%$($line.URL)%-1%-1%-1%-1%-1%-1%-1%0%0#MobaFont%10%0%0%0%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%-1%_Std_Colors_0_%80%24%0%1%-1%<none>%%0#0# #-1"
    }

    if ( $line.ConnectionType -eq 'Putty'){
    "[Bookmarks_$($bookmarks)]
    SubRep=$($line.Group)
    ImgNum=41"
    $bookmarks++
    #ssh
        if($line.Port -eq ''){
            $port = 22}
        else{
            $port = $line.Port}

        "$($line.Name)= #109#0%$($line.Host)%$port%[loginuser]%%-1%-1%%%22%%0%0%0%%%-1%0%0%0%%1080%%0%0%1#MobaFont%10%0%0%0%15%236,236,236%0,0,0%180,180,192%0%-1%0%%xterm%-1%0%0,0,0%54,54,54%255,96,96%255,128,128%96,255,96%128,255,128%255,255,54%255,255,128%96,96,255%128,128,255%255,54,255%255,128,255%54,255,255%128,255,255%236,236,236%255,255,255%80%24%0%1%-1%<none>%%0#0#"
    }
    
    if ( $line.ConnectionType -eq 'Terminal  SSH'){
    "[Bookmarks_$($bookmarks)]
    SubRep=$($line.Group)
    ImgNum=41"
    $bookmarks++
    #ssh
        if($line.Port -eq ''){
            $port = 22}
        else{
            $port = $line.Port}

        "$($line.Name)= #109#0%$($line.Host)%$port%[loginuser]%%-1%-1%%%22%%0%0%0%%%-1%0%0%0%%1080%%0%0%1#MobaFont%10%0%0%0%15%236,236,236%0,0,0%180,180,192%0%-1%0%%xterm%-1%0%0,0,0%54,54,54%255,96,96%255,128,128%96,255,96%128,255,128%255,255,54%255,255,128%96,96,255%128,128,255%255,54,255%255,128,255%54,255,255%128,255,255%236,236,236%255,255,255%80%24%0%1%-1%<none>%%0#0#"
    }
    if ( $line.ConnectionType -eq 'VNC'){
    "[Bookmarks_$($bookmarks)]
    SubRep=$($line.Group)
    ImgNum=41"
    $bookmarks++
    #vnc
        if($line.Port -eq ''){
            $port = 5900}
        else{
            $port = $line.Port}

        "$($line.Name)= #128#5%$($line.Host)%5900%-1%0%%22%%%-1%0#MobaFont%10%0%0%0%15%236,236,236%30,30,30%180,180,192%0%-1%0%%xterm%-1%-1%_Std_Colors_0_%80%24%0%1%-1%<none>%%0#0# #-1"
    }

    if ( $line.ConnectionType -eq 'Dossier'){
    #Dossier
    }
<#
    if ( $line.ConnectionType -eq 'Nom d' utilisateur / mot de passe'){
    #Nom d utilisateur / mot de passe
    }

#>
}

#$output | Out-File -FilePath $outfile -Append
$output | Out-File -FilePath $outfile -Append -Encoding ASCII
