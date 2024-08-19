// ************************************************************************
// mongo shell
// 
// use admin
// ************************************************************************

db.auth({ user: 'USER', pwd: 'PASSWORD' });
//{ ok: 1 }

db.serverStatus()
// (超級大一包...)

db.serverStatus().connections
//{
//  current: 180,
//  available: 620384,
//  totalCreated: 4097,
//  active: 12,
//  threaded: 180,
//  exhaustIsMaster: 0,
//  exhaustHello: 11,
//  awaitingTopologyChanges: 11
//}

// ========== Create User ==========
db.createUser(
  {
    user: "monitoring",
    pwd: "password123",
    roles: [
      { role: "", db: "db1" },
    ]
  }
)