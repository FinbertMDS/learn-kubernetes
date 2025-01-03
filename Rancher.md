# Install Rancher
docker run -d --restart=unless-stopped \
    --name rancher \
    -p 80:80 -p 443:443 \
    --privileged \
    -v /opt/rancher:/var/lib/rancher \
    rancher/rancher:latest

## Get rancher password
docker logs rancher 2>&1 | grep "Bootstrap Password:"