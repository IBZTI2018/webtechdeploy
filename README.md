# IBZ TI18W Dockerized LAMP deployment

### Docker setup
```
# Build containers
docker build -t ibzproject .

# Start container manually
docker run --rm --name ibzti18wtsa1 \
  -p 8080:80 \
  -v $(pwd)/project:/usr/share/nginx/html/project \
  -v $(pwd)/database:/var/lib/mysql \
  -it ibzproject bash
```

### Database setup (automated by entrypoint.sh)
```
mysql
> CREATE USER 'project'@'localhost' IDENTIFIED BY '...';
> FLUSH PRIVILEGES;
```

### Service setup
* `<GroupName>` is a descriptive name. -  e.g. "Sven/Andre"
* `<GroupDirectory>` is the subdirectory where the project lies. - e.g. "wt-sa-1"

Store as `docker_ibzti18w_<GroupDirectory>.service`
```
[Unit]
Description=IBZ TI18 WebTech <GroupName>
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=60
RestartSec=60
Restart=always
WorkingDirectory=/opt/ibzti18w/<GroupDirectory>
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStart=/usr/bin/docker run --name %n \
  -p 26661:80 \
  -v /opt/ibzti18w/<GroupDirectory>/project:/usr/share/nginx/html/ibzti18w/<GroupDirectory>/project \
  -v /opt/ibzti18w/<GroupDirectory>/database:/var/lib/mysql \
  -e HOOK_SECRET=ibzti18 \
  ibzproject
ExecStop=/usr/bin/docker stop %n

[Install]
WantedBy=multi-user.target
```
