##
# Cookbook Name:: ODO
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# hostsfile_entry "#{node['ipaddress']}" do
#   hostname  'odo72.localdomain'
# end

template "/etc/hosts" do
            cookbook "ODO"
            source "hosts.erb"
            owner 'root'
            group 'root'
            mode "00755"
            variables ({
                :priv_ip => "#{node['ipaddress']}",
                :name => "#{node['hostname']}"

                })
    action :create
end

execute "cleanup" do
  #Chef::Log.info('now trying create instance')
  user "root"
  group "root"
  command <<-EOH
            rm -f /u01/app/oracle/product/fmw11g/user_projects/domains/odo72/servers/AdminServer/logs/AdminServer.out
            rm -f /u01/app/oracle/product/fmw11g/user_projects/domains/odo72/servers/ASAP_MS1/logs/ASAP_MS1.out
            rm -f /u01/app/oracle/product/fmw11g/user_projects/domains/odo72/servers/OSM_MS1/logs/OSM_MS1.out
            touch /home/oracle/clean
          EOH
  not_if {FileTest.exist?("/home/oracle/clean") }
  action :run
end

execute "randomizer" do
  #Chef::Log.info('now trying create instance')
  user "root"
  group "root"
  command <<-EOH
            rngd -r /dev/urandom -o /dev/random -t 1
            touch /home/oracle/random
          EOH
  notifies :run, 'execute[dbstart]', :immediate
  not_if {FileTest.exist?("/home/oracle/random") }
  action :run
end

execute "dbstart" do
  #Chef::Log.info('now trying create instance')
  user "oracle"
  group "oinstall"
  environment ({'ORACLE_BASE'=> '/u01/app/oracle',
                        'ORACLE_HOME' => '/u01/app/oracle/product/11.2.0/db_1',
                        'ORACLE_HOSTNAME' => 'odo72.localdomain',
                        'ORACLE_UNQNAME' => 'DB11G',
                        'LD_LIBRARY_PATH' => '/u01/app/oracle/product/11.2.0/db_1/lib:/lib:/usr/lib',
                        'WLS_HOME' => '/u01/app/oracle/product/fmw11g/wlserver_10.3',
                        'PATH'=>'/u01/app/oracle/jdk1.6.0_151/bin:/u01/app/oracle/product/11.2.0/db_1/bin:/usr/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/home/oracle/bin',
                        'JAVA_HOME'=>'/u01/app/oracle/jdk1.6.0_151',
                        'HOME' => '/home/oracle',
                        'USER' => 'oracle',
                        'LOGNAME' => 'oracle'
                        })
  command '/u01/app/oracle/product/11.2.0/db_1/bin/dbstart /u01/app/oracle/product/11.2.0/db_1'
  not_if 'ps -ef | grep "[o]ra_pmon_DB11G"'
  notifies :run, 'execute[testdb]'
  action :nothing
end


execute "testdb" do
        user "oracle"
  group "oinstall"
  environment ({'ORACLE_BASE'=> '/u01/app/oracle',
                        'ORACLE_HOME' => '/u01/app/oracle/product/11.2.0/db_1',
                        'ORACLE_HOSTNAME' => 'odo72.localdomain',
                        'ORACLE_UNQNAME' => 'DB11G',
                        'LD_LIBRARY_PATH' => '/u01/app/oracle/product/11.2.0/db_1/lib:/lib:/usr/lib',
                        'WLS_HOME' => '/u01/app/oracle/product/fmw11g/wlserver_10.3',
                        'PATH'=>'/u01/app/oracle/jdk1.6.0_151/bin:/u01/app/oracle/product/11.2.0/db_1/bin:/usr/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/home/oracle/bin',
                        'JAVA_HOME'=>'/u01/app/oracle/jdk1.6.0_151',
                        'HOME' => '/home/oracle',
                        'USER' => 'oracle',
                        'LOGNAME' => 'oracle'
                        })
  #command 'echo db is up'
  command 'source /home/oracle/.bash_profile && source /home/oracle/.bashrc && lsnrctl status | grep DB11G | grep READY'
  retries 5
  retry_delay 10
  action :nothing
  notifies :run, 'execute[startas]'
end


execute "startas" do
  user "oracle"
  group "oinstall"
  cwd '/home/oracle'
  environment ({
        'ORACLE_BASE'=> '/u01/app/oracle',
        'ORACLE_HOME' => '$ORACLE_BASE/product/11.2.0/db_1',
        'ORACLE_HOSTNAME' => 'odo72.localdomain',
        'ORACLE_UNQNAME' => 'DB11G',
        'LD_LIBRARY_PATH' => '/u01/app/oracle/product/11.2.0/db_1/lib:/lib:/usr/lib',
        'WLS_HOME' => '/u01/app/oracle/product/fmw11g/wlserver_10.3',
        'PATH'=>'/u01/app/oracle/jdk1.6.0_151/bin:/u01/app/oracle/product/11.2.0/db_1/bin:/usr/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/home/oracle/bin',
        'JAVA_HOME'=>'/u01/app/oracle/jdk1.6.0_151',
        'MW_HOME' => '/u01/app/oracle/product/fmw11g',
        'HOME' => '/home/oracle',
        'USER' => 'oracle',
        'LOGNAME' => 'oracle'
        })
  command "nohup /u01/app/oracle/product/fmw11g/user_projects/domains/odo72/bin/startWebLogic.sh > /u01/app/oracle/product/fmw11g/user_projects/domains/odo72/servers/AdminServer/logs/AdminServer.out 2>&1 &"
  action :nothing
notifies :run, 'execute[testas]'
end

execute "testas" do
        user "oracle"
  group "oinstall"
  command 'cat /u01/app/oracle/product/fmw11g/user_projects/domains/odo72/servers/AdminServer/logs/AdminServer.out | grep RUNNING'
  Chef::Log.debug "as not up"
  retries 8
  retry_delay 10
  action :nothing
  notifies :run, 'execute[startosm]'
  notifies :run, 'execute[startasap]'
end

execute "startosm" do
  user "oracle"
  group "oinstall"
  cwd '/home/oracle'
  environment ({
        'ORACLE_BASE'=> '/u01/app/oracle',
        'ORACLE_HOME' => '$ORACLE_BASE/product/11.2.0/db_1',
        'ORACLE_HOSTNAME' => 'odo72.localdomain',
        'ORACLE_UNQNAME' => 'DB11G',
        'LD_LIBRARY_PATH' => '/u01/app/oracle/product/11.2.0/db_1/lib:/lib:/usr/lib',
        'WLS_HOME' => '/u01/app/oracle/product/fmw11g/wlserver_10.3',
        'PATH'=>'/u01/app/oracle/jdk1.6.0_151/bin:/u01/app/oracle/product/11.2.0/db_1/bin:/usr/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/home/oracle/bin',
        'JAVA_HOME'=>'/u01/app/oracle/jdk1.6.0_151',
        'MW_HOME' => '/u01/app/oracle/product/fmw11g',
        'HOME' => '/home/oracle',
        'USER' => 'oracle',
        'LOGNAME' => 'oracle'
        })
  command "nohup /u01/app/oracle/product/fmw11g/user_projects/domains/odo72/bin/startManagedWebLogic.sh \"OSM_MS1\" \"http://odo72.localdomain:7001\" > /u01/app/oracle/product/fmw11g/user_projects/domains/odo72/servers/OSM_MS1/logs/OSM_MS1.out 2>&1 &"
  not_if 'ps -ef | grep  "[O]SM_MS1"'
  action :nothing
  notifies :run, 'execute[testosm]'
end

execute "startasap" do
  user "oracle"
  group "oinstall"
  cwd '/home/oracle'
  environment ({
        'ORACLE_BASE'=> '/u01/app/oracle',
        'ORACLE_HOME' => '/u01/app/oracle/product/11.2.0/client32',
        'ORACLE_HOSTNAME' => 'odo72.localdomain',
        'ORACLE_UNQNAME' => 'DB11G',
        'LD_LIBRARY_PATH' => '/u01/app/oracle/product/11.2.0/db_1/lib:/lib:/usr/lib',
        'WLS_HOME' => '/u01/app/oracle/product/fmw11g/wlserver_10.3',
        'PATH'=>'/u01/app/oracle/jdk1.6.0_151/bin:/u01/app/oracle/product/11.2.0/db_1/bin:/usr/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/home/oracle/bin',
        'JAVA_HOME'=>'/u01/app/oracle/jdk1.6.0_151',
        'MW_HOME' => '/u01/app/oracle/product/fmw11g',
        'HOME' => '/home/oracle',
        'USER' => 'oracle',
        'LOGNAME' => 'oracle'
        })
  command <<-EOH
                env > asap
                nohup /u01/app/oracle/product/fmw11g/user_projects/domains/odo72/bin/startManagedWebLogic.sh \"ASAP_MS1\" \"http://odo72.localdomain:7001\" > /u01/app/oracle/product/fmw11g/user_projects/domains/odo72/servers/ASAP_MS1/logs/ASAP_MS1.out 2>&1 &
                EOH
  action :nothing
  notifies :run, 'execute[testasap]'
end

execute "testasap" do
        user "oracle"
  group "oinstall"
  command 'cat /u01/app/oracle/product/fmw11g/user_projects/domains/odo72/servers/ASAP_MS1/logs/ASAP_MS1.out | grep "Server started in RUNNING mode"'
  retries 15
  retry_delay 15
  action :nothing
  notifies :run, 'execute[startasapcore]'
end

execute "startasapcore" do
  user "oracle"
  group "oinstall"
  cwd '/home/oracle'
  environment ({
        'ORACLE_BASE'=> '/u01/app/oracle',
        'ORACLE_HOME' => '/u01/app/oracle/product/11.2.0/client32',
        'ORACLE_HOSTNAME' => 'odo72.localdomain',
        'ORACLE_UNQNAME' => 'DB11G',
        'LD_LIBRARY_PATH' => '/u01/app/oracle/product/11.2.0/db_1/lib:/lib:/usr/lib',
        'WLS_HOME' => '/u01/app/oracle/product/fmw11g/wlserver_10.3',
        'PATH'=>'/u01/app/oracle/jdk1.6.0_151/bin:/u01/app/oracle/product/11.2.0/db_1/bin:/usr/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/home/oracle/bin',
        'JAVA_HOME'=>'/u01/app/oracle/jdk1.6.0_151',
        'MW_HOME' => '/u01/app/oracle/product/fmw11g',
        'HOME' => '/home/oracle',
        'USER' => 'oracle',
        'LOGNAME' => 'oracle'
        })
  command  <<-EOH
                source /home/oracle/.bash_profile
                source /home/oracle/.bashrc
                source /home/oracle/ASAP72061/Environment_Profile
                start_asap_sys -d
                EOH

  not_if 'source /home/oracle/.bash_profile && source /home/oracle/.bashrc &&  source /home/oracle/ASAP72061/Environment_Profile && status | grep SRP_AS72'
  action :nothing
end

execute "testosm" do
  user "oracle"
  group "oinstall"
  command 'cat /u01/app/oracle/product/fmw11g/user_projects/domains/odo72/servers/OSM_MS1/logs/OSM_MS1.out | grep "All Application Services Are Available"'
  retries 15
  retry_delay 15
  action :nothing
  notifies :run, 'execute[startasapcore]'
end

