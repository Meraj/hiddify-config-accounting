apt-get install -y nginx certbot python3-certbot-nginx python3-pip
pip3 install pip pyopenssl --upgrade

# systemctl stop nginx
# pkill -9 nginx


rm /etc/nginx/sites-available/default
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/nginx.conf
ln -s $(pwd)/nginx.conf /etc/nginx/nginx.conf



if [[ ! -f ssl.key || ! -f ssl.crt ]];then
	openssl req -x509 -newkey rsa:2048 -keyout ssl.key -out ssl.crt -days 3650 -nodes -subj "/C=GB/ST=London/L=London/O=Google Trust Services LLC/CN=www.google.com"
fi

# sed -i "s/listen 444 ssl;/listen 444 ssl http2;/" web.conf

ln -s $(pwd)/web.conf /etc/nginx/conf.d/web.conf
mkdir -p /etc/nginx/stream.d/ 
ln -s $(pwd)/sni-proxy.conf /etc/nginx/stream.d/sni-proxy.conf
ln -s $(pwd)/signal.conf /etc/nginx/stream.d/signal.conf

certbot --nginx --register-unsafely-without-email -d $MAIN_DOMAIN --non-interactive --agree-tos  --https-port 444 --no-redirect
# if ! grep -Fxq "stream{include /etc/nginx/stream.d/*.conf;}" /etc/nginx/nginx.conf; then
#   echo "stream{include /etc/nginx/stream.d/*.conf;}">>/etc/nginx/nginx.conf;
# fi

