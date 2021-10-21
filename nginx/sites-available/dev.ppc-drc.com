server {
        listen 80;

        root /home/ubuntu/static/app;
        index index.html;

        server_name dev.ppc-drc.com www.dev.ppc-drc.com;

        location / {
                try_files $uri $uri/ /index.html;
                return 301 https://admin.dev.ppc-drc.com;
        }

        location /api {
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_pass http://localhost:3333;
        }

        location /files {
                proxy_pass http://localhost:3333;
        }

        location /socket {
                proxy_pass http://localhost:3333;
        }
}
