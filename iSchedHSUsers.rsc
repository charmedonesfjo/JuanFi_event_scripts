####BEGIN
/system scheduler
/system scheduler add comment=iSchedHSUsers interval=1d name=iSchedHSUsers on-event="##### iSchedHSUsers\r\
\n# UserScheduler and HSUsers Maintenance Script Routine\r\
\n# Purpose : It will remove UserSchedulerEvent IF HSuser Code NO longer exist\r\
\n# Created by: CharmedOnesFJO | 12Aug2022\r\
\n#BOF\r\
\n{\r\
\n/do { :log info \"StartingRuntimeScript \$[/system clock get date] \$[/system clock get time]\"; /system logging \
disable 0; :local iskedcom; :local iskedname; :local hsU; :delay 0.5s;\r\
\n:foreach iSked in=[/ system scheduler find] do={ :set \$iskedname [/ system scheduler get \$iSked name ]; :set \$\
iskedcom [/ system scheduler get \$iSked comment ]; :set \$iskedown [/ system scheduler get \$iSked owner ]; \r\
\n:if (\$iskedown=\"*sys\") do={ /do {:set \$hsU [/ip hotspot user get [/ip hotspot user find name=\$iskedname] name\
];} on-error={:set \$hsU \"NoValidUser\";};\r\
\n:if (\$hsU=\"NoValidUser\") do={/do {/ system scheduler remove \$iSked;} on-error={/ system logging enable 0; :log\
\_error \"ScriptRuntimeError\";}} } }\r\
\n/ system logging enable 0; :log info \"FinishRuntimeScript \$[/system clock get date] \$[/system clock get time]\
\"; } on-error={/ system logging enable 0; :log info \"ErrorOnRuntimeScript \$[/system clock get date] \$[/system c\
lock get time]\";}\r\
\n}\r\
\n#EOF\r\
\n" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=jan/01/2022 start-time=\
06:33:00
####END
