# IBZ TI18W Dockerized LAMP deployment

Docker setup
```
# Build containers
docker build -t ibzproject .

# Start container
docker run --rm --name ibzti18wtsa1 \
  -p 8080:80 \
  -v $(pwd)/project:/usr/share/nginx/html/project \
  -v $(pwd)/database:/var/lib/mysql \
  -it ibzproject bash
```

Database setup (automated by entrypoint.sh)
```
mysql
> CREATE USER 'project'@'localhost' IDENTIFIED BY '...';
> FLUSH PRIVILEGES;
```

Service setup
```
tbd...
```
