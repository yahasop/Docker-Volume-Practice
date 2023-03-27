<h1>Webpage for a docker volume practice</h1>

- Using docker, pull the latest nginx image: ***docker pull nginx:latest***
- Create a volume named website: ***docker volume create website***
- Using docker inspect check where the volume is: ***docker volume inspect website***

- Clone this repository into your home directory: ***git clone https://github.com/yahasop/webpage.git***
- Copy the contents of this repo into the path of the created Docker volume. Use sudo as it is a protected path: ***sudo cp /home/"your-user"/website/* /var/lib/docker/volumes/website/_data/***
- (Optional) We can become root user to navigate to the path to check if the files were correctly copied: ***sudo -i***

- Run a test container named webpagetest in dettached mode exposed to the port 80 and using the nginx image: ***docker run -d --rm --name webpagetest -p 80:80 nginx:latest***
- You now should see a webpage with an Nginx message in our localhost or iphost, in port 80 in any web browser.
- Stop the webpagetest container and since we flagged it to be removed after being stoppped, it will be pruned automatically.

- Run a container named webpage in dettached mode, exposed to the port 80, using the nginx image  attaching the website volume to the Nginx webserver path: ***docker run -d --name webpage -p 80:80 -v website:/usr/share/nginx/html:ro***
- (Optional) We can get into the container to check if the files are copied into the Nginx path: ***docker exec -it webpage bash*** and then navigate to the path
- You now should see a webpage with a message and a docker picture in our localhost or iphost, in port 80 in any web browser.
