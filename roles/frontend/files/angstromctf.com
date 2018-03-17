server {
	listen 443 ssl;

	server_name www.actf.co actf.co www.angstromctf.com;

	ssl_certificate /etc/letsencrypt/live/angstromctf.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/angstromctf.com/privkey.pem;
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
	ssl_ciphers HIGH:!aNULL:!MD5;

	location / {
		return 301 https://angstromctf.com$request_uri;
	}
}

server {
	listen 80;
	server_name www.actf.co actf.co www.angstromctf.com angstromctf.com;

	location / {
		return 301 https://angstromctf.com$request_uri;
	}
}

server {
	listen 443 ssl;

	ssl_certificate /etc/letsencrypt/live/angstromctf.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/angstromctf.com/privkey.pem;
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
	ssl_ciphers HIGH:!aNULL:!MDF5;

	server_name angstromctf.com;

	add_header Cache-Control no-cache;

	location /api/ {
		include proxy_params;
		rewrite ^/api(.*)$ $1 break;
		proxy_pass http://unix:/srv/djangoctf/djangoctf.sock;
	}

	location / {
		root /srv/angstromctf/dist;
	}

	location /static/ {
		alias /srv/problems/;
	}

	error_page 404 /;
}
