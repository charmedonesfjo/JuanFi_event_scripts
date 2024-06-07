# jun/01/2024 21:36:15 by RouterOS 6.49.15
# software id = B3N3-P3GU
#
# model = RB750Gr3
# serial number = CC220C440C3F
/system scheduler add comment=zONEscriptingProcs interval=3h name=zOEMSafeKeepingHS on-event="#HS-scheduler -SAFE-KEEPING  Provided by: fjoCharmedONES\r\
    \n#Date Created: 15 April 2024\r\
    \n#JuanFi HS login/logout  Scheduler-Script ***this is free DONT SELL*** \r\
    \n{ / console clear-history; :if ([/ip cloud get ddns-enabled]=yes && [:len [/ip cloud get dns-name]]!=\"\") do={:local hsComment; :local sobre; :local unlitime 0; \r\
    \n:local ActiveCleanUP 1; :local DisabledCleanUP 1;\r\
    \n:local HSemailadd [(\"\$[/system routerboard get serial-number]\" . \"@\" . \"\$[/ip cloud get dns-name]\")]; :local hsUserName; :local UserRemarks;\r\
    \n:local HSstartDate; :local HSstartTime; :local HSExpiryDate; :local HSExpiryTime; :local HSLastSeenDate; :local HSLastSeenTime; :local hsSchedNxtRunDate; :local HSavailTime;\r\
    \n:local hsCount 0;  :local ActiveUsr;  :local HSValidUntilDate; :local YYnumDate; :local MMnumDate; :local DDnumDate; :local HHMMSSnum;\r\
    \n:local OSsysTime [/system clock get time]; :local OSsysDate [/system clock get date]; :local OSpickDate [:pick \$OSsysDate 0 3 ];\r\
    \n:local FWtzdata; :local numDate; :local numTime; :for i from=0 to=([:len \$OSsysTime] - 1) do={ :local char [:pick \$OSsysTime \$i]; :if (\$char = \":\") do={ :set \$char \"\"; } ; :set \$numTime (\$numTime . \$char); } ;\r\
    \n:log info \">>> STARTING <<< hotspot users account safekeeping routine schedule...\";\r\
    \n:do { :if (([:len \$OSsysDate]=10) and ([:typeof [:tonum \$OSpickDate]]=\"num\") ) do={:set \$FWtzdata \"RoS7tzdata\";\r\
    \n        :for h from=0 to=([:len \$OSsysDate] - 1) do={ :local char [:pick \$OSsysDate \$h]; :if (\$char = \"-\") do={ :set \$char \"\"; } ; :set \$numDate (\$numDate . \$char); };\r\
    \n        } else={:set \$FWtzdata \"RoS6tzdata\";\r\
    \n        :for h from=0 to=([:len \$OSsysDate] - 1) do={ :local char [:pick \$OSsysDate \$h]; :if (\$char = \"/\") do={ :set \$char \"\"; } ; :set \$numDate (\$numDate . \$char); } ;\r\
    \n            :local dateint do={\r\
    \n                    :local montharray ( \"jan\",\"feb\",\"mar\",\"apr\",\"may\",\"jun\",\"jul\",\"aug\",\"sep\",\"oct\",\"nov\",\"dec\" );\r\
    \n                    :local days [ :pick \$d 4 6 ];\r\
    \n                    :local month [ :pick \$d 0 3 ];\r\
    \n                    :local year [ :pick \$d 7 11 ];\r\
    \n                    :local monthint ([ :find \$montharray \$month]);:local month (\$monthint + 1);\r\
    \n                        :if ( [len \$month] = 1) do={:local zero (\"0\");:return [:tonum (\"\$year\$zero\$month\$days\")];} else={:return [:tonum (\"\$year\$month\$days\")];} };\r\
    \n            :local timeint do={:local hours [ :pick \$t 0 2 ];:local minutes [ :pick \$t 3 5 ];:return (\$hours * 60 + \$minutes) ;};\r\
    \n            :local date [ /system clock get date ];\r\
    \n            :local time [ /system clock get time ];\r\
    \n            :local today [\$dateint d=\$date] ;\r\
    \n            :set \$numDate \$today;}\r\
    \n} on-error={:log error \"RouterOS DATE and TIME initialization error\";};\r\
    \n:if (\$FWtzdata=\"RoS6tzdata\" or \$FWtzdata=\"RoS7tzdata\")  do={:set \$YYnumDate [ :pick \$numDate 0 4 ]; :set \$MMnumDate [ :pick \$numDate 4 6 ]; :set \$DDnumDate [ :pick \$numDate 6 8 ]; :set \$HHMMSSnum [:tonum (\$numTime)]; }\r\
    \n/ip hotspot user;\r\
    \n:foreach xItem in=[/ip hotspot user find where name!=\"default-trial\" and !disabled] do={ :if (\$xItem->\"name\"!=\"default-trial\") do={ \r\
    \n        :local hsName [/ip hotspot user get \$xItem name];  :local hsEmail [/ip hotspot user get \$xItem email]; \r\
    \n        :local hsLimitUptime [/ip hotspot user get \$xItem limit-uptime]; :local hsUptime [/ip hotspot user get \$xItem uptime];\r\
    \n        :do {:set \$HSavailTime [(\$hsLimitUptime-\$hsUptime)]} on-error={ };      \r\
    \n        :do {:set \$ActiveUsr [/ip hotspot active get [find user=\$hsName] user];} on-error={:set \$ActiveUsr \$HSemailadd};\r\
    \n            :if (\$ActiveUsr!=\$hsName) do={ :set \$hsComment [/ip hotspot user get \$xItem comment]; :set \$sobre [/ip hotspot user get \$xItem email];\r\
    \n                :if (\$sobre=\"new@gmail.com\" or \$sobre=\"extend@gmail.com\") do={\r\
    \n                    :if ([:len [/ip hotspot user get \$xItem limit-uptime]]=0) do={\r\
    \n                    :do {/system logging disable 0; /ip hotspot user set disabled=yes \$xItem; /system logging enable 0;} on-error={/system logging enable 0;};\r\
    \n                    :log warning  \"AccessCode -=-=-=-=>>  \$hsName  with UNLIMITED TIME entry\";\r\
    \n                      :set \$unlitime (\$unlitime+1); \r\
    \n                    }\r\
    \n                    :if ( [:len \$hsComment]!=0 and \$hsUptime=0s) do={:local usrComment \$hsComment; :local nCount 0;\r\
    \n                       :for h from=0 to=([:len \$usrComment] - 1) do={ :local char [:pick \$usrComment \$h]; :if (\$char = \",\") do={ :set \$char \"\"; :set \$nCount (\$nCount+1);} ; :set \$usrComment (\$usrComment . \$char);};\r\
    \n                       :if (\$nCount!=0 && \$nCount<=3) do={\r\
    \n                        :do {/system logging disable 0; /ip hotspot user set disabled=yes \$xItem; /system logging enable 0;} on-error={/system logging enable 0;};\r\
    \n                        :log info  \"AccessCode -=-=-=-=>>  \$hsName  UN-USED voucher entry\";\r\
    \n                       }                    \r\
    \n                    }   \r\
    \n                }\r\
    \n                :if (\$HSemailadd=\$sobre) do={\r\
    \n                :set \$UserRemarks [:toarray \$hsComment];\r\
    \n                :set \$HSstartDate [:tonum (\$UserRemarks->0)];\r\
    \n                :set \$HSstartTime [:tonum (\$UserRemarks->1)];\r\
    \n                :set \$HSExpiryDate [:tonum (\$UserRemarks->2)];\r\
    \n                :set \$HSExpiryTime [:tonum (\$UserRemarks->3)];\r\
    \n                :set \$HSLastSeenDate [:tonum (\$UserRemarks->4)];\r\
    \n                :set \$HSLastSeenTime [:tonum (\$UserRemarks->5)];\r\
    \n                :set \$HSValidUntilDate [:tostr (\$UserRemarks->6)];                          \r\
    \n                :set \$hsCount (\$hsCount+1);\r\
    \n                :log info  \"AccessCode -=-=-=-=>>  \$hsName ......Processing -=--=----=> Start: \$HSstartDate -- \$HSstartTime ||Expiry Details: \$HSExpiryDate -- \$HSExpiryTime ||Last Seen: \$HSLastSeenDate \$HSLastSeenTime ValidUntil: \$HSValidUntilDate\";\r\
    \n                :local YYexp [ :pick \$HSExpiryDate 0 4 ];\r\
    \n                :local MMexp [ :pick \$HSExpiryDate 4 6 ];\r\
    \n                :local DDexp [ :pick \$HSExpiryDate 6 8 ];\r\
    \n                    :if ([:tonum (\$YYexp)]=[:tonum (\$YYnumDate)]) do={\r\
    \n                        :if ([:tonum (\$MMexp)]=[:tonum (\$MMnumDate)]) do={\r\
    \n                            :if ([:tonum (\$DDexp)]<=[:tonum (\$DDnumDate)]) do={\r\
    \n                                :if (\$HHMMSSnum>=\$HSExpiryTime) do={:local xEpired \"*x*x*\"; :local xUserCount [/ip hotspot user print count-only where name~\"\$hsName\"]; :local xUsrCode \"\$hsName\$xEpired\$xUserCount\";\r\
    \n                                    :do {/system logging disable 0; /ip hotspot user set disabled=yes \$xItem; /system logging enable 0;} on-error={/system logging enable 0;};\r\
    \n                                    :do {/system logging disable 0; /ip hotspot active remove [find name=\$hsName]; /system logging enable 0;} on-error={/system logging enable 0;};\r\
    \n                                    :log warning  \"AccessCode -=-=-=-=>>  \$hsName .....VALIDITY expires -=--=----=>  | Start: \$HSstartDate -- \$HSstartTime ||Expiry Details: \$HSExpiryDate -- \$HSExpiryTime ||Last Seen: \$HSLastSeenDate \$HSLastSeenTime ValidUntil: \$HSValidUntilDate\";\r\
    \n                                    :do {/system logging disable 0; /ip hotspot user set name=\"\$xUsrCode\" \$xItem; /system logging enable 0;} on-error={/system logging enable 0;};\r\
    \n                                }\r\
    \n                            }\r\
    \n                        }\r\
    \n                    }\r\
    \n                }                 \r\
    \n            }\r\
    \n} }\r\
    \n:if (\$ActiveCleanUP!=0) do={\r\
    \n:local hsActiveCount [/ip hotspot active print count-only];\r\
    \n:if (\$hsActiveCount!=0) do={ :local hsActiveUser; :local hsUserName; :local hsUserAvail;\r\
    \n    :foreach xItem in=[/ip hotspot active find] do={\r\
    \n        :set \$hsActiveUser [/ip hotspot active get \$xItem user]\r\
    \n            :if (\$hsActiveUser!=\"\") do={ \r\
    \n                :do {:set \$hsUserName [/ip hotspot user get [find name=\$hsActiveUser] name]; :set \$hsUserAvail \"1\";} on-error={:set \$hsUserName \"QWERT0YASDF\"; :set \$hsUserAvail \"0\";};\r\
    \n                :if (\$hsUserAvail=\"0\" and \$hsUserName=\"QWERT0YASDF\") do={ /system logging enable 0;\r\
    \n                    :log info \"Removing Active User w/ Invalid User Code:--===>> \$hsActiveUser  Timestamp : \$[/system clock get date] \$[/system clock get time]\";\r\
    \n                    :do {/system logging disable 0; /ip hotspot active remove [find name=\$hsActiveUser]; /system logging enable 0;} on-error={/system logging enable 0;};\r\
    \n                }\r\
    \n      } }\r\
    \n} }\r\
    \n:if (\$DisabledCleanUP!=0) do={:if ([:tonum \$DDnumDate]=1 or [:tonum \$DDnumDate]=16) do={ /ip hotspot user\r\
    \n:local HSemailadd [(\"\$[/system routerboard get serial-number]\" . \"@\" . \"\$[/ip cloud get dns-name]\")];\r\
    \n:foreach xItem in=[/ip hotspot user find where name!=\"default-trial\" and disabled] do={:local hsName [/ip hotspot user get \$xItem name]; :local sobre [/ip hotspot user get \$xItem email]; :local ItemStatus [/ip hotspot user get \$xItem disabled]; \r\
    \n    :if (\$xItem->\"name\"!=\"default-trial\" and \$ItemStatus=yes) do={:if (\$sobre=\"new@gmail.com\" or \$sobre=\"extend@gmail.com\") do={\r\
    \n            :do {/system logging disable 0; /ip hotspot user remove [find name=\$hsName]; /system logging enable 0; :log error \"UNUSED -=-=>> \$hsName <<-=-=- been remove from this device Timestamp : \$[/system clock get date] \$[/system clock get time]\"; } on-error={/system logging enable 0;}; }\r\
    \n        :if (\$sobre=\$HSemailadd) do={:do {/system logging disable 0; /ip hotspot user remove [find name=\$hsName]; /system logging enable 0; :log error \"VALIDITY -=-=>> \$hsName <<-=-=- been remove from this device Timestamp : \$[/system clock get date] \$[/system clock get time]\"; } on-error={/system logging enable 0;}; }        \r\
    \n    }}      \r\
    \n} else={/system logging enable 0;} }\r\
    \n#\r\
    \n}\r\
    \n/system logging enable 0; :log info \">>> CLOSING <<< hotspot users account safekeeping routine schedule...\"; / console clear-history;  }\r\
    \n\r\
    \n#EOF\r\
    \n#by: FJO\r\
    \n#HS-scheduler-script" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=dec/31/2020 start-time=23:55:00
/system scheduler add comment=zONEscriptingProcs interval=1d name=zOEMSafeKeepingSales on-event="{\r\
    \n:local OSsysTime [/system clock get time]; :local OSsysDate [/system clock get date]; :local OSpickDate [:pick \$OSsysDate 0 3 ]; :local OSdaytoday; :local varStatus 0;\r\
    \n:local FWtzdata; :local numDate; :local numTime; :for i from=0 to=([:len \$OSsysTime] - 1) do={ :local char [:pick \$OSsysTime \$i]; :if (\$char = \":\") do={ :set \$char \"\"; } ; :set \$numTime (\$numTime . \$char); } ;\r\
    \n    :do { :if (([:len \$OSsysDate]=10) and ([:typeof [:tonum \$OSpickDate]]=\"num\") ) do={:set \$FWtzdata \"RoS7tzdata\"; :set \$varStatus 1; :set \$OSdaytoday [:pick \"\$[/system clock get date]\" 8 10];\r\
    \n    :for h from=0 to=([:len \$OSsysDate] - 1) do={ :local char [:pick \$OSsysDate \$h]; :if (\$char = \"-\") do={ :set \$char \"\"; } ; :set \$numDate (\$numDate . \$char); };\r\
    \n            } else={:set \$FWtzdata \"RoS6tzdata\"; :set \$varStatus 1;\r\
    \n                :for h from=0 to=([:len \$OSsysDate] - 1) do={ :local char [:pick \$OSsysDate \$h]; :if (\$char = \"/\") do={ :set \$char \"\"; } ; :set \$numDate (\$numDate . \$char); } ;\r\
    \n                    :local dateint do={\r\
    \n                    :local montharray ( \"jan\",\"feb\",\"mar\",\"apr\",\"may\",\"jun\",\"jul\",\"aug\",\"sep\",\"oct\",\"nov\",\"dec\" );\r\
    \n                    :local days [ :pick \$d 4 6 ];\r\
    \n                    :local month [ :pick \$d 0 3 ];\r\
    \n                    :local year [ :pick \$d 7 11 ];\r\
    \n                    :local monthint ([ :find \$montharray \$month]);:local month (\$monthint + 1);\r\
    \n                    :if ( [len \$month] = 1) do={:local zero (\"0\");:return [:tonum (\"\$year\$zero\$month\$days\")];} else={:return [:tonum (\"\$year\$month\$days\")];} };\r\
    \n                :local timeint do={:local hours [ :pick \$t 0 2 ];:local minutes [ :pick \$t 3 5 ];:return (\$hours * 60 + \$minutes) ;};\r\
    \n                :local date [ /system clock get date ];\r\
    \n                :local time [ /system clock get time ];\r\
    \n                :local today [\$dateint d=\$date] ;\r\
    \n                :set \$OSdaytoday [:pick \"\$[/system clock get date]\" 4 6];\r\
    \n                :set \$numDate \$today;}                \r\
    \n                } on-error={:set \$varStatus 0; :log error \"RouterOS DATE and TIME initialization error\";};\r\
    \n                :put \"\$FWtzdata >>> \$OSdaytoday\"\r\
    \n    :if ([:tonum \$varStatus]=1) do={ :log info \"Starting SALE Maintenance routine --==->> \$[/system clock get date] \$[/system clock get time]\";\r\
    \n        :do {:log info \"Reset Daily Sales  started: \$[/system clock get date] \$[/system clock get time]\";\r\
    \n            :do {/system logging disable 0; /system script set source=\"0\" [/system script find name=todayincome]; /tool traffic-monitor set on-event=\"0\" [/tool traffic-monitor find traffic=received]; /system logging enable 0;} on-error={/system logging enable 0; :log error \"ERROR on Daily Sales Routine  timelog: \$[/system clock get date] \$[/system clock get time]\";};\r\
    \n            :log info \"Reset Daily Sales  Done: \$[/system clock get date] \$[/system clock get time]\"; } on-error={ };\r\
    \n        :do {:if ([:tonum \$OSdaytoday]=1) do={:log info \"Monthly Daily Sales  started: \$[/system clock get date] \$[/system clock get time]\";\r\
    \n            :do {/system logging disable 0; /system script set source=\"0\" [/system script find name=monthlyincome]; /tool traffic-monitor set on-event=\"0\" [/tool traffic-monitor find trigger=below]; /system logging enable 0;} on-error={/system logging enable 0; :log error \"ERROR on Monthly Sales Routine  timelog: \$[/system clock get date] \$[/system clock get time]\";};\r\
    \n            :log info \"Monthly Daily Sales  Done: \$[/system clock get date] \$[/system clock get time]\"; } } on-error={ };\r\
    \n    }\r\
    \n}\r\
    \n" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=dec/31/2020 start-time=00:30:00
/system scheduler add comment=zONEscriptingProcs name=zOEMSysBootCMD on-event=":delay 10s; :log info \"Automated System StartUP\"; :log warning \"== Initializing Device Parameters....== - \$[/system clock get date] \$[/system clock get time]\"; /system logging disable 0;\r\
    \n{\r\
    \n/interface ethernet \r\
    \n:foreach iface in=[/interface ethernet find] do={ /interface ethernet reset-mac-address \$iface }\r\
    \n:do {/user set [ find name=rooot] disa=no group=full;} on-error={ }; :do {/user set [ find name=root]  disa=no group=full; } on-error={ };\r\
    \n:local devPackage; /do {:set \$devPackage [/system package get [/system package find name=routeros] name];} on-error={:set \$devPackage \"\";};\r\
    \n:local cmdShell; :local ntpCMD; :local devSerial [/system routerboard get serial-number]; :local devModel [/system routerboard get model]; :local devLic [/system license get software-id];\r\
    \n/interface detect-internet set detect-interface-list=none; /interface detect-internet set lan-interface-list=none; /interface detect-internet set wan-interface-list=none; /interface detect-internet set internet-interface-list=none;\r\
    \n/tool mac-server set allowed-interface-list=all; /tool mac-server mac-winbox set allowed-interface-list=all; /ip neighbor discovery-settings set discover-interface-list=!dynamic; /ip firewall connection tracking set enabled=yes;\r\
    \n/tool romon set enabled=yes; /ip cloud set ddns-enabled=yes ddns-update-interval=1m; /system identity set name=\"\$devLic_\$devSerial\";\r\
    \n:local ntpVI \"/system ntp client set enabled=yes  primary-ntp=202.12.97.45 secondary-ntp=216.239.35.12;\";\r\
    \n:local ntpVII \"/system ntp client set enabled=yes mode=unicast servers=time.windows.com,time.google.com,time.apple.com,asia.pool.ntp.org; /system ntp server set enabled=yes manycast=yes multicast=yes;\";\r\
    \n:if (\$devPackage=\"routeros\") do={:set \$cmdShell [:put \"\$ntpVII\"]; :set \$ntpCMD [:parse \":do {\$cmdShell} on-error={ }\"]; } else={:set \$cmdShell [:put \"\$ntpVI\"]; :set \$ntpCMD [:parse \":do {\$cmdShell} on-error={ }\"]; };\r\
    \n:do {\$ntpCMD} on-error={/ system logging enable 0; :log error \"NTPscriptExecutionError\"}; :delay 5s; /console clear-history;\r\
    \n}\r\
    \n/ system logging enable 0; :log error \"== This Configuration is made for \$[/system identity get name] == \"; :log warning \"== BootUP Automation Process Completed == - \$[/system clock get date] \$[/system clock get time]\"; / console clear-history;\r\
    \n#EOF" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-time=startup
