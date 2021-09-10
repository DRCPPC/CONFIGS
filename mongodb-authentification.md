# Authentification

Authentication is the process of verifying the identity of a client. When access control, i.e. authorization, is enabled, MongoDB requires all clients to authenticate themselves in order to determine their access.

Although `authentication` and authorization are closely connected, authentication is distinct from authorization. Authentication verifies the identity of a user; authorization determines the verified user's access to resources and operations.

## Create admin user.

```mongo
> use admin
> db.createUser(
  {
    user: "admin",
    pwd: "password",
    roles: [
      { role: "userAdminAnyDatabase", db: "admin" },
      "readWriteAnyDatabase"
    ]
  }
)
```

## Enabling authentication.

Open the `mongod.conf` file and add the following line

```bash
nano /etc/mongod.conf
```

```bash
security:
    authorization: enabled
```

Then restart the mongod process.

```bash
service mongod restart
```

### Generate a key. (Replica Set)

```bash
mkdir -p /etc/mongodb/keys/
openssl rand -base64 756 > /etc/mongodb/keys/mongo-key
chmod 400 /etc/mongodb/keys/mongo-key
chown -R mongodb:mongodb /etc/mongodb
```

Copy the key to all the nodes, in the `/etc/mongodb/keys/` directory.

Open the `mongod.conf` file and add the following line `keyFile: /etc/mongodb/keys/mongo-key` on each node.

```bash
security:
    authorization: enabled
    keyFile: /etc/mongodb/keys/mongo-key
```

### Test authentification.

Go to the MongoDB shell.

```bash
mongo
```

List the databases, or show users.

```mongo
> show dbs
> use admin
switched to db admin
> show users
uncaught exception: Error: command usersInfo requires authentication :
_getErrorWithCode@src/mongo/shell/utils.js:25:13
DB.prototype.getUsers@src/mongo/shell/db.js:1659:15
shellHelper.show@src/mongo/shell/utils.js:914:9
shellHelper@src/mongo/shell/utils.js:819:15
@(shellhelp2):1:1
```

It will return an empty list, return an error in case of show users.
Authenticate with the user `admin` and password `password`, then try angaing to list the databases.

```mongo
> use admin
switched to db admin
> db.auth("admin", "password")
> 1
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
> show users
{
        "_id" : "admin.admin",
        "userId" : UUID("5d5bc116-b6d2-4b0a-a40f-c69be490f82a"),
        "user" : "admin",
        "db" : "admin",
        "roles" : [
                {
                        "role" : "userAdminAnyDatabase",
                        "db" : "admin"
                },
                {
                        "role" : "readWriteAnyDatabase",
                        "db" : "admin"
                }
        ],
        "mechanisms" : [
                "SCRAM-SHA-1",
                "SCRAM-SHA-256"
        ]
}
>
```

Authentication on connect

```bash
mongo --port 27017  --authenticationDatabase "admin" -u "admin" -p "password"
```

```mongo
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
```

By default, it will check the user in the `admin` database, the default port `27017` and the default host `localhost`.
So we can only -u and -p to connect to the database.

```bash
mongo -u "admin" -p "password"
```

### Change the user password.

```bash
mongo
> use admin
switched to db admin
> db.auth("admin", "password")
1
> db.changeUserPassword("admin", "123456")
> db.auth("admin", "123456")
> 1
```

### Change the user name.

```bash
mongo
> use admin
switched to db admin
> db.auth("admin", "123456")
1
> db.changeUserName("admin", "admin2")
> db.auth("user", "123456")
> 1
```

Note: Oups The user name can not be changed. L🤣L

Instead create a new user with the new name, and delete the old one.

```mongo
> db.dropUser("admin")
```

### Update the user roles.

```bash
mongo
> use admin
switched to db admin
> db.auth("admin", "123456")
1
> db.updateUser("b2b", { roles: [ { role: "readWrite", db: "chatDB" } ] })
> db.auth("admin", "123456")
> 1
```
