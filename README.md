<h1>Webpage for a Docker volume practice</h1>
In this challenge we're going to use and practice with docker volumes. They can be used to persist data and use it into several containers, even if the container is pruned. In this example we will use anonymous and named volumes.
<br></br>

**Anonymous Volume**
- Using Docker, pull the postgres image: ***docker pull postgres:12.1***
- Run a container named database1 in dettached mode: ***docker run -d --name database1 postgres:12.1***
- Run another container named database2 in dettached mode: ***docker run -d --name database2 postgres:12.1***
- To check the names of the new created volumes attached to the containers use: ***docker volume ls***
- Using docker inspect, check where the volume is in our local machine and additional info: ***docker inspect "anonymous-volume-name"***
- (Optional) An anonymous volume is automatically created when the container is created. If the container is stopped and pruned, the volume will not. To remove the anonymous volume: ***docker volume rm "anonymous-volume-name"***
<br></br>

**Named Volume**
- Create a volume named website: ***docker volume create website***
- To check the name of our created volume and if it was created: ***docker volume ls***
- To check where the path to the volume is: ***docker volume inspect website***
<br></br>

**Using named volumes**
- Using Docker, pull the latest nginx image: ***docker pull nginx:latest***
- Clone this repository into your home directory: ***git clone https://github.com/yahasop/webpage.git***
- Copy the contents of this repo into the path of the previously created Docker volume. Use sudo as it is a protected path: ***sudo cp /home/"your-user"/website/* /var/lib/docker/volumes/website/_data/***
- Run a container named webpage in dettached mode, exposed to the port 80, using the nginx image  attaching the website volume to the Nginx webserver path: ***docker run -d --name webpage -p 80:80 -v website:/usr/share/nginx/html:ro nginx:latest***
- (Optional) We can get into the container to check if the files are copied into the Nginx path: ***docker exec -it webpage bash*** and then navigate to the path.
- You now should see a webpage with a message and a docker picture in our localhost or iphost, in port 80 in any web browser.
