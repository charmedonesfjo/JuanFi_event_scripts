########################################################################
# Created by: fjoCharmedOnes [use at your own risk]
# Description : Automated UPTIME Fix Using AutoRestore Backup v6.48.6
# Note : Dont mixed this script to other UPTIME FIX SCRIPTS.
# How to use : COPY PASTE 
########################################################################
#COPY-START
{ { /system scheduler add interval=3m30s name=0backUP on-event="#PURPOSE : MT Daily backup [can be used on UPTIME ISSUE during Power Interruption]\r\
    \n#DATE : 18 Oct 2022\r\
    \n#Created By: fjoCharmedOnes [use at your own risk]\r\
    \n{\r\
    \n:local mtSN [/system routerboard get serial-number]; :local mtID; \r\
    \n:do {:set \$mtID [/system license get software-id];} on-error={:set \$mtID \"NoSoftID\";}; :log info \"*************** -- System Backup Started \$[/system clock get date] \$[/system clock get time] -- ****************\";\r\
    \n:do {:local FileName \"\$mtSN\$mtID\"; :delay 0.5s; /system backup save pa=\"\$mtID\" name=\"\$FileName\"; :delay 0.3s;} on-error={:log error \"BackupError...timelog: \$[/system clock get date] \$[/system clock get time]\" };\r\
    \n:log info \"*************** -- System Backup succesfully DONE... \$[/system clock get date] \$[/system clock get time] -- ****************\"; / console clear-history;\r\
    \n}\r\
    \n#EOF" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=jan/01/2023 start-time=00:00:00 }
{ /system scheduler add name=0bootUP on-event="#PURPOSE : RESTORE BACKUP AFTER POWER RESTORED.\r\
    \n#        : This script must NOT used w/ other Fix-Uptime Scripts\r\
    \n#        : Start-UP boot only to detect from power failure.\r\
    \n#Created By: fjoCharmedOnes [use at your own risk]\r\
    \n{\r\
    \n:delay 10s; :log info \"AutomatedSystemStartUP\";\r\
    \n:local AutoRestore \"YES\";\r\
    \n:local mtSN [/system routerboard get serial-number]; :local mtID;\r\
    \n:local FileExt \".backup\"; :local FileName \"\$mtSN\$mtID\$FileExt\"; :local BootMSG; :local findMSG;\r\
    \n:do {:set \$mtID [/system license get software-id];} on-error={:set \$mtID \"NoSoftID\";};  \r\
    \n:if (\"\$[/system routerboard get model]\"=\"RB941-2nD\") do={:set \$BootMSG \"router was rebooted without proper shutdown\";} else={:set \$BootMSG \"router rebooted without proper shutdown\"; }\r\
    \n:do {:set \$findMSG [/log get [/log find where message ~\"\$BootMSG\"] message];} on-error={:set \$findMSG \"\";};\r\
    \n:if ([:len \$findMSG] != 0) do={:do {:delay 0.5s; :if (\$AutoRestore=\"YES\") do={:set \$FileName \"\$mtSN\$mtID\$FileExt\"; :log error \"==POWER INTERRUPTION DETECTED PROCEED TO RESTORE MODE\"; :delay 1s; /system backup load pa=\"\$mtID\" name=\"\$FileName\";}; :delay 0.3s;} on-error={:log error \"BackupError.....\" }; }\r\
    \n:log warning \"== BootUP Automation Process Completed == - \$[/system clock get date] \$[/system clock get time]\"; / console clear-history;\r\
    \n}\r\
    \n#EOF" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-time=startup } }
#COPY-END