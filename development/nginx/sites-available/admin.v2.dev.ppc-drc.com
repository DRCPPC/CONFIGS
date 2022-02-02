server {
        listen 80;

        root /home/ubuntu/static/admin;
        index index.html;

        server_name admin.v2.dev.ppc-drc.com;

        location / {
                try_files $uri $uri/ /index.html;
        }
}
