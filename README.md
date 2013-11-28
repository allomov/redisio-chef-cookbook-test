Install 
===

```sh
bundle install 
librarian-chef install 
knife solo data bag edit redis master             # edit config providing master's address and port
knife solo bootstrap -i .chef/keypair.pem root@<master-address> nodes/redis-master.json
knife solo bootstrap -i .chef/keypair.pem root@<slave-1-address> nodes/redis-slave.json
knife solo bootstrap -i .chef/keypair.pem root@<slave-2-address> nodes/redis-slave.json
knife solo bootstrap -i .chef/keypair.pem root@<sentinel-address> nodes/redis-sentinel.json
```



librarian-chef install 


knife solo data bag edit redis master

master ec2-54-221-62-216.compute-1.amazonaws.com


knife solo bootstrap -i .chef/keypair.pem root@ec2-54-221-62-216.compute-1.amazonaws.com nodes/redis-master.json