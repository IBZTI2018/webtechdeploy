# IBZ TI18W Dockerized LAMP deployment

Docker setup
```
# Build containers
docker build -t ibzproject .

# Start container
docker run --rm --name ibzrunner \
  -p 8080:80 \
  -v $(pwd)/project:/usr/share/nginx/html/project \
  -v $(pwd)/database:/var/lib/mysql \
  -it ibzproject bash
```

Database setup
```
mysql
> CREATE USER 'project'@'localhost' IDENTIFIED BY '...';
```

Service setup
```
tbd...
```
