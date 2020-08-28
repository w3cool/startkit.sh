# init docker registry for air gap etc.
docker run -d \
    -p 5000:5000 \
    -v /opt/docker-registry:/var/lib/registry \
    --restart=always \
    --name registry registry


