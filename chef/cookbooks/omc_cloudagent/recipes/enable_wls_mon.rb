# Enable wls monitoring with JSON template
omcuser = node.default['omc']['user']
omcgroup = node.default['omc']['group']
json = node.default['omc']['json_dir'] +'/wls_mon.json'
creds_json = node.default['omc']['json_dir'] + '/wls_creds.json'
agent_base_dir = node.default['omc']['agent_base_dir']

template "#{creds_json}" do
  user "#{omcuser}"
  group "#{omcgroup}"
  source 'wls_creds.erb'
  variables({ :username => 'weblogic',
	      :password => 'Password123' })
end
template "#{json}" do
  user "#{omcuser}"
  group "#{omcgroup}"
  source 'wls_mon.erb'
  variables({ :domainname => 'se-osm',
	      :timezone => 'MDT',
	      :port => '7001',
	      :protocol => 't3' })
end

execute 'call_omcli_wls_agent' do
  cwd "#{agent_base_dir}/agent_inst/bin"
  user "#{omcuser}"
  group "#{omcgroup}"
  command "./omcli add_entity agent #{json} -credential_file #{creds_json}"
  action :run
end

