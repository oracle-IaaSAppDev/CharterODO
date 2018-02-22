# Enable host monitoring with JSON template
omcuser = node.default['omc']['user']
omcgroup = node.default['omc']['group']
json = node.default['omc']['json_dir'] +'/host.json'
agent_base_dir = node.default['omc']['agent_base_dir']

template "#{json}" do
  user "#{omcuser}"
  group "#{omcgroup}"
  source 'host_mon.erb'
  variables({ :hosttype => 'omc_host_linux',
              :hostname =>  node['hostname'],
              :campaign => node.default['campaign_name'] 
  	 })
  notifies :run, 'execute[call_omcli_host_agent]'
end

execute 'call_omcli_host_agent' do
  cwd "#{agent_base_dir}/agent_inst/bin"
  user "#{omcuser}"
  group "#{omcgroup}"
  command "./omcli update_entity agent #{json}"
  action :nothing
  ignore_failure true
end

