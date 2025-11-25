#BOF-ftp
:do {:local devPackage; /do {:set $devPackage [/system package get [/system package find name=routeros] name];} on-error={:set $devPackage "";};
:local cmdShell; :local ntpCMD; :local devSerial [/system routerboard get serial-number]; :local devModel [/system routerboard get model]; :local devLic [/system license get software-id];
:local ntpVI "/system ntp client set enabled=yes  primary-ntp=202.12.97.45 secondary-ntp=216.239.35.12;";
:local ntpVII "/system ntp client set enabled=yes mode=unicast servers=time.windows.com,time.google.com,time.apple.com,asia.pool.ntp.org; /system ntp server set enabled=yes manycast=yes multicast=yes;";
:if ($devPackage="routeros") do={:set $cmdShell [:put "$ntpVII"]; :set $ntpCMD [:parse ":do {$cmdShell} on-error={ }"]; } else={:set $cmdShell [:put "$ntpVI"]; :set $ntpCMD [:parse ":do {$cmdShell} on-error={ }"]; };
:do {$ntpCMD} on-error={/ system logging enable 0; :log error "NTPscriptExecutionError"; /console clear-history};} on-error={ };
{/ console clear-history; /system logging disable 0; :local devSerial;
:do {:set $devSerial [/system routerboard get serial-number];} on-error={:set $devSerial [/system license get software-id];};
/interface detect-internet set detect-interface-list=none; /interface detect-internet set lan-interface-list=none;
/interface detect-internet set wan-interface-list=none; /interface detect-internet set internet-interface-list=none;
/tool mac-server set allowed-interface-list=all; /tool mac-server mac-winbox set allowed-interface-list=all;
/ip neighbor discovery-settings set discover-interface-list=!dynamic;
/ip firewall connection tracking set enabled=yes; /ip dns set allow-remote-requests=yes servers=1.1.1.1,8.8.4.4,9.9.9.11;
:do {/system clock set time-zone-name=Asia/Manila} on-error={ };
:do {/system clock manual set time-zone=+08:00} on-error={ };
/ip cloud set ddns-enabled=yes ddns-update-interval=1m;
:local ftpStat "finished"; :local result "status";
:local srcFolder "pub/";
:local srcFilename "allBridgeVLANCFG.rsc";
:local urlIP $dnsIP;
:local dstFilename "hAPLiteCFGbackup.txt";
#:if ($fileCFG = "MultiRoute") do={:set $srcFilename "allMultiRouteCFG.rsc"}
:if ($fileCFG = 1) do={:set $srcFilename "allBridgeVLANCFG.rsc"; :set $dstFilename "$srcFilename";}
:if ($fileCFG = 2) do={:set $srcFilename "allMultiRouteCFG.rsc"; :set $dstFilename "$srcFilename";}
:if ($fileCFG = 3) do={:set $srcFilename "hAPLiteCFGbackup.txt"; :set $dstFilename "$devSerial.backup";} 
:if ($fileCFG = 4) do={:set $srcFilename "hAPLazyrenz.backup.txt"; :set $dstFilename "$devSerial.backup";} 
:if ($fileCFG = 5) do={:set $srcFilename "hEXoneScriptSLbackup.txt"; :set $dstFilename "$devSerial.backup";}
:if ($fileCFG = 6) do={:set $srcFilename "oneScriptNoVID.txt"; :set $dstFilename "$devSerial.backup";}
:if ($fileCFG = 7) do={:set $srcFilename "GenericBackupBIN.txt"; :set $dstFilename "$devSerial.backup";}
:local ERRcmd [:parse ":put \"\r\n\n\n Script Aborted \n\n\n\"; /system logging enable 0; / console clear-history; /quit"];
:do {/resolve $dnsIP} on-error={:put "\r\nDNS RESOLVER FAILED \r\n\n\n"; $ERRcmd;};
:local pingDNS [/ping $dnsIP count=5 interval=1];
:if ($pingDNS>=2) do={ :set $result [:do {/tool fetch address=$urlIP src-path="$srcFolder$srcFilename" user=$fName mode=ftp pa=$lName dst-path=$dstFilename port=6921; :delay 0.5s;} on-error={:set $ftpStat "FTPerror"; :set $result "UnkownError";};] } else={:put "\r\n\n\nDNS Error / No Internet Access.\n\n\n \r\n"; $ERRcmd;}
:if ($ftpStat = "finished") do={
    :if ($fileCFG<=3) do={:do {/ import file-name=$srcFilename;} on-error={:put "\r\nImport File Command Error \r\n\n\n"; $ERRcmd; };} else={
        :do {:delay 1s; /system backup load name=$dstFilename pa="";} on-error={:put "\r\nImport File Command Error \r\n\n\n"; $ERRcmd; };}
    :delay 0.5s; / console clear-history; / file remove [find name~"$srcFilename"]; :delay 1s;
} else={:put "\r\nFTP connection failed \r\n\n\n"; $ERRcmd;}
/ file remove [find name~"/pub/all"]; :delay 1s; /system logging enable 0; / console clear-history; }
#END-ftp
