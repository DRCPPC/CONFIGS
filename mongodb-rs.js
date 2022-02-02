// Init replica set
rs.initiate({
  _id: "rs0",
  members: [
    {
      _id: 0,
      host: "mongodb-a"
    },
    {
      _id: 1,
      host: "mongodb-b"
    },
    {
      _id: 2,
      host: "mongodb-c"
    }
  ]
});

// Set priority
cfg = rs.conf();
cfg.members[0].priority = 2;
cfg.members[1].priority = 1;
cfg.members[2].priority = 0;
rs.reconfig(cfg);

// Generate random password
// $ openssl rand -hex 32

// Create user
db.createUser({
  user: "admin",
  pwd: "password",
  roles: [{ role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase"]
});

db.createUser({
  user: "developer",
  pwd: "password",
  roles: [{ role: "readWrite", db: "dev_ppcDB" }]
});

db.createUser({
  user: "server",
  pwd: "password",
  roles: [{ role: "readWrite", db: "ppcDB" }]
});

// Update user
db.updateUser("server", {
  pwd: "password", // Change password
  roles: [{ role: "readWrite", db: "ppcDB" }] // Change roles
});
