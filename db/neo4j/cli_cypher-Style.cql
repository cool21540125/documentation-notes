:style reset

:style
node.stg {
  color: #27eb3b;
  border-color: #158020;
}
node.prd {
  color: #f16667;
  border-color: #eb2728;
}
node.RT {
  diameter: 30px;
  color: #4c8eda;
  border-color: #2870c2;
}
node.Vpc {
  diameter: 100px;
}
node.Subnet {
  diameter: 90px;
  color: #57c7e3;
  border-color: #24b3d7;
  text-color-internal: #000;
}
node.VPCE {
  diameter: 30px;
  color: #ffc454;
  border-color: #d7a013;
}
node.ALB {
  diameter: 80px;
  color: #f79767;
  border-color: #eb6828;
}
node.Ec2 {
  color: #569480;
  border-color: #447666;
}
node.ECS {
  color: #8dcc93;
  border-color: #5db665;
  text-color-internal: #000;
  caption: "{service_name}";
}
node.Lambda {
  color: #54ffe1;
  border-color: #806f3d;
  text-color-internal: #000;
}
node.TG {
  color: #d9c8ae;
  border-color: #c0a378;
  text-color-internal: #000;
}
node.SG {
  color: #da7194;
  border-color: #cc3c6c;
}
node.SgRule {
  color: #c990c0;
  border-color: #b261a5;
  caption: "{port}";
}
relationship {
  font-size: 12px;
  text-color-external: #000000;
  text-color-internal: #FFFFFF;
}
node.S3 {
  color: #9932CC;
  text-color-internal: #FFFFFF;
  caption: "S3";
}
node.RDS {
  color: #5090c9;
  diameter: 70px;
  caption: "{id}";
}
node.Cache {
  color: #fcb118;
  diameter: 70px;
  caption: "{id}";
}
node.Role {
  text-color-internal: #000;
  color: #ffeb00;
  border-color: #ff9d00;
}
