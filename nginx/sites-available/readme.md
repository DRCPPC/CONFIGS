# Nginx Configuration File

The server configuration is in the server object

    server {

    }

- listen: Is the port the server will listen on.
- server_name: Is the name of the server or the domain name.
- location: Is the location of the file to serve.
  ```
  location / {
          try_files $uri $uri/ /index.html;
  }
  ```
- index: Is the index file to serve.
- root: Is the root directory of the web server.
- access_log: Is the access log file.
- error_log: Is the error log file.
- charset: Is the character set.

The configuration file in sites-available is not directly used by Nginx.

To be served by Nginx, the configuration file must be symlinked to sites-enabled.

To link cheeda.store to sites-enabled, run:

    ln -s /etc/nginx/sites-available/cheeda.store /etc/nginx/sites-enabled/
