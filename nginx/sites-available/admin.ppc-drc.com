server {
        listen 80;

        root /home/ubuntu/static/admin;
        index index.html index.htm index.nginx-debian.html;

        server_name admin.ppc-drc.store www.admin.ppc-drc.store;

        location / {
                try_files $uri $uri/ /index.html;
        }
}