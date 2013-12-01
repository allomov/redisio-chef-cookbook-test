
redis_master_config = Chef::DataBagItem.load('redis', 'master')
default_port = redis_master_config['port']
sentinel_port = 26379

# Reject packets other than those explicitly allowed
simple_iptables_policy "INPUT" do
  policy "DROP"
end

# Allow SSH
simple_iptables_rule "ssh" do
  rule "--proto tcp --dport 22"
  jump "ACCEPT"
end

# Allow Redis
simple_iptables_rule "redis" do
  rule "--proto tcp --dport #{default_port}"
  jump "ACCEPT"
end

# Allow Redis Sentinel
simple_iptables_rule "redis-sentinel" do
  rule "--proto tcp --dport #{sentinel_port}"
  jump "ACCEPT"
end
