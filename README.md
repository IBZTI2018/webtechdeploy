# IBZ TI18W Dockerized LEMP deployment
This projects assumes that [nginx-proxy](https://github.com/jwilder/nginx-proxy) is running on your deployment host. It will create a self-container docker container with a LEMP stack (and [adminer.php](https://www.adminer.org/)) inside, that allows deploying a PHP+MySQL application directly via GitHub hooks. The intent of this project is to allow deployment of projects independent from the target host, so that they cannot interfere with the host system.

----

## Installation
#### 1. Install nginx-proxy
Install and configure [nginx-proxy](https://github.com/jwilder/nginx-proxy) on your host system.

#### 2. Clone this repository for each project
Clone this repository, navigate into its directory and build the docker container via `docker build -t webtechdeploy .`

#### 3. Set up your local repository
Navigate into the `./project` directory inside this repository and set up your git repository. This assumes your repository is publically available.
```
git init
git remote add origin <https-origin>
```

#### 4. Create a service for the project
Create a systemd service for the project with a file like the following:
* `<your-project-directory>` is the directory of this repository on the host. e.g `/opt/webtechdeploy`
* `<your-deploy-secret>` secret used by your GitHub deploy webhook (specify any)
* `<your-project-domain>` subdomain your project should use ([see here](https://github.com/jwilder/nginx-proxy#usage))

```
[Unit]
Description=<your-project-name>
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=60
RestartSec=60
Restart=always
WorkingDirectory=<your-project-directory>
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStart=/usr/bin/docker run --name %n \
  -p 26661:80 \
  -v <your-project-directory>/project:/usr/share/nginx/html \
  -v <your-project-directory>/database:/var/lib/mysql \
  -e HOOK_SECRET=<your-deploy-secret> \
  -e VIRTUAL_HOST=<your-project-domain> \
  ibzproject
ExecStop=/usr/bin/docker stop %n

[Install]
WantedBy=multi-user.target
```

Store for example as `webtechdeploy-project1.service` in `/opt/systemd/system`.

#### 5. Set up your GitHub webhook
Set up your GitHub repository to trigger a webhook on each push. Use `https://<your-project-domain>/~admin/webhook.php` as URL and your `<your-deploy-secret>` as secret. 
