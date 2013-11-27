service "redismaster" do
  action [:start, :stop, :restart, :enable, :disable]
end

service "redisslave" do
  action [:start, :stop, :restart, :enable, :disable]
end
