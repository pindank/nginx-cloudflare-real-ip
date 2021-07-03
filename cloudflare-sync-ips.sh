#!/bin/bash

CLOUDFLARE_FILE_PATH=/tmp/cloudflare
ALLOW_FROM_CF=/tmp/allow-only-from-cf

echo "#Cloudflare" > $CLOUDFLARE_FILE_PATH;
echo "#Cloudflare" > $ALLOW_FROM_CF;
echo "" >> $CLOUDFLARE_FILE_PATH;
echo "" >> $ALLOW_FROM_CF;

echo "# - IPv4" >> $CLOUDFLARE_FILE_PATH;
echo "# - IPv4" >> $ALLOW_FROM_CF;
for i in `curl https://www.cloudflare.com/ips-v4`; do
    echo "set_real_ip_from $i;" >> $CLOUDFLARE_FILE_PATH;
    echo "allow $i;" >> $ALLOW_FROM_CF;
done

echo "" >> $CLOUDFLARE_FILE_PATH;
echo "" >> $ALLOW_FROM_CF;
echo "# - IPv6" >> $CLOUDFLARE_FILE_PATH;
echo "# - IPv6" >> $ALLOW_FROM_CF;
for i in `curl https://www.cloudflare.com/ips-v6`; do
    echo "set_real_ip_from $i;" >> $CLOUDFLARE_FILE_PATH;
    echo "allow $i;" >> $ALLOW_FROM_CF;
done

echo "" >> $CLOUDFLARE_FILE_PATH;
echo "" >> $ALLOW_FROM_CF;
echo "real_ip_header CF-Connecting-IP;" >> $CLOUDFLARE_FILE_PATH;
echo "deny all;" >> $ALLOW_FROM_CF;

#test configuration and reload nginx
sudo mv /tmp/allow-only-from-cf /etc/nginx/allow-only-from-cf
sudo mv /tmp/cloudflare /etc/nginx/cloudflare
sudo nginx -t && sudo systemctl reload nginx
