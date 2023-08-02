
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
                if($type -eq "91"){$type = "RDP"}
                if($type -eq "109"){$type = "SSH2"}
                if($type -eq "313"){$type = "HTTPS"}

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

                Write-Host "    $key"
                Write-Host "      $icon"
                Write-Host "      $type"
                Write-Host "      $hote"
                Write-Host "      $port"
                Write-Host "      $account"
                Write-Host "      $Login"
                Write-Host "      $password"
                
                #$password = ""
                #$domain = ""
                $UUID = New-UUID
                #$mRemoteNG = $mRemoteNG + "$($key);$($($UUID));$($parent);Connection;;$($icon);General;$($login);$($password);;$($hote);$($type);Default Settings;$($port);False;True;IE;EncrBasic;NoAuth;;Colors16Bit;FitToWindow;True;False;False;False;False;False;False;False;False;False;DoNotPlay;False;;;;;;CompNone;EncHextile;AuthVNC;ProxyNone;;0;;;ColNormal;SmartSAspect;False;Never;;Yes;;;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;`r`n"
                
                #new
                $mRemoteNG_New = $mRemoteNG_New + "$($key);$($($UUID));$($parent);Connection;;$($icon);General;$($login);$($password);$($domain);$($hote);$($port);;$($type);;;;Default Settings;False;True;False;False;False;False;EdgeChromium;NoAuth;;Colors16Bit;FitToWindow;True;False;False;False;False;False;False;False;False;False;False;False;False;False;False;DoNotPlay;False;;;;;;False;CompNone;EncHextile;AuthVNC;ProxyNone;;0;;;ColNormal;SmartSAspect;False;Never;;Yes;;;;None;;False;Rdc6;;;;;eu-central-1;None;None;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;`r`n"
                #old
                $mRemoteNG_Old = $mRemoteNG_Old + "$($key);$($($UUID));$($parent);Connection;;$($icon);General;$($login);$($password);$($domain);$($hote);$($type);Default Settings;$($port);False;True;IE;EncrBasic;NoAuth;;Colors16Bit;FitToWindow;True;False;False;False;False;False;False;False;False;False;DoNotPlay;False;;;;;;CompNone;EncHextile;AuthVNC;ProxyNone;;0;;;ColNormal;SmartSAspect;False;Never;;Yes;;;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;`r`n"
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
