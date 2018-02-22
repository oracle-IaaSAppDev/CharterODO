echo off
setLocal enableDELAYedexpansion

REM Copyright (c) 2013, 2015, Oracle and/or its affiliates. 
REM All rights reserved.
REM
REM    NAME
REM     AgentInstall.bat
REM
REM    DESCRIPTION
REM     Agent Installer for OMC Agent 
REM
REM
REM

setlocal
set scriptName=AgentInstall
set sleepInterval=10
set dateTimeStamp=
set emSaaSPropertiesFile=emaas.properties
set invalidAgentType=true

REM Supported Args
set AGENT_BASE_DIR=AGENT_BASE_DIR
set AGENT_TYPE=AGENT_TYPE
set AGENT_PORT=AGENT_PORT
set AGENT_REGISTRATION_KEY=AGENT_REGISTRATION_KEY
set GATEWAY_HOST=GATEWAY_HOST
set GATEWAY_PORT=GATEWAY_PORT
set ADDITIONAL_GATEWAYS=ADDITIONAL_GATEWAYS
set EM_AGENT_NAME=EM_AGENT_NAME
set STAGE_LOCATION=STAGE_LOCATION
set DATA_COLLECTOR_USERNAME=DATA_COLLECTOR_USERNAME
set DATA_COLLECTOR_USER_PASSWORD=DATA_COLLECTOR_USER_PASSWORD
set HARVESTER_USERNAME=HARVESTER_USERNAME
set HARVESTER_USER_PASSWORD=HARVESTER_USER_PASSWORD
set OMR_USERNAME=OMR_USERNAME
set OMR_USER_PASSWORD=OMR_USER_PASSWORD
set OMR_HOSTNAME=OMR_HOSTNAME
set OMR_PORT=OMR_PORT
set OMR_SID=OMR_SID
set OMR_SERVICE_NAME=OMR_SERVICE_NAME
set OMR_CONNECT_STRING=OMR_CONNECT_STRING
set OMR_HOST_USERNAME=OMR_HOST_USERNAME
set OMR_HOST_USER_PASSWORD=OMR_HOST_USER_PASSWORD
set OMR_HOST_USER_SSH_KEY=OMR_HOST_USER_SSH_KEY
set OMR_STAGE_DIR=OMR_STAGE_DIR
set NAMESPACE=NAMESPACE
set OMR_USER_ROLE=OMR_USER_ROLE
set UNZIP_PATH=UNZIP_PATH
set UNZIP_ARGS=UNZIP_ARGS
set CURL_PATH=CURL_PATH
set CURL_ARGS=CURL_ARGS
set AGENT_INSTANCE_HOME=AGENT_INSTANCE_HOME
set EM_AGENT_HOME=EM_AGENT_HOME
set AGENT_PROPERTIES=AGENT_PROPERTIES
set ORACLE_HOSTNAME_PARAM=ORACLE_HOSTNAME
set DOWNLOAD_FROM_EDGE=-download_from_edge
set DOWNLOAD_ONLY=-download_only
set IGNORE_DATA_COLLECTOR_PREREQS=-ignoreDataCollectorPrereqs
set IGNORE_HARVESTER_PREREQS=-ignoreHarvesterPrereqs
set IGNORE_PREREQS=-ignorePrereqs
set STAGED=-staged

set HELP=-help
set LAMA=lama
set GATEWAY=gateway
set HARVESTER=harvester
set APM=apm
set APM_DOT_NET=apm_dotnet_agent
set APM_NODE_JS=apm_nodejs_agent
set APM_RUBY=apm_ruby_agent
set APM_PHP=apm_php_agent
set APM_IOS=apm_ios_agent
set APM_ANDROID=apm_android_agent
set apmCert=emcs.cer
set apmGatewayCertName=trustCertGateway.cer
set apmAuthToken=cwallet.sso
set unzipPath=unzip
set unzipArgs=
set unzipDefaultArgs=-o
set curlPath=curl
set curlArgs=
set arg=
set errorMessage=
set errorFlag=false
set sysAdminDir=\sysman\admin
set stageCertLoc=stage\sysman\config\server
set gatewayCert=!stageCertLoc!\importCert
set gatewayKey=!stageCertLoc!\importCertPrivateKey
set stageTrustedCerts=!stageCertLoc!\trustedcerts
set trustCertEdge=!stageTrustedCerts!\trustCertEdge
set trustCertGateway=!stageTrustedCerts!\trustCertGateway
set core_version=
set command=
set stdInput0=
set stdInput=
set buildId=
set recommendation=
set gatewayHeader=-H X-Gateway-MetaProtocolVersion:REVISION_1
set curlDefaultArgs=-s --insecure -w %%{http_code} --retry 3 --retry-delay 5 --retry-max-time 30 !gatewayHeader!

REM Template Variables.
set cksum=@CKSUM@
set alcEndPoint=https://rogueone.itom.management.us2.oraclecloud.com/static/agentlifecycle
set apmCollectorRoot=https://rogueone.itom2.management.us2.oraclecloud.com
set ohEndPoint=https://rogueone.itom.management.us2.oraclecloud.com/registry
REM The OHS end point - https://host:port/
set UploadRoot=https://rogueone.itom.management.us2.oraclecloud.com/
set tenantId=rogueone
set serviceUrl=!ohEndPoint!

REM install inputs
set agentBaseDir=
set agentType=
set agentPort=-1
set agentRegistrationKey=
set gatewayHost=
set gatewayPort=
set gatewayParam=
set gatewayUrl=
set emAgentName=greenfield:agent
set agentTypeInternal=
set stageLocation=

set dataCollectorUserName=
set dataCollectorUserPassword=
set omrUserName=
set omrUserPassword=
set omrHostName=
set omrPort=
set omrSid=
set omrServiceName=
set omrConnectString=
set omrHostUserName=
set omrHostUserPassword=
set omrHostUserSshKey=
set omrStageDir=
set nameSpace=
set omrUserRole=
set errorMessage=
set stdInput=
set additionalGateways=
set fileToRedirect=
set downloadOnly=false
set downloadFromEdge=false
set ignoreDataCollectorPrereqs=false
set apmType=false
set isStaged=false
set platformId=233
set securityArtifact=securitytoken
set installMode=
set agentInst=
set emAgentHostName=
set agentPropertiesFile=
set oracleHostName=
set emAgentHome=
set gatewayInputProvided=false
set ignorePrereqs=false
set scriptLocation=%0
set scriptDir=%~dp0
set exitOnFailure=true

REM derived values
set gatewayRoot=
set uploadRoots=
set gatewayUrls=

REM properties file parameters

:setArgs
  if "%1"=="" goto doneSetArgs
  set validVar=false

  set VAR=%1
  set VAL=%2

  if "!VAR!" == "%EM_AGENT_HOME%" (
    set emAgentHome=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%AGENT_PROPERTIES%" (
    set agentPropertiesFile=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%ORACLE_HOSTNAME_PARAM%" (
    set oracleHostName=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%AGENT_INSTANCE_HOME%" (
    set agentInst=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%STAGED%" (
    set isStaged=true
    set validVar=true
  )

  if "!VAR!" == "%IGNORE_PREREQS%" (
    set ignorePrereqs=true
    set validVar=true
  )

  if "!VAR!" == "%HELP%" (
    call :usage
    exit /b 0
  )

  if "!VAR!" == "%AGENT_BASE_DIR%" (
    set agentBaseDir=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%AGENT_TYPE%" (
    set agentType=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%AGENT_PORT%" (
    set agentPort=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%EM_AGENT_NAME%" (
    set emAgentName=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%AGENT_REGISTRATION_KEY%" (
    set agentRegistrationKey=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%GATEWAY_HOST%" (
    set gatewayHost=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%GATEWAY_PORT%" (
    set gatewayPort=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%ADDITIONAL_GATEWAYS%" (
    set additionalGateways=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%STAGE_LOCATION%" (
  set stageLocation=!VAL!
  set validVar=true
  shift
  )

  if "!VAR!" == "%HARVESTER_USERNAME%" (
    set dataCollectorUserName=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%HARVESTER_USER_PASSWORD%" (
    set dataCollectorUserPassword=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%DATA_COLLECTOR_USERNAME%" (
    set dataCollectorUserName=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%DATA_COLLECTOR_USER_PASSWORD%" (
    set dataCollectorUserPassword=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%OMR_USERNAME%" (
    set omrUserName=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%OMR_USER_PASSWORD%" (
    set omrUserPassword=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%OMR_HOSTNAME%" (
    set omrHostName=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%OMR_PORT%" (
    set omrPort=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%OMR_SID%" (
    set omrSid=!VAL!
    set prereqArg=OMR_SID !omrSid!
    set harvesterPropArg=Sid=!omrSid!
    set serviceArg=!omrSid!
    set validVar=true
    shift
  )

  if "!VAR!" == "%OMR_SERVICE_NAME%" (
    set omrServiceName=!VAL!
    set prereqArg=OMR_SERVICE_NAME !omrServiceName!
    set harvesterPropArg=Service=!omrServiceName!
    set serviceArg=!omrServiceName!
    set validVar=true
    shift
  )

  if "!VAR!" == "%OMR_CONNECT_STRING%" (
    set omrConnectString=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%OMR_HOST_USERNAME%" (
    set omrHostUserName=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%OMR_HOST_USER_PASSWORD%" (
    set omrHostUserPassword=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%OMR_HOST_USER_SSH_KEY%" (
    set omrHostUserSshKey=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%OMR_STAGE_DIR%" (
    set omrStageDir=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%NAMESPACE%" (
    set nameSpace=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%OMR_USER_ROLE%" (
    set omrRole=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%UNZIP_PATH%" (
    set unzipPath=!VAL!
    set validVar=true
    shift
  )
  if "!VAR!" == "%UNZIP_ARGS%" (
    set unzipArgs=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%CURL_PATH%" (
    set curlPath=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%CURL_ARGS%" (
    set curlArgs=!VAL!
    set validVar=true
    shift
  )

  if "!VAR!" == "%DOWNLOAD_FROM_EDGE%" (
    set downloadFromEdge=true
    set validVar=true
  )

  if "!VAR!" == "%DOWNLOAD_ONLY%" (
    set downloadOnly=true
    set validVar=true
  )

  if "!VAR!" == "%IGNORE_HARVESTER_PREREQS%" (
    set ignoreDataCollectorPrereqs=true
    set validVar=true
  )

  if "!VAR!" == "%IGNORE_DATA_COLLECTOR_PREREQS%" (
    set ignoreDataCollectorPrereqs=true
    set validVar=true
  )

  if "!validVar!" == "false" (
    echo Error: Invalid argument !VAR! passed. Run '!scriptLocation! -help' for the usage of this script.
    exit /b 1
  )

  shift
  goto setArgs
:doneSetArgs


if "%agentType%" == "" (
  set arg=%AGENT_TYPE%
  call :syntaxError
  exit /b 1
) else (
  if "!agentType!" == "cloud_agent" (
    set agentType=!LAMA!
  )
  if "!agentType!" == "data_collector" (
    set agentType=!HARVESTER!
  )
  if "!agentType!" == "apm_java_as_agent" (
    set agentType=!APM!
  )
  if "!agentType!" == "!APM!" (
    set downloadOnly=true
    set apmType=true
    REM java apm agent already release with platform id 226 even though it was generic
    set platformId=226
  )
  if "!agentType!" == "!APM_DOT_NET!" (
    set downloadOnly=true
    set downloadFromEdge=true
    set apmType=true
  )
  if "!agentType!" == "!APM_NODE_JS!" (
    set downloadOnly=true
    set downloadFromEdge=true
    set apmType=true
    REM using generic platform id 226 for apm node js.
    set platformId=226
  )
  if "!agentType!" == "!APM_RUBY!" (
    set downloadOnly=true
    set downloadFromEdge=true
    set apmType=true
    REM using generic platform id 226 for apm ruby.
    set platformId=226
  )
  if "!agentType!" == "!APM_PHP!" (
    set downloadOnly=true
    set downloadFromEdge=true
    set apmType=true
    REM using generic platform id 226 for apm php.
    set platformId=226
  )
  if "!agentType!" == "!APM_IOS!" (
    set downloadOnly=true
    set downloadFromEdge=true
    set apmType=true
    set platformId=512
  )
  if "!agentType!" == "!APM_ANDROID!" (
    set downloadOnly=true
    set downloadFromEdge=true
    set apmType=true
    set platformId=513
  )

  if NOT "!agentType!" == "!LAMA!" if NOT "!agentType!" == "!HARVESTER!" if NOT "!agentType!" == "!GATEWAY!" if NOT "!agentType!" == "!APM!" if NOT "!agentType!" == "!APM_DOT_NET!"  if NOT "!agentType!" == "!APM_NODE_JS!" if NOT "!agentType!" == "!APM_RUBY!" if NOT "!agentType!" == "!APM_PHP!" if NOT "!agentType!" == "!APM_IOS!" if NOT "!agentType!" == "!APM_ANDROID!" (
    echo Error : Invalid Agent Type !agentType!. It should be one of cloud_agent, !GATEWAY!, data_collector, apm_java_as_agent, !APM_DOT_NET! , !APM_NODE_JS!
    exit /b 1
  )

  if "!downloadOnly!" == "true" (
    call :validateDownloadOnlyParams
  ) else (
    call :validateInstallParams
  )
)

if !errorFlag! == true (
  exit /b 1 
)

if "!oracleHostName!" == "" (
  for /f "tokens=1,2,3,4" %%i in ('net config workstation') do (
    if "%%i %%j %%k" == "Full Computer name" (
      set hostname=%%l
    )
  )
  call :convertHostToLC 
  if "!hostname!" == "" (
    if not "!apmType!" == "true" (
      echo Error : Unable to determine hostname.
      exit /b 1
    )
  )
) else (
  set hostname=!oracleHostName!
)

if "!agentInst!" == "" (
  set agentInst=!agentBaseDir!\agent_inst
)

call :getDateTime
if "!downloadOnly!" == "true" (
  set baseDir=!stageLocation!
  set logDir=!stageLocation!
  set logFile=!logDir!\!scriptName!_!dateTimeStamp!.log
  set workDir=!stageLocation!
) else (
  set baseDir=!agentBaseDir!
  set logDir=!agentBaseDir!\logs
  set logFile=!logDir!\!scriptName!_!dateTimeStamp!.log
  set workDir=!agentBaseDir!\ADATMP_!dateTimeStamp!
)
call :createDirectory %baseDir% 
call :createDirectory %workDir% 
call :createDirectory %logDir% 

set command=!curlPath! -help
set errorMessage=!curlPath! -help failed. Ensure curl is installed on this host. Curl can be downloaded from http://curl.haxx.se/download.html
call :execute

REM EMCAGNT-979
call :validateCurlHttps

if not "!unzipPath!" == "unzip" (
  call :validateUnzip
)

REM additionalGateways makes sense only when there is a gateway
REM i.e., clear additionalGateways when not uploading to a gateway
if not "!additionalGateways!" == "" (
  if "!gatewayInputProvided!" == "false" (
    set additionalGateways=
  )
)

call :validateEndPoints

set errorMessage=
set zipName=!agentType!.zip
if "!isStaged!" == "false" (
  set agentZipFile=!workDir!\!zipName!
  echo Downloading !agentType! software ...
  if "!agentType!" == "!Harvester!" (
    call :downloadFile  agentimage !LAMA! !agentZipFile!
    echo Using data collector image from stage.  1>>%logFile%
  ) else (
    call :downloadFile  agentimage !agentType! !agentZipFile!
  )

  if "!downloadOnly!" == "true" (
    if "!apmType!" == "true" (
      if "!apmCollectorRoot!" == "ABSENT" (
        echo "ApmCollectorRoot was not provided by OMC"
        echo "Please contact OMC support"
        exit /b 1
      )
      if "!unzipPath!" == "unzip" (
        set exitOnFailure=false
        call :downloadFile script unzip !workDir!\unzip.exe 
        set exitOnFailure=true
        if not "!curlStatus!" == "200" (
          call :removeFile !workDir!\unzip.exe
          echo "Download of unzip failed. Checking for system unzip" >>%logFile%
          set command=!unzipPath! -help
          set errorMessage=!unzipPath! -help failed. Ensure unzip.exe is installed on this host.
          call :execute
        ) else (
          echo "Download unzip from OMC succeeded" >>%logFile%
          set unzipPath=!workDir!\unzip.exe
        )
        call :validateUnzip
      )
      
      call :downloadFile !securityArtifact! encryptRegKey !workDir!\encrypRegKey
      set /p encrAgentRegistrationPassword=<!workDir!\encrypRegKey
      del !workDir!\encrypRegKey
      call :downloadFile !securityArtifact! agentAuthTokenEncrypted !workDir!\agentAuthTokenEncrypted
      set /p authToken=<!workDir!\agentAuthTokenEncrypted
      del !workDir!\agentAuthTokenEncrypted
      if "!gatewayRoot!" == "" (
        set certType=edgeServiceCert
        set apmCertLocation=!workDir!\!apmCert!
        set certHost=!hostname!
      ) else (
        REM always download the edge cert
        call :downloadFile !securityArtifact! edgeServiceCert !workDir!\!apmCert! !hostname!

        set certType=agentCert
        set apmCertLocation=!workDir!\!apmGatewayCertName!
        set certHost=!gatewayHost!
      )
      call :downloadFile !securityArtifact! !certType! !apmCertLocation! !certHost!
      if not "!additionalGateways!" == "" (
        call :generateAdditionalGatewaysProps
      ) else (
        if "!gatewayRoot!" == "" (
          REM OMC upload root
          set uploadRoots=!UploadRoot!
        ) else (
          REM single gateway root
          set uploadRoots=!gatewayRoot!
        )
      )
      if "!agentType!" == "!APM_DOT_NET!" (
        call :generateAPMDotNetBatchFile
      )
      if "!agentType!" == "!APM_NODE_JS!" (
        call :generateAPMNodeJsBatchFile
      )
      if "!agentType!" == "!APM!" (
        call :downloadFile !securityArtifact! agentAuthWallet !workDir!\!apmAuthToken! !hostname!
        call :generateAPMProperties
      )
      if "!agentType!" == "!APM_RUBY!" (
        call :generateAPMRubyProperties
      )
      if "!agentType!" == "!APM_PHP!" (
        call :generateAPMPhpProperties
      )
      if "!agentType!" == "!APM_IOS!" (
        call :generateAPMMobileProperties
      )
      if "!agentType!" == "!APM_ANDROID!" (
        call :generateAPMMobileProperties
      )
      set command=!unzipPath! !unzipDefaultArgs! !unzipArgs! !agentZipFile! -d !workDir!
      call :execute
      call :removeFile !agentZipFile!
    ) else (
      echo Downloading AgentInstall.bat ...
      call :downloadFile  script agentinstallscriptbat !workDir!\!scriptName!.bat
    )
    call :removeFile !logFile!
    echo Download completed successfully.
    exit /b 0
  )
) else (
  echo Using Staged software !scriptDir!\!zipName!
  set agentZipFile=!scriptDir!\!zipName!
)
echo Extracting Agent Software ...
if "!unzipPath!" == "unzip" (
  set unzipDir=!workDir!\unzip
  call :createDirectory !unzipDir!
  set unzipPath=!unzipDir!\unzip.exe
  call :downloadFile  script unzip !unzipPath!
  echo "Download unzip from OMC succeeded" >>%logFile%
  call :validateUnzip
)
  
set command=!unzipPath! !unzipDefaultArgs! !unzipArgs! !agentZipFile! -d !workDir!
call :execute

echo Generating emaas.properties ...
call :generateSaasProperties !workDir!\!emSaaSPropertiesFile!

echo Installing the Agent ...
set command=!workDir!\AgentDeployment.bat AGENT_BASE_DIR=!agentBaseDir! -softwareOnly
call :execute

call :readAgentImageProperties %workDir%\agentimage.properties
set core_version=!type!\!version!
call :copyFile !workDir!\!emSaaSPropertiesFile! !agentBaseDir!\!core_version!\!sysAdminDir!

echo Downloading Certificates ...
if "!agentType!" == "!APM!" (
  set trustCertGatewayFile=!workDir!\!apmGatewayCertName!
) else (
  call :createDirectory !agentBaseDir!\!core_version!\!stageTrustedCerts!
  set trustCertGatewayFile=!agentBaseDir!\!core_version!\!trustCertGateway!
)
if "!gatewayInputProvided!" == "true" (
  call :downloadFile !securityArtifact! agentCert !trustCertGatewayFile! !gatewayHost!
) else (
  call :downloadFile !securityArtifact! edgeServiceCert !agentBaseDir!\!core_version!\!trustCertEdge! !hostname!
  call :downloadFile !securityArtifact! agentCert !agentBaseDir!\!core_version!\!gatewayCert! !hostname!
  call :downloadFile !securityArtifact! agentPrivateKey !agentBaseDir!\!core_version!\!gatewayKey! !hostname!
  call :downloadFile !securityArtifact! agentAuthTokenEncrypted !workDir!\agentAuthToken
  set /p authToken=<!workDir!\agentAuthToken
  call :removeFile !workDir!\agentAuthToken
)

REM set configCommand=!workDir!\AgentDeployment.bat -configOnly %*
REM set command=!configCommand!
REM call :execute

echo Detecting free port ...
set agentOracleHome=%agentBaseDir%\!core_version!
set userPassedAgentPort=!agentPort!
set command=!agentOracleHome!\jdk\jre\bin\java -cp !agentOracleHome!\jlib\agentClone.jar oracle.sysman.agent.installer.AgentFreePortUtility !agentOracleHome! !agentPort! !hostname!
call :execute
call :readPortProperties
if "!agentPort!" == "NA" (
  if "!userPassedAgentPort!" == "-1" (
    echo Error : Ports 3872,1830-1849 are not free. Free any one of the port in the above range and retry the deployment
  )else (
    echo Error : Port !userPassedAgentPort! passed by user is not free. Retry the deployment passing a free port in range 3872,1830-1849
  )
  exit /b 1
)
call :setCommands

set gwayPropertiesFile=!logDir!\agent.properties
if exist !gwayPropertiesFile! (
  call :removeFile !gwayPropertiesFile!
)

if "%agentType%" == "!HARVESTER!" (
  if "!ignoreDataCollectorPrereqs!" == "false" (
    echo Performing Data Collector Prereqs ...
    set javaHome=!agentOracleHome!\jdk\bin
    set jlibHome=!agentOracleHome!\jdk\bin\jlib
    set stdInput=!omrUserPassword! !dataCollectorUserPassword! !omrHostUserPassword!
    set command=!javaHome!/java  -classpath !jlibHome!/gcagent_lama.jar;!agentOracleHome!/jdbc/lib/ojdbc7.jar;!agentOracleHome!/ucp/lib/ucp.jar;!agentOracleHome!/modules/oracle.http_client_11.1.1.jar;!agentOracleHome!/lib/xmlparserv2.jar;!agentOracleHome!/lib/jsch-0.1.51.jar;!agentOracleHome!/lib/optic.jar;!agentOracleHome!/modules/oracle.dms_11.1.1/dms.jar;!agentOracleHome!/modules/oracle.odl_11.1.1/ojdl.jar;!agentOracleHome!/modules/oracle.odl_11.1.1/ojdl2.jar;!agentOracleHome!/sysman/jlib/log4j-core.jar;!agentOracleHome!/jlib/gcagent_emdctl.jar oracle.sysman.emaas.lama.harvester.checks.HarvesterConfigPreReqChecker OMR_USERNAME !omrUserName! HARVESTER_USERNAME !dataCollectorUserName! OMR_HOST_USERNAME !omrHostUserName! OMR_STAGING_DIR !omrStageDir! OMR_HOSTNAME !omrHostName! OMR_PORT !omrPort! !prereqArg!
    call :execute
  )
  call :generateHarvesterProperties
)

echo Deploying Agent ...
set command=!deployCommand!
call :execute

call :generateAgentInstallModeProperties

if not "!additionalGateways!" == "" (
  if not "!agentType!" == "!GATEWAY!" (
    call :generateAdditionalGatewaysProps
    echo gatewayUrls=!gatewayUrls! >>!gwayPropertiesFile!

    REM To simplify AgentDeployment.bat on Windows, we will not call it from
    REM AgentInstall.bat. Just invoke omcli add_gateway agent [gwayUrlFile].
    if not "!agentType!" == "!APM!" (
      echo Adding additional gateways ...
      set command=!addGatewayCommand! !gwayPropertiesFile!
      call :execute
    )
  )
)

if "!gatewayInputProvided!" == "false" (
  echo Setting Authorization parameters ...
  set stdInput0=!authToken!
  set stdInput=!agentRegistrationKey!
  set command=!authCommand!
  call :execute
)

if "%agentType%" == "!HARVESTER!" ( 
  echo Getting OMR id ...
  set fileToRedirect=!workDir!\omrId.properties
  set stdInput=!omrUserPassword!
  set command=!omrIdCommand!
  call :execute
  call :readOmrIdProperties
)

if not "!agentPropertiesFile!" == "" (
  call :processAgentPropertiesFile !agentPropertiesFile!
)

echo Registering the agent ...
call :generateRegistrationProperties
set stdInput=!agentRegistrationKey!
set command=!registerCommand!
call :execute

if "%agentType%" == "!HARVESTER!" ( 
  echo Configuring Data Collector ...
  set stdInput=!dataCollectorUserPassword! !omrUserPassword! !omrHostUserPassword! 
  set command=!configHarvesterCommand!
  call :execute
)

echo !agentOracleHome!:!agentInst!>!agentOracleHome!\install\oragchomelist
echo DOWNLOAD_LOC=!agentBaseDir!\download>!agentOracleHome!\install\download.info

if not "%agentType%" == "!GATEWAY!" (
  echo Configuring Plugins ...
  call :configurePlugins
)

echo Creating OMCAgent Service ...
call :createService
call :createRegKeys

echo Starting the agent ...
set command=!startCommand!
call :execute

echo Cleaning up temporary files ...
call :removeDirectory !workDir!

exit /b 0

:configurePlugins
  for /F  %%A in (!agentBaseDir!\plugins.properties) do (
    for /F "delims=| tokens=1-3" %%B in ("%%A") do (
      set pluginId=%%B
      set pluginRelPath=%%D
      echo plugin ID !pluginId!>>!logFile!
      set pluginRelPath=!pluginRelPath:/=\!
      echo plugin reg !pluginRelPath!>>!logFile! 
      set command=!omcliLoc! preconfig plugin !pluginId!
      call :execute
      set command=!omcliLoc! config plugin !agentBaseDir!\!pluginRelPath!
      call :execute
    )
  )
goto:eof

:getAgentProperty
  set propertyValue=
  set getPropCommand=%1 getproperty agent -name %2
  for /f "delims=\= tokens=1-2"  %%i in ('!getPropCommand!') do (
    if "%%i" == "%2" (
      set propertyValue=%%j
    )
  )
goto:eof

:readPortProperties
  echo Reading the properties file: !agentOracleHome!\install\FreePort.properties 1>>%logFile%
  for /F "delims=\= tokens=1-2" %%A in (!agentOracleHome!\install\FreePort.properties) do (
    if "%%A" == "AGENT_PORT" (
      set agentPort=%%B
      echo Agent Port =====!agentPort!=====  1>>%logFile%
    )
  )
goto:eof

:readOmrIdProperties
  echo Reading omr Id  1>>%logFile%
  for /F "delims=\= tokens=1-2" %%A in (!workDir!\omrId.properties) do (
    if "%%A" == "OMR ID" (
      set omrId=%%B
      echo OMR ID=====!omrId!=====  1>>%logFile%
    )
  )
goto:eof


:generateHarvesterProperties
  set fileToGenerate=!agentOracleHome!/install/harvester.properties
  echo UserName=!dataCollectorUserName!>!fileToGenerate!
  set translatedOmrStageDir=!omrStageDir:\=/!
  echo StageDir=!translatedOmrStageDir!>>!fileToGenerate!
  echo HarvestHostUserName=!omrHostUserName!>>!fileToGenerate!
  echo !harvesterPropArg!>>!fileToGenerate!
  echo UserNamePriv=!omrUserName!>>!fileToGenerate!
  echo Host=!omrHostName!>>!fileToGenerate!
  echo Port=!omrPort!>>!fileToGenerate!
  echo omrConnectString=!omrHostName!:!omrPort!:!serviceArg!>>!fileToGenerate!
goto:eof

:generateRegistrationProperties
  echo buildId value is reg !buildId!----  1>>%logFile%
  set buildId=%buildId: =%
  echo buildId value is reg !buildId!----  1>>%logFile%
  set registrationPropertiesFile=!agentOracleHome!\install\registration.properties
  if "%agentType%" == "!LAMA!" ( 
    set entityType=Lama
    set displayName=!hostname!:!agentPort!
    set registration_info=buildID=!buildId!;agentName=!emAgentName!;gatewayHost=!gatewayHost!;gatewayPort=!gatewayPort!;gatewayUrls=
  )

  if "%agentType%" == "!GATEWAY!" ( 
    set entityType=Gateway
    set displayName=!hostname!:!agentPort!
    set registration_info=buildID=!buildId!
  )

  if "%agentType%" == "!HARVESTER!" ( 
    set entityType=Harvester
    set displayName=!hostname!:!agentPort!
    set registration_info=buildID=!buildId!;agentName=!emAgentName!;gatewayHost=!gatewayHost!;gatewayPort=!gatewayPort!;gatewayUrls=
  )

  echo entity_type=!entityType!> !registrationPropertiesFile!
  echo display_name=!displayName!>> !registrationPropertiesFile!
  echo entity_name=!hostname!:!agentport!>> !registrationPropertiesFile!
  if not "%agentType%" == "!GATEWAY!" ( 
    echo om_agent_url=!emAgentName!>> !registrationPropertiesFile!
  )
  set translatedAgentInst=!agentInst:\=/!
  echo agentInstanceDir=!translatedAgentInst!>> !registrationPropertiesFile!
  echo orcl_gtp_os=Windows>> !registrationPropertiesFile!
  echo orcl_gtp_platform=x86_64>> !registrationPropertiesFile!
  echo orcl_gtp_target_version=!version!>> !registrationPropertiesFile!
  echo registration_info=!registration_info!>>!registrationPropertiesFile!
  if "%agentType%" == "!HARVESTER!" ( 
    echo omrId=!omrId!>>!registrationPropertiesFile!
    if "!nameSpace!" == "" (
      echo namespace=!hostname!:!agentport!>>!registrationPropertiesFile!
    ) else (
      echo namespace=!nameSpace!>>!registrationPropertiesFile!
    )
    echo omrConnectString=!omrHostName!:!omrPort!:!omrSid!>>!registrationPropertiesFile!
  )
goto:eof

:setCommands
  set emctlOhLoc==!agentOracleHome!\bin\emctl.bat
  set omcliLoc==!agentInst!\bin\omcli.bat
  set startCommand=!omcliLoc! start agent
  set registerCommand=!omcliLoc! register agent !agentOracleHome!\install\registration.properties
  set authCommand=!omcliLoc! set_authorization_token agent 
  if "%agentType%" == "!GATEWAY!" ( 
    set deployCommand=!emctlOhLoc! deploy gateway  !agentInst! !hostname!:!agentPort! !hostname!
  ) else (
    set addGatewayCommand=!omcliLoc! add_gateway agent
    set deployCommand=!emctlOhLoc! deploy lama !gatewayParam! !agentInst! !hostname!:!agentPort! !hostname!
    set omrIdCommand=!omcliLoc! getomrid_datacollector agent !agentOracleHome!\install\harvester.properties
    set configHarvesterCommand=!omcliLoc! config_datacollector agent !agentOracleHome!\install\harvester.properties
  )
goto:eof


:createService
  echo Reading the properties file: !agentOracleHome!\install\agentService.properties  1>>%logFile%
  for /F "delims=\= tokens=1-2" %%A in (!agentOracleHome!\install\agentService.properties) do (
    if "%%A" == "agentServiceName" (
      set agentServiceName=%%B
      echo Agent Service Name=====!agentServiceName!=====  1>>%logFile%
    )
  )
  set command=sc create !agentServiceName! binPath= !agentOracleHome!\bin\nmesrvc.exe start= auto
  call :execute
  if ERRORLEVEL 1 (call :printError
    exit /b 1)
goto:eof

:createRegKeys
  set command=reg add HKLM\SOFTWARE /v ORACLE\SYSMAN\!agentServiceName!&reg add HKLM\SOFTWARE\ORACLE\SYSMAN\!agentServiceName! /v EMDROOT /d !agentOracleHome!&reg add HKLM\SOFTWARE\ORACLE\SYSMAN\!agentServiceName! /v ORACLE_HOME /d !agentOracleHome!&reg add HKLM\SOFTWARE\ORACLE\SYSMAN\!agentServiceName! /v EMSTATE /d !agentInst!&reg add HKLM\SOFTWARE\ORACLE\SYSMAN\!agentServiceName! /v CONSOLE_CFG /d agent
  call :execute
  if ERRORLEVEL 1 (call :printError
    exit /b 1)
goto:eof

:validateDownloadOnlyParams
  if "%stageLocation%" == "" (
    set arg=%STAGE_LOCATION%
    call :syntaxError
  )
  if "%agentRegistrationKey%" == "" (
    set arg=%AGENT_REGISTRATION_KEY%
    call :syntaxError
  )
  if not "!agentType!" == "!GATEWAY!" ( 
    if not "%gatewayHost%" == "" (
      if not "%gatewayPort%" == "" (
        set gatewayInputProvided=true
        set gatewayParam=-o !gatewayHost!:!gatewayPort!
        set gatewayRoot=https://!gatewayHost!:!gatewayPort!
        set alcEndPoint=!gatewayRoot!/emd/gateway/AgentLifeCycle
        set gatewayUrl=!gatewayRoot!/emd/main
      )
    )
  )
goto:eof

:validateInstallParams
  if "%agentBaseDir%" == "" (
    set arg=%AGENT_BASE_DIR%
    call :syntaxError
  ) else (
    set temp_str=!agentBaseDir!
    set str_len=0
    :loop
    if defined temp_str (
      set temp_str=!temp_str:~1!
      SET /A str_len += 1
      GOTO loop
    )
    if !str_len! GTR 22 (
      echo Error: The length of AGENT_BASE_DIR:!agentBaseDir! is !str_len!. It should be less than 23 characters.
      set errorFlag=true
    )
  )
  if "%agentRegistrationKey%" == "" (
    set arg=%AGENT_REGISTRATION_KEY%
    call :syntaxError
  )

  if not "!agentPropertiesFile!" == "" (
    if not exist !agentPropertiesFile! (
      echo ERROR: The agent properties files !agentPropertiesFile! does not exist
      set errorFlag=true
    )
  )

  if not "!agentType!" == "!GATEWAY!" ( 
    if not "%gatewayHost%" == "" (
      if not "%gatewayPort%" == "" (
        set gatewayInputProvided=true
        set gatewayParam=-o !gatewayHost!:!gatewayPort!
        set gatewayRoot=https://!gatewayHost!:!gatewayPort!
        set alcEndPoint=!gatewayRoot!/emd/gateway/AgentLifeCycle
        set gatewayUrl=!gatewayRoot!/emd/main
      )
    )

    if not "%emAgentHome%" == "" (
      if not exist "%emAgentHome%\bin\emctl.bat" (
        echo Error: EM_AGENT_HOME %emAgentHome% is not a valid EM Agent Home
        set errorFlag=true
      ) else (
        call :getAgentProperty %emAgentHome%\bin\emctl.bat EMD_URL
        if "!propertyValue!" == "" (
          echo Error: Unable to retrieve the EMD_URL from the EM_AGENT_HOME %emAgentHome%
          set errorFlag=true
        ) else (
          for /F "tokens=2 delims=/ " %%a in ("!propertyValue!") do (
            set emAgentName=%%a
            if  "%emAgentName%" == "" (
              echo Error: Unable to derive the EMD_URL from the EM_AGENT_HOME %emAgentHome%
              set errorFlag=true
            )
          )
        )
      )
    )

    if "%emAgentName%" == "" (
      set arg=%EM_AGENT_NAME%
      call :syntaxError
    )

    for /F "tokens=1 delims=: " %%a in ("!emAgentName!") do (
      set emAgentHostName=%%a
      if "!emAgentHostName!" == "" (
        echo Error: EM_AGENT_NAME !emAgentName! is not of the format host:port
        set errorFlag=true
      )
    )

    if "!agentType!" == "!HARVESTER!" (
      if "%dataCollectorUserName%" == "" (
        set arg=%DATA_COLLECTOR_USERNAME%
        call :syntaxError
      )
      if "%dataCollectorUserPassword%" == "" (
        set arg=%DATA_COLLECTOR_USER_PASSWORD%
        call :syntaxError
      )
      if "%omrUserName%" == "" (
        set arg=%OMR_USERNAME%
        call :syntaxError
      )
      if "%omrUserPassword%" == "" (
        set arg=%OMR_USER_PASSWORD%
        call :syntaxError
      )
      if "%omrHostName%" == "" (
        set arg=%OMR_HOSTNAME%
        call :syntaxError
      )
      if "%omrPort%" == "" (
        set arg=%OMR_PORT%
        call :syntaxError
      )
      if "%omrSid%" == "" (
        if "%omrServiceName%" == "" (
          set arg=%OMR_SID% or %OMR_SERVICE_NAME%
          call :syntaxError
        )
      )
      if not "%omrSid%" == "" (
        if not "%omrServiceName%" == "" (
          echo Error: You can specify either %OMR_SID% or %OMR_SERVICE_NAME% but not both
          set errorFlag=true
        )
      )
      if "%omrHostUserName%" == "" (
        set arg=%OMR_HOST_USERNAME%
        call :syntaxError
      )
      if "%omrHostUserPassword%" == "" (
        set arg=%OMR_HOST_USER_PASSWORD%
        call :syntaxError
      )
    )
  )
goto:eof

REM EMCAGNT-979
:validateCurlHttps
  set https=true
  set curlVersionFile=!workDir!\curlversion.out
  call !curlPath! --version 1>>!curlVersionFile! 2>>&1
  call findstr /rc:"^Features:.*SSL.*" !curlVersionFile! >>%logFile%
  if ERRORLEVEL 1 (
    set https=false
  ) else (
    call findstr /rc:"^Protocols:.*https.*" !curlVersionFile! >>%logFile%
    if ERRORLEVEL 1 (
      set https=false
    )
  )
  if "%https%" == "false" (
    echo **WARNING** curl may be missing full https support
  ) else (
    call :removeFile !curlVersionFile!
  )
goto:eof

:validateEndPoints
  if "!ignorePrereqs!" == "false" (
    if "!gatewayInputProvided!" == "true" (
      set accessError="Error : Unable to connect to the gateway url !gatewayUrl!. Ensure the value of GATEWAY_HOST(!gatewayHost!),GATEWAY_PORT(!gatewayPort!) are correct and the gateway is up and running."
      call :accessUrl !gatewayUrl!
    )

    set accessError="Error : Unable to connect to Agent LCM service.Ensure the Agent Life Cycle service is running."
    call :accessUrl !alcEndPoint!/softwaredispatcher/testSvc 

    set accessError="Error: The registration key validation failed. Ensure the registration key is valid."
    call :accessUrl !alcEndPoint!/softwaredispatcher/validateRegKey

    if "!agentType!" == "!LAMA!" (
      if not "!emAgentName!" == "greenfield:agent" (
        if not "!hostname!" == "!emAgentHostName!" (
          echo Error: The EM_AGENT_NAME !emAgentName! does not match the hostname[!hostname!] on which this agent is being be deployed.
          goto :halt
        )
      )
    )
  ) else (
    echo Skipping Prereq Checks ...
  )
goto:eof

:accessUrl
  set url=%1
  set curlTempOut=!workDir!\curl.output
  set curlCommand=!curlPath! !curlArgs! !curlDefaultArgs! -H X-USER-IDENTITY-DOMAIN-NAME:!tenantId! -H X-USER-REGISTRATION_KEY:!agentRegistrationKey! -o !curlTempOut! -i !url! 
  set curlPrintCommand=!curlPath! !curlArgs! !curlDefaultArgs! -H X-USER-IDENTITY-DOMAIN-NAME:!tenantId! -H X-USER-REGISTRATION_KEY:xxxxx -o !curlTempOut! -i !url! 
  echo !curlPrintCommand! 1>>%logFile% 2>>&1
  set curlStatusFile=!workDir!\curl.status
  !curlCommand! 1>!curlStatusFile! 2>&1
  set /p curlStatus=<!curlStatusFile!
  if exist !curlStatusFile! (
    call :removeFile !curlStatusFile!
  )
  if exist !curlTempOut! (
    call :removeFile !curlTempOut!
  )
  if not "!curlStatus!" == "200" (
    echo !accessError! : status code :!curlStatus!
    goto :halt
  )
goto:eof

:downloadFile
  set type=%1
  set source=%2
  set destinationFile=%3
  set certHostName=%4
  set alcSwEndPoint=!alcEndPoint!/softwaredispatcher/artifact
  if "%destinationFile%" == "" (
    set destFileArg=
  ) else (
    set destFileArg=-o !destinationFile!
  )

  if "%certHostName%" == "" (
    set hostnameParam=
  ) else (
    set hostnameParam=^&hostname=!certHostName!
  )
  set curlCommand=!curlPath! !curlArgs! !curlDefaultArgs! -H X-USER-IDENTITY-DOMAIN-NAME:!tenantId! -H X-USER-REGISTRATION_KEY:!agentRegistrationKey! !alcSwEndPoint!?type=!type!^&platformId=!platformId!^&name=!source!!hostnameParam! !destFileArg!
  set curlPrintCommand=!curlPath! !curlArgs! !curlDefaultArgs! -H X-USER-IDENTITY-DOMAIN-NAME:!tenantId! !alcSwEndPoint!?type=!type!^&platformId=!platformId!^&name=!source!!hostnameParam! !destFileArg!
  echo !curlPrintCommand! 1>>%logFile% 2>>&1
  if "%destinationFile%" == "" (
    REM for /f "delims=" %%i in ('!curlCommand!') do echo ====%%i
  ) else (
    REM !curlCommand! 1>>%logFile% 2>>&1
    set curlStatusFile=!workDir!\curl.status
    !curlCommand! 1>!curlStatusFile! 2>&1
    set /p curlStatus=<!curlStatusFile!
    call :removeFile !curlStatusFile!

    if "!gatewayInputProvided!" == "false" (
      set recommendation=Set the environment variable https_proxy if the download needs to happen over a proxy server
    )
    if "!exitOnFailure!" == "false" (
      echo "Ignore download failure !curlStatus!" >>%logFile%
    ) else (
      if not "!curlStatus!" == "200" (
        echo ERROR: Download of artifact !source! failed ... with status !curlStatus!. !recommendation!
        echo Check log file !logFile! for more information.
        if exist !destinationFile! (
          type !destinationFile!
        )
        goto:halt
      )
    )
  )
goto:eof

:convertHostToLC
  set _UCASE=ABCDEFGHIJKLMNOPQRSTUVWXYZ
  set _LCASE=abcdefghijklmnopqrstuvwxyz
  for /l %%a in (0,1,25) do (
    call set _FROM=%%_UCASE:~%%a,1%%
    call set _TO=%%_LCASE:~%%a,1%%
    call set hostname=%%hostname:!_FROM!=!_TO!%%
  )
goto:eof

:copyFile
  echo Copying file %1 to %2 1>>%logFile% 2>>&1
  if not exist %1 (
    echo ERROR: Source File %1 does not exist
    goto:halt
  )
  copy /Y %1 %2 1>>%logFile% 2>>&1
  if ERRORLEVEL 1 (
    echo ERROR: Copying file %1 to %2 failed.
    goto:halt
  )
goto:eof

:removeDirectory
  echo Deleting directory %1 1>>%logFile% 2>>&1
  if exist %1 (
    rmdir /S /Q %1 
    if ERRORLEVEL 1 (
      echo ERROR: Deleting directory %1 failed.
      goto:halt
    )
  )
goto:eof

:removeFile
  echo Deleting file %1 1>>%logFile% 2>>&1
  if exist %1 (
    del %1
    if ERRORLEVEL 1 (
      echo ERROR: Deleting file %1 failed.
      goto:halt
    )
  )
goto:eof

:createDirectory
  if not exist %1 (
    mkdir %1
    if ERRORLEVEL 1 (
      echo ERROR: Creating directory %1 failed.
      goto:halt
    )
  )
goto:eof

:generateAgentInstallModeProperties
  if "%agentType%" == "!LAMA!" (
    set installMode=Cloud Agent
  )

  if "%agentType%" == "!GATEWAY!" (
    set installMode=Gateway
  )

  if "%agentType%" == "!HARVESTER!" (
    set installMode=Data Collector
  )
  echo INSTALL_MODE=!installMode!>!agentOracleHome!\sysman\admin\agent.installmode
goto:eof

:processAgentPropertiesFile
  echo Reading agent properties file: %1 1>>%logFile% 
  if exist %1 (
    for /F "delims=\= tokens=1-2" %%A in (%1) do (
      echo setting property %%A=%%B 1>>%logFile%
      set command=!omcliLoc! setproperty agent -allow_new -name %%A -value %%B
      call :execute
    )
  )
goto:eof

:readAgentImageProperties
  echo Reading the properties file: %1 1>>%logFile% 
  if exist %1 (
    for /F "delims=\= tokens=1-2" %%A in (%1) do (
      if "%%A" == "VERSION" (
        set version=%%B
      )
      if "%%A" == "TYPE" (
        set type=%%B
      )
      if "%%A" == "ARUID" (
        set aruid=%%B
      )
      if "%%A" == "BUILDID" (
        set buildId=%%B
        echo buildId value is !buildId!  1>>%logFile%
      )
    )
  )
goto:eof

:generateAPMProperties
  set fileToGenerate=!workDir!\ApmAgentBundle.properties
  echo Tenant_ID=!tenantId! >!fileToGenerate!
  echo UploadRoot=!uploadRoots! >>!fileToGenerate!
  echo ApmCollectorRoot=!apmCollectorRoot! >>!fileToGenerate!
  echo RegistryService_URL=!serviceUrl! >>!fileToGenerate!
  echo AgentAuthToken=!authToken! >>!fileToGenerate!
  echo RegistrationKey=!encrAgentRegistrationPassword! >>!fileToGenerate!
  echo ORACLE_HOSTNAME=!hostname! >>!fileToGenerate!
goto:eof

:generateAPMDotNetBatchFile
  set fileToGenerate=!workDir!\OMC.ini
  echo [OMC]>!fileToGenerate!
  echo oracle.apmaas.agent.registryServiceUrl=!serviceUrl!>>!fileToGenerate!
  echo oracle.apmaas.agent.tenant=!tenantId!>>!fileToGenerate!
  echo oracle.apmaas.agent.uploadRoot=!uploadRoots!>>!fileToGenerate!
  echo oracle.apmaas.agent.collectorRoot=!apmCollectorRoot!>>!fileToGenerate!
  echo oracle.apmaas.agent.registrationKey=!encrAgentRegistrationPassword!>>!fileToGenerate!
  echo oracle.apmaas.agent.omcAuthToken=!authToken!>>!fileToGenerate!
  echo ORACLE_HOSTNAME=!hostname! >>!fileToGenerate!
  echo # the following are optional - only if proxy will be required by agent>>!fileToGenerate!
  echo oracle.apmaas.agent.proxyHost=>>!fileToGenerate!
  echo oracle.apmaas.agent.proxyPort=>>!fileToGenerate!
  echo oracle.apmaas.agent.proxyAuthUser=>>!fileToGenerate!
  echo oracle.apmaas.agent.proxyAuthPassword=>>!fileToGenerate!
  echo oracle.apmaas.agent.proxyAuthDomain=>>!fileToGenerate!
  REM echo msiexec /i OracleAPMAgent.msi REGISTRY_URL=!serviceUrl! REGISTRATION_KEY=!encrAgentRegistrationPassword! TENANT_ID=!tenantId! OMC_AUTH_TOKEN=!authToken! >!fileToGenerate!
goto:eof

:generateAPMNodeJsBatchFile
  set fileToGenerate=!workDir!\oracle-apm-config.json
  echo {>!fileToGenerate!
  echo "registryServiceUrl":"!serviceUrl!",>>!fileToGenerate!
  echo "tenant": "!tenantId!",>>!fileToGenerate!
  echo "uploadRoot":"!uploadRoots!",>>!fileToGenerate!
  echo "collectorRoot":"!apmCollectorRoot!",>>!fileToGenerate!
  echo "registrationKey": "!encrAgentRegistrationPassword!",>>!fileToGenerate!
  set apmTranslatedCertLocation=%apmCertLocation:\=/%
  echo "pathToCertificate":"!apmTranslatedCertLocation!",>>!fileToGenerate!
  echo "auth":"!authToken!",>>!fileToGenerate!
  echo "MCAccessRateSeconds": "60",>>!fileToGenerate!
  echo "MEIDCheckRateSeconds": "60">>!fileToGenerate!
  echo "ORACLE_HOSTNAME": "!hostname!" >>!fileToGenerate!
  echo }>>!fileToGenerate!
goto:eof

:generateAPMRubyProperties
  set fileToGenerate=!workDir!\omc.yml
  echo registry_service_url: !serviceUrl!> !fileToGenerate!
  echo tenant: !tenantId!>> !fileToGenerate!
  echo uploadRoot: !uploadRoots!>> !fileToGenerate!
  echo collectorRoot: !apmCollectorRoot!>> !fileToGenerate!
  echo registration_key: !encrAgentRegistrationPassword!>> !fileToGenerate!
  echo omc_auth_token: !authToken!>> !fileToGenerate!
  echo ORACLE_HOSTNAME: !hostname!>>!fileToGenerate!
  echo # the following are optional - only if proxy will be required by agent>> !fileToGenerate!
  echo proxy_host:>> !fileToGenerate!
  echo proxy_port:>> !fileToGenerate!
  echo proxy_auth_user:>> !fileToGenerate!
  echo proxy_auth_password:>> !fileToGenerate!
goto:eof

:generateAPMPhpProperties
  set fileToGenerate=!workDir!\ApmAgentBundle.properties
  echo Tenant_ID=!tenantId!> !fileToGenerate!
  echo UploadRoot=!uploadRoots! >>!fileToGenerate!
  echo ApmCollectorRoot=!apmCollectorRoot! >>!fileToGenerate!
  echo RegistryService_URL=!serviceUrl!>> !fileToGenerate!
  echo AgentAuthToken=!authToken!>> !fileToGenerate!
  echo RegistrationKey=!encrAgentRegistrationPassword!>> !fileToGenerate!
  echo ORACLE_HOSTNAME=!hostname! >>!fileToGenerate!
  echo # the following are optional - only if proxy will be required by agent>> !fileToGenerate!
  echo proxy_host=>> !fileToGenerate!
  echo proxy_port=>> !fileToGenerate!
  echo proxy_auth_user=>> !fileToGenerate!
  echo proxy_auth_password=>> !fileToGenerate!
goto:eof

:generateAPMMobileProperties
  set fileToGenerate=!workDir!\ApmMobileAgent.properties
  echo Tenant_ID=!tenantId!> !fileToGenerate!
  echo ApmClientCollector_URL=!apmCollectorRoot!>> !fileToGenerate!
  echo MobileApp_ID=>> !fileToGenerate!
  echo MobileAgentMEID=>> !fileToGenerate!
  echo ORACLE_HOSTNAME=!hostname! >>!fileToGenerate!
goto:eof

:generateSaasProperties
  echo tenantID=!tenantId!>%1
  if "!gatewayInputProvided!" == "false" (
    echo serviceUrls=!serviceUrl!>>%1
    echo UploadRoot=!UploadRoot!>>%1
  )
goto:eof

:validateUnzip
  echo "Unzip is being used from !unzipPath! path" >>%logFile%
  set command=!unzipPath! -help
  set errorMessage=Ensure valid unzip.exe is present at !unzipPath!.
  call :execute
goto:eof

REM
REM This function downloads necessary certificates for additional gateways
REM and sets the derived variables
REM !gatewayUrls! (cloud agent->gateway only)
REM !uploadRoots! (APM agents only)
REM It does not modify any properties files.
REM
:generateAdditionalGatewaysProps
  set gateways=!gatewayRoot!
  echo Downloading additional Gateway certificates ...
  for %%a in ("!additionalGateways:,=" "!") do (
    set url=%%~a
    set addGatewayHostname=
    for /f "tokens=1,2 delims=/:" %%A in ("!url!") do (
      set addGatewayHostname=%%B
    )
    REM APM Agents needed the cert names to end with extn .cer, cloud agents don't care
    if "!apmType!" == "true" (
      set certPath=!workDir!\trustCert_!addGatewayHostname!.cer
    ) else (
      set certPath=!agentBaseDir!\!core_version!\!stageTrustedCerts!\trustCert_!addGatewayHostname!
    )
    REM TODO:downloadFile using THIS gateway
    call :downloadFile !securityArtifact! agentCert !certPath! !addGatewayHostname!
    REM TODO:add only on success
    set gateways=!gateways!,!url!
  )
  if "!apmType!" == "true" (
    set uploadRoots=!gateways!
  ) else (
    set gatewayUrls=!gateways!
  )
goto:eof

:getDateTime
  set DATETIME=
  for /f "skip=1 delims=" %%x in ('wmic os get localdatetime') do if not defined DATETIME set DATETIME=%%x
  echo !DATATIME!
  set DATE.YEAR=%DATETIME:~0,4%
  set DATE.MONTH=%DATETIME:~4,2%
  set DATE.DAY=%DATETIME:~6,2%
  set DATE.HOUR=%DATETIME:~8,2%
  set DATE.MINUTE=%DATETIME:~10,2%
  set DATE.SECOND=%DATETIME:~12,2%
  set dateTimeStamp=%DATE.YEAR%-%DATE.MONTH%-%DATE.DAY%_%DATE.HOUR%-%DATE.MINUTE%-%DATE.SECOND%
goto:eof

:execute
  echo Executing command !command! 1>>%logFile% 2>>&1
  set tmpResponseFile=!workDir!\input.properties
  if not "!stdInput!" == "" (
    call :removeFile !tmpResponseFile!
    if not "!stdInput0!" == "" (
      echo !stdInput0! >>!tmpResponseFile!
    )
    for %%a in (!stdInput!) do echo %%a >>!tmpResponseFile!
    if not "!fileToRedirect!" == "" (
      call :removeFile !fileToRedirect!
      call !command! <!tmpResponseFile!  1>>!fileToRedirect! 2>>&1
    ) else (
      call !command! <!tmpResponseFile!  1>>%logFile% 2>>&1
    )
  ) else (
    call !command! 1>>%logFile% 2>>&1
  )
  if ERRORLEVEL 1 (
    call :printError
    if not "!errorMessage!" == "" (
      echo !errorMessage!
    )
    echo Check log file !logFile! for more information.
    call :removeFile !tmpResponseFile!
    set stdInput=
    set stdInput0=
    goto:halt
  )
  call :removeFile !tmpResponseFile!
  set errorMessage=
  set stdInput0=
  set stdInput=
  set fileToRedirect=
goto:eof

:sleep
  ping -n %sleepInterval% 127.0.0.1 
goto:eof

:printError
  echo Command !command! failed.
goto:eof

:syntaxError
  echo Error : Mandatory argument %arg% is missing from the command line or properties file
  set errorFlag=true
goto:eof

:usage
  echo Usage:
  echo 	AgentInstall.bat
  echo 	AGENT_TYPE='Type of the agent to be installed or downloaded. The supported agent types are : cloud_agent, gateway, data_collector, apm_java_as_agent, apm_dotnet_agent and apm_nodejs_agent'
  echo 	AGENT_BASE_DIR='Agent installation directory'
  echo 	TENANT_ID='TenantID'
  echo 	AGENT_REGISTRATION_KEY='Agent registration key'
  echo 	[AGENT_PORT='Agent Port']
  echo 	[AGENT_INSTANCE_HOME='Agent instance directory']
  echo 	[GATEWAY_HOST='Gateway Host']
  echo 	[GATEWAY_PORT='Gateway Port']
  echo 	[EM_AGENT_NAME='Enterprise Manager Agent Name'^|EM_AGENT_HOME='Enterprise Manager Agent Oracle Home']
  echo 	[OMR_HOSTNAME='Oracle Management Repository Host Name']
  echo 	[OMR_PORT='Oracle Management Repository Port']
  echo 	[OMR_USERNAME='Oracle Management Repository User Name']
  echo 	[OMR_USER_PASSWORD='Oracle Management Repository Password']
  echo 	[OMR_USER_ROLE='Oracle Management Repository User Role']
  echo 	[OMR_SID='Oracle Management Repository SID'^|OMR_SERVICE_NAME='Oracle Management Repository Service Name']
  echo 	[OMR_HOST_USERNAME='Oracle Management Repository Install User Name ']
  echo 	[OMR_HOST_USER_PASSWORD='Oracle Management Repository User Password']
  echo 	[OMR_STAGE_DIR='Oracle Management Repository Staging Directory for data_collector to dump the data']
  echo 	[DATA_COLLECTOR_USERNAME='Data Collector User Name']
  echo 	[DATA_COLLECTOR_USER_PASSWORD='Data Collector User Password']
  echo  [ADDITIONAL_GATEWAYS='Additional Gateways']
  echo 	[STAGE_LOCATION='Stage Location']
  echo 	[AGENT_PROPERTIES='Agent Properties']
  echo 	[CURL_PATH='Curl Path']
  echo 	[UNZIP_PATH='Unzip Path']
  echo 	[NAMESPACE='Namespace to uniquely identify the harvested targets in Oracle Data Store']
  echo 	[-download_only='Download only the agent software']
  echo 	[-staged='Deploy the agent using the staged software.']
  echo 	[-ignoreDataCollectorPrereqs=Ignore Oracle Management Repository's credential checks.']
  echo 	[-ignorePrereqs='Ignore Prerequisite checks']
  echo 	[-help='Usage of the AgentInstall.bat script']
  echo.
  echo Description:
  echo  This script is used to deploy Gateway, Data Collector and Cloud agents
  echo.
  echo Options:
  echo 	AGENT_TYPE
  echo 		Type of agent to be installed or downloaded. The supported agent types are : cloud_agent, gateway, data_collector, apm_java_as_agent, apm_dotnet_agent and apm_nodejs_agent
  echo 	AGENT_BASE_DIR
  echo 		Location where the agent must be installed.
  echo 	TENANT_ID
  echo 		The Tenant ID
  echo 	AGENT_REGISTRATION_KEY
  echo 		The Agent Registration Key
  echo 	AGENT_PORT
  echo 		The agent port
  echo 	AGENT_INSTANCE_HOME
  echo 		The agent instance's home directory
  echo 	ORACLE_HOSTNAME
  echo 		Overrides the target hostname on which agent gateway agent is deployed
  echo 	GATEWAY_HOST
  echo 		The gateway host through which the cloud agent and data_collector communicate with Enterprise Manager Saas
  echo 	GATEWAY_PORT
  echo 		Gateway port
  echo 	EM_AGENT_NAME
  echo 		The name of the Enterprise Manager agent. The name format should be hostname:port.
  echo 	EM_AGENT_HOME
  echo 		Enterprise Manager agent Oracle home.
  echo 	OMR_HOSTNAME
  echo 		The Oracle Management Repository host name.
  echo 	OMR_PORT
  echo 		The Oracle Management Repository port.
  echo 	OMR_USERNAME
  echo 		The Oracle Management Repository user name
  echo 	OMR_USER_PASSWORD
  echo 		The Oracle Management Repository password
  echo 	DATA_COLLECTOR_USERNAME
  echo 		The Data Collector username
  echo 	DATA_COLLECTOR_USER_PASSWORD
  echo 		The Data Collector password
  echo 	NAMESPACE
  echo 		Namespace to uniquely identify the harvested targets in Oracle Data Store
  echo  ADDITIONAL_GATEWAYS
  echo    List of additional gateways for the cloud agent to upload through
  echo 	STAGE_LOCATION
  echo 		The location where the agent software must be staged
  echo 	AGENT_PROPERTIES
  echo 	  Property file containing the list of agent properties that need to be set during deployment.	
  echo 	CURL_PATH
  echo 		The location of the CURL binary files
  echo 	UNZIP_PATH
  echo 		The location of the Unzip binary files
  echo 	-download_only
  echo 		Downloads and stages the software without installing it.
  echo 	-staged
  echo 		Use the staged software for deploying the agent
  echo 	-help
  echo 		Usage of the AgentInstall.bat script
  echo.
  echo Examples:
  echo 	C:\AgentInstall.bat AGENT_TYPE=gateway AGENT_BASE_DIR=C:\gateway_agent TENANT_ID=TestTenant1 AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL AGENT_PORT=1830
  echo 	Deploys a gateway agent using the specified inputs
  echo.
  echo 	C:\AgentInstall.bat AGENT_TYPE=cloud_agent AGENT_BASE_DIR=C:\cloud_agent TENANT_ID=TestTenant1 GATEWAY_HOST=example.com GATEWAY_PORT=1831
  echo 	AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL EM_AGENT_NAME=example1.com:3872 AGENT_PORT=1831
  echo 	Deploys a cloud agent using the specified inputs
  echo.
  echo 	C:\AgentInstall.bat AGENT_TYPE=data_collector AGENT_BASE_DIR=C:\data_collector_agent TENANT_ID=TestTenant1 GATEWAY_HOST=example.com GATEWAY_PORT=1830
  echo 	AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL DATA_COLLECTOR_USER_PASSWORD=welcome1 OMR_USER_PASSWORD=welcome1 OMR_USERNAME=sys OMR_HOSTNAME=example1.com
  echo 	OMR_PORT=1521 OMR_SERVICE_NAME=omr.service.com DATA_COLLECTOR_USERNAME=datacollector OMR_HOST_USERNAME=user1 OMR_HOST_USER_PASSWORD=welcome1 OMR_STAGE_DIR=C:\stage
  echo 	OMR_USERNAME=system OMR_HOSTNAME=example2.com OMR_PORT=1521 OMR_SID=orcl AGENT_PORT=1832 
  echo 	Deploys a data_collector agent using the specified inputs
  echo.
  echo 	C:\AgentInstall.bat AGENT_TYPE=apm_java_as_agent STAGE_LOCATION=C:\apm_java_software -download_only AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL
  echo 	Downloads the APM Java agent installer
  echo.
  echo 	C:\AgentInstall.bat AGENT_TYPE=apm_dotnet_agent STAGE_LOCATION=C:\apm_dotnet_software -download_only AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL
  echo 	Downloads the APM Dot Net Agent installer
  echo.
  echo 	C:\AgentInstall.bat AGENT_TYPE=apm_nodejs_agent STAGE_LOCATION=C:\apm_nodejs_software -download_only AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL
  echo 	Downloads the APM Node.js Agent installer
goto:eof

:halt
  endlocal
  call :haltHelper 2> nul
goto:eof

:haltHelper
  ()
goto:eof
endlocal

