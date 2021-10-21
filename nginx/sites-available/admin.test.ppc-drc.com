server {
        listen 80;

        root /home/ubuntu/static/admin;
        index index.html;

        server_name admin.test.ppc-drc.com www.admin.test.ppc-drc.com;

        location / {
                try_files $uri $uri/ /index.html;
        }
}
