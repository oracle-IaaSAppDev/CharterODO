# Enable db monitoring with JSON template
omcuser = node.default['omc']['user']
omcgroup = node.default['omc']['group']
json = node.default['omc']['json_dir'] +'/db_mon.json'
creds_json = node.default['omc']['json_dir'] + '/db_creds.json'
agent_base_dir = node.default['omc']['agent_base_dir']

template "#{creds_json}" do
  user "#{omcuser}"
  group "#{omcgroup}"
  source 'db_creds.erb'
  variables({ :username => 'moncs',
	      :password => 'moncs' })
  action :create
end

template "#{json}" do
  user "#{omcuser}"
  group "#{omcgroup}"
  source 'db_mon.erb'
  variables({ :dbname => 'se-DB11G',
	      :timezone => 'MDT',
	      :port => '1521',
	      :sid => 'DB11G' })
  notifies :run, 'execute[call_omcli_db_agent]', :delayed
  action :create
end

execute 'call_omcli_db_agent' do
  cwd "#{agent_base_dir}/agent_inst/bin"
  user "#{omcuser}"
  group "#{omcgroup}"
  command "./omcli add_entity agent #{json} -credential_file #{creds_json}"
  action :nothing
end

