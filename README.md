# IBZ TI18W Dockerized LEMP deployment
This project allows deploying docker containers with a self-contained LEMP stack (+[adminer.php](https://www.adminer.org/)) to a shared host. This way, PHP+MySQL projects can be developed in a repository and are automatically deployed to a host, without having to run all the PHP code (and its potential system / file interactions) on the host system.

In practial use, we clone this repository to the "prod" host for each project, set up its `/project` dir, build the container (once), and run it via the systemd service file pasted below. It assumes the projects to be stored in `/opt/ibzti18w/<ProjectDirectory>`.

This repository does **not** provide a finished project. It could give you an idea of how to build an isolated LEMP container and deploy it to an existing nginx webhost, though.

-----

### Docker setup
```
# Build containers
docker build -t ibzproject .

# Start container manually
docker run --rm --name ibzti18wtsa1 \
  -p 8080:80 \
  -v $(pwd)/project:/usr/share/nginx/html/ibzti18w/<ProjectDirectory>project \
  -v $(pwd)/database:/var/lib/mysql \
  -e HOOK_SECRET=<HookSecret> \
  -it ibzproject bash
```

### Git Setup
Inside this cloned repository, navigate to `./project` and...
```
git init
git remote add origin <https-origin>
```

### Service setup
* `<GroupName>` is a descriptive name. -  e.g. "Sven/Andre"
* `<ProjectDirectory>` is the subdirectory where the project lies. - e.g. "wt-sa-1"
* `<HookSecret>` secret used by GitHub webhook

Store as `docker_ibzti18w_<ProjectDirectory>.service`
```
[Unit]
Description=IBZ TI18 WebTech <GroupName>
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=60
RestartSec=60
Restart=always
WorkingDirectory=/opt/ibzti18w/<ProjectDirectory>
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStart=/usr/bin/docker run --name %n \
  -p 26661:80 \
  -v /opt/ibzti18w/<ProjectDirectory>/project:/usr/share/nginx/html/ibzti18w/<ProjectDirectory>/project \
  -v /opt/ibzti18w/<ProjectDirectory>/database:/var/lib/mysql \
  -e HOOK_SECRET=<HookSecret> \
  ibzproject
ExecStop=/usr/bin/docker stop %n

[Install]
WantedBy=multi-user.target
```

### Problems
The projects are exposed as subdirectories from the host using the following nginx configuration:

```
location ~* /ibzti18w/project1/(?<path>.*$) {
    set $path "ibzti18w/project1/${path}";
    set $upstream "http://127.0.0.1:26661/";
    proxy_pass $upstream$path$is_args$args;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
}
```

This works but requires the `/ibzti18w/project1` directory structure to be replicated inside the container, since otherwhise PHP will use the wrong base path for redirects. I'm sure there's some way to fix this by configuration but I could not figure it out in time.
