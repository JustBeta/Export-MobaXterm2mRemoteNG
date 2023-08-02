<#
Function Parse-IniFile ($file) {
  $ini = @{}

  # Create a default section if none exist in the file. Like a java prop file.
  $section = "NO_SECTION"
  $ini[$section] = @{}

  switch -regex -file $file {
    "^\[(.+)\]$" {
      $section = $matches[1].Trim()
      $ini[$section] = @{}
    }
    "^\s*([^#].+?)\s*=\s*(.*)" {
      $name,$value = $matches[1..2]
      # skip comments that start with semicolon:
      if (!($name.StartsWith(";"))) {
        $ini[$section][$name] = $value.Trim()
      }
    }
  }
  $ini
}

$PSScriptRoot

function Parse-IniFile ($filePath)
{
    $ini = [ordered]@{}
    $count = @{}
    switch -regex -file $filePath
    {
        #Section.
        "^\[(.+)\]$"
        {
            $section = $matches[1].Trim()
            $ini[$section] = [ordered]@{}
            $count[$section] = @{}
            $CommentCount = 0
            continue
        }
        # Comment
        "^(;.*)$"
        {
            $value = $matches[1]
            $CommentCount = $CommentCount + 1
            $name = "Comment" + $CommentCount
            if ($section -eq $null) {
                $section = "header"
                $ini[$section] = [ordered]@{}
            }
            $ini[$section][$name] = $value
            continue
        }

        #Array Int.
        "^\s*([^#][\w\d_-]+?)\[]\s*=\s*(\d+)\s*$"
        {
            $name,$value = $matches[1..2]
            if (!$ini[$section][$name]) {
                $ini[$section][$name] = [ordered]@{}
            }
            if (!$count[$section][$name]) {
                $count[$section][$name] = 0
            }
            $ini[$section][$name].Add($count[$section][$name], [int]$value)
            $count[$section][$name] += 1
            continue
        }
        #Array Decimal
        "^\s*([^#][\w\d_-]+?)\[]\s*=\s*(\d+\.\d+)\s*$"
        {
            $name,$value = $matches[1..2]
            if (!$ini[$section][$name]) {
                $ini[$section][$name] = [ordered]@{}
            }
            if (!$count[$section][$name]) {
                $count[$section][$name] = 0
            }
            $ini[$section][$name].Add($count[$section][$name], [decimal]$value)
            $count[$section][$name] += 1
            continue
        }
        #Array Everything else
        "^\s*([^#][\w\d_-]+?)\[]\s*=\s*(.*)"
        {
            $name,$value = $matches[1..2]
            if (!$ini[$section][$name]) {
                $ini[$section][$name] = [ordered]@{}
            }
            if (!$count[$section][$name]) {
                $count[$section][$name] = 0
            }
            $ini[$section][$name].Add($count[$section][$name], $value.Trim())
            $count[$section][$name] += 1
            continue
        }

        #Array associated Int.
        "^\s*([^#][\w\d_-]+?)\[([\w\d_-]+?)]\s*=\s*(\d+)\s*$"
        {
            $name, $association, $value = $matches[1..3]
            if (!$ini[$section][$name]) {
                $ini[$section][$name] = [ordered]@{}
            }
            $ini[$section][$name].Add($association, [int]$value)
            continue
        }
        #Array associated Decimal
        "^\s*([^#][\w\d_-]+?)\[([\w\d_-]+?)]\s*=\s*(\d+\.\d+)\s*$"
        {
            $name, $association, $value = $matches[1..3]
            if (!$ini[$section][$name]) {
                $ini[$section][$name] = [ordered]@{}
            }
            $ini[$section][$name].Add($association, [decimal]$value)
            continue
        }
        #Array associated Everything else
        "^\s*([^#][\w\d_-]+?)\[([\w\d_-]+?)]\s*=\s*(.*)"
        {
            $name, $association, $value = $matches[1..3]
            if (!$ini[$section][$name]) {
                $ini[$section][$name] = [ordered]@{}
            }
            $ini[$section][$name].Add($association, $value.Trim())
            continue
        }

        #Int.
        "^\s*([^#][\w\d_-]+?)\s*=\s*(\d+)\s*$"
        {
            $name,$value = $matches[1..2]
            $ini[$section][$name] = [int64]$value
            continue
        }
        #Decimal.
        "^\s*([^#][\w\d_-]+?)\s*=\s*(\d+\.\d+)\s*$"
        {
            $name,$value = $matches[1..2]
            $ini[$section][$name] = [decimal]$value
            continue
        }
        #Everything else.
        "^\s*([^#][\w\d_-]+?)\s*=\s*(.*)"
        {
            $name,$value = $matches[1..2]
            $ini[$section][$name] = $value.Trim()
            continue
        }
    }

    return $ini
}

function Set-IniFile ($ini, $filePath)
{
    $output = @()
    foreach($section in $ini.Keys)
    {
        # Put a newline before category as seperator, only if there is null 
        $seperator = if ($output[$output.Count - 1] -eq $null) { } else { "`n" }
        $output += $seperator + "[$section]";

        foreach($key in $ini.$section.Keys)
        {
            if ( $key.StartsWith('Comment') )
            {
                $output += $ini.$section.$key
            }
            elseif ($ini.$section.$key -is [System.Collections.Specialized.OrderedDictionary]) {
                foreach($subkey in $ini.$section.$key.Keys) {
                    if ($subkey -is [int]) {
                        $output += "$key[] = " + $ini.$section.$key.$subkey
                    } else {
                        $output += "$key[$subkey] = " + $ini.$section.$key.$subkey
                    }
                }
            }
            else
            {
                $output += "$key = " + $ini.$section.$key
            }
        }
    }

    $output | Set-Content $filePath -Force
}
#>
function New-UUID($Wrap_With_Brackets = $False){

    For($Index = 0;$Index -lt 16;$Index ++){
      
        If ($Index -eq 7) {
        $Byte = 64 + (Get-Random -Maximum 15)
        }ElseIf ($Index -eq 9){
        $Byte = 128 + (Get-Random -Maximum 63)
        }Else{
        $Byte = (Get-Random -Maximum 255)
        }
      
        If ($Index -eq 4 -or $Index -eq 6 -Or $Index -eq 8 -Or $Index -eq 10){
        $UUID_String = $UUID_String + "-"
        }
      
        #$UUID_String + RSet(Format-Hex $Byte), 2, "0")
        $UUID_String = $UUID_String + $Byte.ToString('X2')
      
    }
    
    If ($Wrap_With_Brackets -eq $True){
        $UUID_String = "{" + $UUID_String + "}"
    }
    
    return $UUID_String.ToLower()
}

function Get-IniContent ($filePath)
{
    $ini = @{}
    switch -regex -file $FilePath
    {
        “^\[(.+)\]” # Section
        {
            $section = $matches[1]
            $ini[$section] = @{}
            $CommentCount = 0
        }
        “^(;.*)$” # Comment
        {
            $value = $matches[1]
            $CommentCount = $CommentCount + 1
            $name = “Comment” + $CommentCount
            $ini[$section][$name] = $value
        }
        “(.+?)\s*=(.*)” # Key
        {
            $name,$value = $matches[1..2]
            $ini[$section][$name] = $value
        }
    }
    return $ini
}

$icons = @("SSH","Telnet","Rsh","Xdmcp","RDP","VNC","FTP","SFTP","Serial","File","Shell","Browser","Mosh","Aws S3","WSL")
$resolutions = @("FitToWindow","Fullscreen","SmartSAspect","Res640x480","Res800x600","Res1024x768","Res1152x864","Res1280x720","Res1280x968","Res1280x1024","Res1400x1050","Res1600x1200","Res1920x1080","Res1276x936","Res1916x988","Res1920x1200","Res1280x800","Res1360x768","Res1366x768","Res1440x900","Res1536x864","Res1600x900","Res1680x1050","Res2048x1152","Res2560x1080","Res2560x1440","Res3440x1440","Res3840x2160")
$couleurs = @("auto","Colors8Bit","Colors16Bit","Colors24Bit","Colors32Bit")

$ini = Get-IniContent -filePath ".\MobaXterm.ini"
$Groups = ($ini.GetEnumerator() | Where-Object { $_.Name -Like  "bookmarks*" }) | Sort-Object {[int64]$($_.Name.ToString()).Split('_')[1]}
$Credentials = ($ini.GetEnumerator() | Where-Object { $_.Name -Like  "Credentials" })

#$mRemoteNG = "Name;Id;Parent;NodeType;Description;Icon;Panel;Username;Password;Domain;Hostname;Protocol;PuttySession;Port;ConnectToConsole;UseCredSsp;RenderingEngine;ICAEncryptionStrength;RDPAuthenticationLevel;LoadBalanceInfo;Colors;Resolution;AutomaticResize;DisplayWallpaper;DisplayThemes;EnableFontSmoothing;EnableDesktopComposition;CacheBitmaps;RedirectDiskDrives;RedirectPorts;RedirectPrinters;RedirectSmartCards;RedirectSound;RedirectKeys;PreExtApp;PostExtApp;MacAddress;UserField;ExtApp;VNCCompression;VNCEncoding;VNCAuthMode;VNCProxyType;VNCProxyIP;VNCProxyPort;VNCProxyUsername;VNCProxyPassword;VNCColors;VNCSmartSizeMode;VNCViewOnly;RDGatewayUsageMethod;RDGatewayHostname;RDGatewayUseConnectionCredentials;RDGatewayUsername;RDGatewayPassword;RDGatewayDomain;InheritCacheBitmaps;InheritColors;InheritDescription;InheritDisplayThemes;InheritDisplayWallpaper;InheritEnableFontSmoothing;InheritEnableDesktopComposition;InheritDomain;InheritIcon;InheritPanel;InheritPassword;InheritPort;InheritProtocol;InheritPuttySession;InheritRedirectDiskDrives;InheritRedirectKeys;InheritRedirectPorts;InheritRedirectPrinters;InheritRedirectSmartCards;InheritRedirectSound;InheritResolution;InheritAutomaticResize;InheritUseConsoleSession;InheritUseCredSsp;InheritRenderingEngine;InheritUsername;InheritICAEncryptionStrength;InheritRDPAuthenticationLevel;InheritLoadBalanceInfo;InheritPreExtApp;InheritPostExtApp;InheritMacAddress;InheritUserField;InheritExtApp;InheritVNCCompression;InheritVNCEncoding;InheritVNCAuthMode;InheritVNCProxyType;InheritVNCProxyIP;InheritVNCProxyPort;InheritVNCProxyUsername;InheritVNCProxyPassword;InheritVNCColors;InheritVNCSmartSizeMode;InheritVNCViewOnly;InheritRDGatewayUsageMethod;InheritRDGatewayHostname;InheritRDGatewayUseConnectionCredentials;InheritRDGatewayUsername;InheritRDGatewayPassword;InheritRDGatewayDomain;InheritRDPAlertIdleTimeout;InheritRDPMinutesToIdleTimeout;InheritSoundQuality`r`n"
#new
$mRemoteNG_New = "Name;Id;Parent;NodeType;Description;Icon;Panel;Username;Password;Domain;Hostname;Port;VmId;Protocol;SSHTunnelConnectionName;OpeningCommand;SSHOptions;PuttySession;ConnectToConsole;UseCredSsp;UseRestrictedAdmin;UseRCG;UseVmId;UseEnhancedMode;RenderingEngine;RDPAuthenticationLevel;LoadBalanceInfo;Colors;Resolution;AutomaticResize;DisplayWallpaper;DisplayThemes;EnableFontSmoothing;EnableDesktopComposition;DisableFullWindowDrag;DisableMenuAnimations;DisableCursorShadow;DisableCursorBlinking;CacheBitmaps;RedirectDiskDrives;RedirectPorts;RedirectPrinters;RedirectClipboard;RedirectSmartCards;RedirectSound;RedirectKeys;PreExtApp;PostExtApp;MacAddress;UserField;ExtApp;Favorite;VNCCompression;VNCEncoding;VNCAuthMode;VNCProxyType;VNCProxyIP;VNCProxyPort;VNCProxyUsername;VNCProxyPassword;VNCColors;VNCSmartSizeMode;VNCViewOnly;RDGatewayUsageMethod;RDGatewayHostname;RDGatewayUseConnectionCredentials;RDGatewayUsername;RDGatewayPassword;RDGatewayDomain;RDGatewayExternalCredentialProvider;RDGatewayUserViaAPI;RedirectAudioCapture;RdpVersion;RDPStartProgram;RDPStartProgramWorkDir;UserViaAPI;EC2InstanceId;EC2Region;ExternalCredentialProvider;ExternalAddressProvider;InheritCacheBitmaps;InheritColors;InheritDescription;InheritDisplayThemes;InheritDisplayWallpaper;InheritEnableFontSmoothing;InheritEnableDesktopComposition;InheritDisableFullWindowDrag;InheritDisableMenuAnimations;InheritDisableCursorShadow;InheritDisableCursorBlinking;InheritDomain;InheritIcon;InheritPanel;InheritPassword;InheritPort;InheritProtocol;InheritSSHTunnelConnectionName;InheritOpeningCommand;InheritSSHOptions;InheritPuttySession;InheritRedirectDiskDrives;InheritRedirectKeys;InheritRedirectPorts;InheritRedirectPrinters;InheritRedirectClipboard;InheritRedirectSmartCards;InheritRedirectSound;InheritResolution;InheritAutomaticResize;InheritUseConsoleSession;InheritUseCredSsp;InheritUseRestrictedAdmin;InheritUseRCG;InheritUseVmId;InheritUseEnhancedMode;InheritVmId;InheritRenderingEngine;InheritUsername;InheritRDPAuthenticationLevel;InheritLoadBalanceInfo;InheritPreExtApp;InheritPostExtApp;InheritMacAddress;InheritUserField;InheritFavorite;InheritExtApp;InheritVNCCompression;InheritVNCEncoding;InheritVNCAuthMode;InheritVNCProxyType;InheritVNCProxyIP;InheritVNCProxyPort;InheritVNCProxyUsername;InheritVNCProxyPassword;InheritVNCColors;InheritVNCSmartSizeMode;InheritVNCViewOnly;InheritRDGatewayUsageMethod;InheritRDGatewayHostname;InheritRDGatewayUseConnectionCredentials;InheritRDGatewayUsername;InheritRDGatewayPassword;InheritRDGatewayDomain;InheritRDGatewayExternalCredentialProvider;InheritRDGatewayUserViaAPI;InheritRDPAlertIdleTimeout;InheritRDPMinutesToIdleTimeout;InheritSoundQuality;InheritUserViaAPI;InheritRedirectAudioCapture;InheritRdpVersion;InheritExternalCredentialProvider`r`n"
#old
$mRemoteNG_Old = "Name;Id;Parent;NodeType;Description;Icon;Panel;Username;Password;Domain;Hostname;Protocol;PuttySession;Port;ConnectToConsole;UseCredSsp;RenderingEngine;ICAEncryptionStrength;RDPAuthenticationLevel;LoadBalanceInfo;Colors;Resolution;AutomaticResize;DisplayWallpaper;DisplayThemes;EnableFontSmoothing;EnableDesktopComposition;CacheBitmaps;RedirectDiskDrives;RedirectPorts;RedirectPrinters;RedirectSmartCards;RedirectSound;RedirectKeys;PreExtApp;PostExtApp;MacAddress;UserField;ExtApp;VNCCompression;VNCEncoding;VNCAuthMode;VNCProxyType;VNCProxyIP;VNCProxyPort;VNCProxyUsername;VNCProxyPassword;VNCColors;VNCSmartSizeMode;VNCViewOnly;RDGatewayUsageMethod;RDGatewayHostname;RDGatewayUseConnectionCredentials;RDGatewayUsername;RDGatewayPassword;RDGatewayDomain;InheritCacheBitmaps;InheritColors;InheritDescription;InheritDisplayThemes;InheritDisplayWallpaper;InheritEnableFontSmoothing;InheritEnableDesktopComposition;InheritDomain;InheritIcon;InheritPanel;InheritPassword;InheritPort;InheritProtocol;InheritPuttySession;InheritRedirectDiskDrives;InheritRedirectKeys;InheritRedirectPorts;InheritRedirectPrinters;InheritRedirectSmartCards;InheritRedirectSound;InheritResolution;InheritAutomaticResize;InheritUseConsoleSession;InheritUseCredSsp;InheritRenderingEngine;InheritUsername;InheritICAEncryptionStrength;InheritRDPAuthenticationLevel;InheritLoadBalanceInfo;InheritPreExtApp;InheritPostExtApp;InheritMacAddress;InheritUserField;InheritExtApp;InheritVNCCompression;InheritVNCEncoding;InheritVNCAuthMode;InheritVNCProxyType;InheritVNCProxyIP;InheritVNCProxyPort;InheritVNCProxyUsername;InheritVNCProxyPassword;InheritVNCColors;InheritVNCSmartSizeMode;InheritVNCViewOnly;InheritRDGatewayUsageMethod;InheritRDGatewayHostname;InheritRDGatewayUseConnectionCredentials;InheritRDGatewayUsername;InheritRDGatewayPassword;InheritRDGatewayDomain;InheritRDPAlertIdleTimeout;InheritRDPMinutesToIdleTimeout;InheritSoundQuality`r`n"

$tree = @()
$SessionCount = 0
#foreach ($sections in $Groups.Keys) {
foreach ($sections in $groups| ForEach { $_.Name}){
    if($sections -match "bookmarks"){
        $keys = $ini[$sections]
        $Arborescence = $($ini[$sections]['SubRep'].ToString())
        Write-Host "Arborescence : $($Arborescence)"
        $Arborescences = $Arborescence.Split('\')

        for($i=0;$i -lt $Arborescences.Count; $i++){
            $parent = ""
            if ($i -gt 0 ){
                if ( ($tree.GetEnumerator() | Where-Object { $_.Path -Like  $Arborescences[$i-1] }).UUID -ne "" ){
                    $parent = ($tree.GetEnumerator() | Where-Object { $_.Path -Like  $Arborescences[$i-1] }).UUID
                }
            }
            if ( $Arborescences[$i] -ne ""){
                if ( ($tree.GetEnumerator() | Where-Object { $_.Path -Like  $Arborescences[$i] }).UUID -eq $null -Or 
                   ( ($tree.GetEnumerator() | Where-Object { $_.Path -Like  $Arborescences[$i] }).UUID -ne $null -And 
                     ($tree.GetEnumerator() | Where-Object { $_.Path -Like  $Arborescences[$i] }).Parent -ne $parent) ){
                    $UUID = New-UUID
                    $tree += New-Object -TypeName psobject -Property @{Path= $Arborescences[$i] ; UUID= $UUID ; Parent= $parent}
                    #$mRemoteNG = $mRemoteNG + "$($Arborescences[$i]);$($UUID);$($parent);Container;;mRemoteNG;General;;;;;RDP;Default Settings;3389;False;True;EdgeChromium;EncrBasic;NoAuth;;Colors16Bit;FitToWindow;True;False;False;False;False;False;False;False;False;False;DoNotPlay;False;;;;;;CompNone;EncHextile;AuthVNC;ProxyNone;;0;;;ColNormal;SmartSAspect;False;Never;;Yes;;;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;`r`n"
                    #new
                    $mRemoteNG_New = $mRemoteNG_New + "$($Arborescences[$i]);$($UUID);$($parent);Container;;mRemoteNG;General;;;;;3389;;RDP;;;;Default Settings;False;True;False;False;False;False;IE;NoAuth;;Colors16Bit;FitToWindow;True;False;False;False;False;False;False;False;False;False;False;False;False;False;False;DoNotPlay;False;;;;;;False;CompNone;EncHextile;AuthVNC;ProxyNone;;0;;;ColNormal;SmartSAspect;False;Never;;Yes;;;;None;;False;Rdc6;;;;;eu-central-1;None;None;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;`r`n"
                    #old
                    $mRemoteNG_Old = $mRemoteNG_Old + "$($Arborescences[$i]);$($UUID);$($parent);Container;;mRemoteNG;General;;;;;RDP;Default Settings;3389;False;True;IE;EncrBasic;NoAuth;;Colors16Bit;FitToWindow;True;False;False;False;False;False;False;False;False;False;DoNotPlay;False;;;;;;CompNone;EncHextile;AuthVNC;ProxyNone;;0;;;ColNormal;SmartSAspect;False;Never;;Yes;;;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;`r`n"
                    $parent = $UUID
                }
            }
        }

        #$tree += New-Object -TypeName psobject -Property @{User="Jimbo"; Password="1234"}

        Write-Host "  Icon : $($ini[$sections]['ImgNum'].ToString())"
        foreach( $key in $keys.Keys){
            $valeur = $keys[$key]

            if ($key -eq "SubRep"){
            }elseif ($key -eq "ImgNum"){
            }else{
                $type = $valeur.Split("#")[1]
                if($type -eq "84"){$type = "FILE"} # non gerer
                if($type -eq "88"){$type = "XDMPC"} # non gerer
                if($type -eq "91"){$type = "RDP"}
                if($type -eq "98"){$type = "TELNET"} # non gerer
                if($type -eq "100"){$type = "RSH"} # non gerer
                if($type -eq "109"){$type = "SSH2"}
                if($type -eq "128"){$type = "VNC"}
                if($type -eq "130"){$type = "FTP"} # non gerer
                if($type -eq "131"){$type = "SERIAL"} # non gerer
                if($type -eq "140"){$type = "SFTP"} # non gerer
                if($type -eq "145"){$type = "MOSH"} # non gerer
                if($type -eq "151"){$type = "WSL"} # non gerer
                if($type -eq "204"){$type = "BASH"} # non gerer
                if($type -eq "313"){$type = "HTTPS"}
                if($type -eq "343"){$type = "AWS-S3"} # non gerer

                $icon = $($icons[($valeur.Split("#")[2]).split("%")[0]])
                
                if ($icon -eq "RDP"){
                    $icon = "Remote Desktop"
                }elseif($icon -eq "SSH"){
                    $icon = "SSH"
                }elseif($icon -eq "Browser"){
                    $icon = "Web Server"
                }else{
                    $icon = "mRemoteNG"
                }

                $hote = (($valeur.Split("#")[2]).split("%")[1]) -replace ('__EQUAL__','=')
                if($hote -match '(http:+|https:+)' ){ #$hote.Substring(0,4) -eq "http"){
                    $hote -match '(http:+|https:+)' |Out-Null ; $type = ($Matches[1] -replace ':').ToUpper()
                }

                $port = ($valeur.Split("#")[2]).split("%")[2]
                if ($port -eq "-1"){
                    if($type -eq "RDP"){
                        $port = "3389"
                    }elseif($type -eq "SSH2"){
                        $port = "22"
                    }elseif($type -eq "HTTPS"){
                        $port = "443"
                    }elseif($type -eq "HTTP"){
                        $port = "80"
                    }elseif($type -eq "VNC"){
                        $port = "5900"
                    }
                }
                $account = ($valeur.Split("#")[2]).split("%")[3]

                $account = $account -replace ('\[','')
                $account = $account -replace ('\]','')
                if($Credentials.Value[$account] -ne $null){
                    $login = "$($Credentials.Value[$account].Split(':')[0])"
                    $password = "$($Credentials.Value[$account].Split(':')[-1])"
                }
                
                $domain = ""
                if ( $login -match ("\\")){
                    $domain = $login.Split('\')[0]
                    $login = $login.Split('\')[1]
                }
                if ( $login -match ("@")){
                    $domain = $login.Split('@')[1]
                    $login = $login.Split('@')[0]
                }

                #$resolution = ($valeur.Split("#")[2]).split("%")[10]
                if (($valeur.Split("#")[2]).split("%")[10] -ne $null){
                    $resolution = $($resolutions[($valeur.Split("#")[2]).split("%")[10]])
                }else{
                    $resolution = $($resolutions[0])
                }
                if (($valeur.Split("#")[2]).split("%")[22] -ne $null){
                    $couleur = $($couleurs[($valeur.Split("#")[2]).split("%")[22]])
                }else{
                    $couleur = $($couleurs[2])
                }

                Write-Host "Nom        : $key"
                Write-Host "  Icon       : $icon"
                Write-Host "  Type       : $type"
                Write-Host "  Hote       : $hote"
                Write-Host "  Port       : $port"
                Write-Host "  Compte     : $account"
                Write-Host "  Login      : $Login"
                Write-Host "  password   : $password"
                Write-Host "  Domaine    : $domain"
                Write-Host "  Resolution : $resolution"
                Write-Host "  Couleur    : $couleur"

                #$password = ""
                #$domain = ""
                $UUID = New-UUID
                #$mRemoteNG = $mRemoteNG + "$($key);$($($UUID));$($parent);Connection;;$($icon);General;$($login);$($password);;$($hote);$($type);Default Settings;$($port);False;True;IE;EncrBasic;NoAuth;;Colors16Bit;FitToWindow;True;False;False;False;False;False;False;False;False;False;DoNotPlay;False;;;;;;CompNone;EncHextile;AuthVNC;ProxyNone;;0;;;ColNormal;SmartSAspect;False;Never;;Yes;;;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;`r`n"
                
                #new
                $mRemoteNG_New = $mRemoteNG_New + "$($key);$($($UUID));$($parent);Connection;;$($icon);General;$($login);$($password);$($domain);$($hote);$($port);;$($type);;;;Default Settings;False;True;False;False;False;False;EdgeChromium;NoAuth;;$($couleur);$($resolution);True;False;False;False;False;False;False;False;False;False;False;False;False;False;False;DoNotPlay;False;;;;;;False;CompNone;EncHextile;AuthVNC;ProxyNone;;0;;;ColNormal;SmartSAspect;False;Never;;Yes;;;;None;;False;Rdc6;;;;;eu-central-1;None;None;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;`r`n"
                #old
                $mRemoteNG_Old = $mRemoteNG_Old + "$($key);$($($UUID));$($parent);Connection;;$($icon);General;$($login);$($password);$($domain);$($hote);$($type);Default Settings;$($port);False;True;IE;EncrBasic;NoAuth;;$($couleur);$($resolution);True;False;False;False;False;False;False;False;False;False;DoNotPlay;False;;;;;;CompNone;EncHextile;AuthVNC;ProxyNone;;0;;;ColNormal;SmartSAspect;False;Never;;Yes;;;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;`r`n"
                $SessionCount = $SessionCount + 1
                #Write-Host "Section : $key, Valeur : $valeur"
            }
        }
    }
}
Write-Host " Nombre de session : $SessionCount"
Set-Content -Path mRemote.csv -Value $mRemoteNG_New
Set-Content -Path mRemote-old.csv -Value $mRemoteNG_Old
#Write-Host (New-UUID)


# "Name;Id;Parent;NodeType;Description;Icon;Panel;Username;Password;Domain;Hostname;Protocol;PuttySession;Port;ConnectToConsole;UseCredSsp;RenderingEngine;ICAEncryptionStrength;RDPAuthenticationLevel;LoadBalanceInfo;Colors;Resolution;AutomaticResize;DisplayWallpaper;DisplayThemes;EnableFontSmoothing;EnableDesktopComposition;CacheBitmaps;RedirectDiskDrives;RedirectPorts;RedirectPrinters;RedirectSmartCards;RedirectSound;RedirectKeys;PreExtApp;PostExtApp;MacAddress;UserField;ExtApp;VNCCompression;VNCEncoding;VNCAuthMode;VNCProxyType;VNCProxyIP;VNCProxyPort;VNCProxyUsername;VNCProxyPassword;VNCColors;VNCSmartSizeMode;VNCViewOnly;RDGatewayUsageMethod;RDGatewayHostname;RDGatewayUseConnectionCredentials;RDGatewayUsername;RDGatewayPassword;RDGatewayDomain;InheritCacheBitmaps;InheritColors;InheritDescription;InheritDisplayThemes;InheritDisplayWallpaper;InheritEnableFontSmoothing;InheritEnableDesktopComposition;InheritDomain;InheritIcon;InheritPanel;InheritPassword;InheritPort;InheritProtocol;InheritPuttySession;InheritRedirectDiskDrives;InheritRedirectKeys;InheritRedirectPorts;InheritRedirectPrinters;InheritRedirectSmartCards;InheritRedirectSound;InheritResolution;InheritAutomaticResize;InheritUseConsoleSession;InheritUseCredSsp;InheritRenderingEngine;InheritUsername;InheritICAEncryptionStrength;InheritRDPAuthenticationLevel;InheritLoadBalanceInfo;InheritPreExtApp;InheritPostExtApp;InheritMacAddress;InheritUserField;InheritExtApp;InheritVNCCompression;InheritVNCEncoding;InheritVNCAuthMode;InheritVNCProxyType;InheritVNCProxyIP;InheritVNCProxyPort;InheritVNCProxyUsername;InheritVNCProxyPassword;InheritVNCColors;InheritVNCSmartSizeMode;InheritVNCViewOnly;InheritRDGatewayUsageMethod;InheritRDGatewayHostname;InheritRDGatewayUseConnectionCredentials;InheritRDGatewayUsername;InheritRDGatewayPassword;InheritRDGatewayDomain;InheritRDPAlertIdleTimeout;InheritRDPMinutesToIdleTimeout;InheritSoundQuality"
# "rdp1;df0f479c-c9fc-4466-bcba-b33c0bd07bd8;2d490989-49af-40e0-945e-b390a6a63717;Connection;;Remote Desktop;General;administrateur;P@ssw0rd;;192.168.0.41;RDP;Default Settings;666 ;False;True;IE;EncrBasic;NoAuth;;Colors16Bit;FitToWindow;True;False;False;False;False;False;False;False;False;False;DoNotPlay;False;;;;;;CompNone;EncHextile;AuthVNC;ProxyNone;;0;;;ColNormal;SmartSAspect;False;Never;;Yes;;;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;"

<#
Set-IniFile -ini $ini -filePath ".\config_copy.ini"

Write-Host "=first_section"
$ini["first_section"]
Write-Host "=second_section"
$ini["second_section"]
Write-Host "=second_section.second_section"
$ini["second_section"]["second_section"]
Write-Host "=third_section"
$ini["third_section"]
Write-Host "=third_section.phpversion"
$ini["third_section"]["phpversion"]

$ini = Parse-IniFile MobaXterm.ini
#>
