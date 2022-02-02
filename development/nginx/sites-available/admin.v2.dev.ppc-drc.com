server {
        listen 80;

        root /home/ubuntu/static/admin;
        index index.html;

        server_name admin.v2.dev.ppc-drc.com;

        location / {
                try_files $uri $uri/ /index.html;
        }

        location /api {
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_pass http://localhost:3320;
        }

        location /files {
                proxy_pass http://localhost:3320;
        }

        location /socket {
                proxy_pass http://localhost:3320;
        }

}
