README 
-------
Usage:
	AgentInstall.sh/AgentInstall.bat

	AGENT_TYPE=<Type of agent to be installed. It can be cloud agent, gateway or data collector>

	AGENT_BASE_DIR=<Agent installation directory>

	[TENANT_ID=<Tenant Id>]

	[AGENT_REGISTRATION_KEY=<cloud agent registration key>]

	[AGENT_PORT=<Agent Port>]

	[AGENT_INSTANCE_HOME=<cloud agent instance directory>]

	[GATEWAY_HOST=<Gateway Host>]

	[GATEWAY_PORT=<Gateway Port>]

	[EM_AGENT_NAME=<EM Agent Name>|EM_AGENT_HOME=<EM Agent Oracle Home>]

	[OMR_HOSTNAME=<OMR Host Name>]

	[OMR_PORT=<OMR Port>]

	[OMR_USERNAME=<OMR Username>]

	[OMR_SID=<OMR SID>|OMR_SERVICE_NAME=<OMR Service Name>]

	[OMR_HOST_USERNAME=<OMS Host OS user name>]

	[OMR_STAGE_DIR=<Stage director>]

	[HARVESTER_USERNAME=<Harvester User Name>]

	[STAGE_LOCATION=<Stage Location>]

	[ADDITIONAL_PARAMETERS=<Additional Parameters>]

	[ADDITIONAL_GATEWAYS=<Additional Gateways>]

	[AGENT_PROPERTIES=<Agent Properties>]

	[CURL_PATH=<Curl Path>]

	[UNZIP_PATH=<Unzip Path>]

	[NAMESPACE=<Namespace to uniquely identify the harvested targets in ODS>]

	[-download_only=<Only download the agent software>]

	[-secureAgent=<Secures the agent and enables the agent communication in

https protocol>]

	[-staged=<Use the staged software for deploying the agent>]

	[-help=<Usage of the AgentInstall.sh script>]

Description:
        This script is used to deploy EM Saas Agents

Options:
        AGENT_TYPE
                Type of agent to be installed.It can be cloud_agent,gateway or data_collector
        AGENT_BASE_DIR
                The location where the agent needs to be installed.
        TENANT_ID
                The Tenant Id
        AGENT_REGISTRATION_KEY
                The Agent Registration Key
        AGENT_PORT
                The agent port
        AGENT_INSTANCE_HOME
                The agent instance home
        GATEWAY_HOST
                The gateway host through which the cloud_agent/data_collector communicate with EM Saas
        GATEWAY_PORT
                The gateway port
        EM_AGENT_NAME
                The EM agent name. It should be of the format hostname:port
        EM_AGENT_HOME
                The EM agent Oracle home.
        OMR_HOSTNAME
                The Oracle Management Repository host name.
        OMR_PORT
                The Oracle Management Repository port.
        OMR_USERNAME
                The Oracle Management Repository username
        OMR_USER_PASSWORD
                The Oracle Management Repository password
        HARVESTER_USERNAME
                The Harvester username
        HARVESTER_USER_PASSWORD
                The Harvester password
        NAMESPACE
                Namespace to uniquely identify the harvested targets in ODS
        STAGE_LOCATION
                The location where the agent software needs to be staged.
        ADDITIONAL_PARAMETERS
                Additional parameters
        ADDITIONAL_GATEWAYS
                Comma separated list of gateway urls.A valid gateway url will is of the form: http://host:port
        AGENT_PROPERTIES
                Comma separated list of agent properties. Example property1:value1,property2:value2
        CURL_PATH
                The location of the curl binary
        UNZIP_PATH
                The location of the unzip binary
        -download_only
                Downloads and stages the software without installing it.
        -staged
                Use the staged software for deploying the agent
        -help
                Usage of the AgentInstall.sh script

Examples: Linux/Solaris/AIX
----------------------------
        /scratch/AgentInstall.sh AGENT_TYPE=gateway AGENT_BASE_DIR=/scratch/gateway_agent AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL AGENT_PORT=1830
          Deploys a gateway agent using the specified inputs

        /scratch/AgentInstall.sh AGENT_TYPE=cloud_agent AGENT_BASE_DIR=/scratch/cloud_agent GATEWAY_HOST=example.com GATEWAY_PORT=1831
        AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL EM_AGENT_NAME=example1.com:3872 AGENT_PORT=1831
          Deploys a cloud_agent agent using the specified inputs

        /scratch/AgentInstall.sh AGENT_TYPE=data_collector AGENT_BASE_DIR=/scratch/data_collector_agent GATEWAY_HOST=example.com GATEWAY_PORT=1830 AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL 
        EM_AGENT_NAME=example1.com:3872 HARVESTER_USERNAME=EM_SAAS HARVESTER_USER_PASSWORD=xxxxx OMR_USER_PASSWORD=manager OMR_USERNAME=system OMR_HOSTNAME=example2.com OMR_PORT=1521 OMR_SID=orcl 
        NAMESPACE=myOMR AGENT_PORT=1832 OMR_HOST_USER_PASSWORD=yyyyy OMR_HOST_USERNAME=testuser OMR_STAGE_DIR=/scratch/omr_stage
         Deploys a data collector agent using the specified inputs

        /scratch/AgentInstall.sh AGENT_TYPE=apm_java_as_agent STAGE_LOCATION=/scratch/apm_java_software AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL
        Downloads the APM Java Agent installer

        /scratch/AgentInstall.sh AGENT_TYPE=apm_nodejs_agent STAGE_LOCATION=/scratch/apm_nodejs_software AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL
        Downloads the APM Node JS Agent installer

        /scratch/AgentInstall.sh AGENT_TYPE=apm_dotnet_agent STAGE_LOCATION=/scratch/apm_dotnet_software AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL
        Downloads the APM Dot Net Agent installer


Examples: Windows
------------------
        C:\AgentInstall.bat AGENT_TYPE=gateway AGENT_BASE_DIR=C:\gateway_agent AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL AGENT_PORT=1830
          Deploys a gateway agent using the specified inputs

        C:\AgentInstall.bat AGENT_TYPE=cloud_agent AGENT_BASE_DIR=C:\cloud_agent GATEWAY_HOST=example.com GATEWAY_PORT=1831
        AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL EM_AGENT_NAME=example1.com:3872 AGENT_PORT=1831
          Deploys a cloud_agent agent using the specified inputs

        C:\AgentInstall.bat AGENT_TYPE=data_collector AGENT_BASE_DIR=C:\data_collector_agent GATEWAY_HOST=example.com GATEWAY_PORT=1830 AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL 
        EM_AGENT_NAME=example1.com:3872 HARVESTER_USERNAME=EM_SAAS HARVESTER_USER_PASSWORD=xxxxx OMR_USER_PASSWORD=manager OMR_USERNAME=system OMR_HOSTNAME=example2.com OMR_PORT=1521 OMR_SID=orcl 
        NAMESPACE=myOMR AGENT_PORT=1832 OMR_HOST_USER_PASSWORD=yyyyy OMR_HOST_USERNAME=testuser OMR_STAGE_DIR=C:\omr_stage
         Deploys a data collector agent using the specified inputs

        C:\AgentInstall.sh AGENT_TYPE=apm_java_as_agent STAGE_LOCATION=C:\apm_java_software AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL
        Downloads the APM Java Agent installer

        C:\AgentInstall.bat AGENT_TYPE=apm_dotnet_agent STAGE_LOCATION=C:\apm_dotnet_software AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL
        Downloads the APM Dot Net Agent installer

        C:\AgentInstall.bat AGENT_TYPE=apm_nodejs_agent STAGE_LOCATION=C:\apm_nodejs_software AGENT_REGISTRATION_KEY=YlXrf2h0RNtVLZKeGf6q9mcDL
        Downloads the APM Node JS Agent installer
