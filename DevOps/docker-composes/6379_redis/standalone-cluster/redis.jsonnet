local generateRedisConf(name, port, clusterIP, clusterPort) = {
  bind: "0.0.0.0",
  protected_mode: false,
  port: port,
  daemonize: false,
  supervised: "no",
  logfile: "",
  dir: "./",
  requirepass: std.extVar("REDISCLI_AUTH"),
  cluster-enabled: true,
  cluster-config-file: "nodes.conf",
  cluster-node-timeout: 5000,
  cluster-announce-ip: clusterIP,
  cluster-announce-port: port,
  cluster-announce-bus-port: clusterPort,
};

local redisInstances = [
  {
    name: "redis01",
    port: 6001,
    clusterIP: "172.72.72.61",
    clusterPort: 16001,
  },
  {
    name: "redis02",
    port: 6002,
    clusterIP: "172.72.72.61",
    clusterPort: 16002,
  }
];

local generateRedisConfigs() = {
  for instance in redisInstances do
    instance.name: generateRedisConf(
      instance.name,
      instance.port,
      instance.clusterIP,
      instance.clusterPort,
    ),
};

generateRedisConfigs()
