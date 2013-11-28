Install Chef 
===
Simply run the following commands inside the repo folder:
```sh
bundle install 
librarian-chef install 
```

Setup configuration
===
Use the command:
```
knife solo data bag edit redis master             # edit config providing master's address and port
```
After the editor (default system editor or specified in `$EDITOR` will be opened). You'll need to point out master's address and port in json format.
```json
  {
    "id": "master",
    "address": "<master-address>",
    "port": 6379
  }
```
That's it. All is done.

Deploy
===

Use following commands to deploy appropriate configuration: 
```sh
knife solo bootstrap -i .chef/keypair.pem root@<master-address>   nodes/redis-master.json
knife solo bootstrap -i .chef/keypair.pem root@<slave-address>    nodes/redis-slave.json
knife solo bootstrap -i .chef/keypair.pem root@<sentinel-address> nodes/redis-sentinel.json
```
