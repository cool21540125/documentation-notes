// ==================================== Settings ====================================
:style reset

:style
node.stg {
  color: #27eb3b;
  border-color: #158020
}
node.prd {
  color: #f16667;
  border-color: #eb2728
}
node.ALB {
  color: #f79767;
  border-color: #eb6828
}
node.Ec2 {
  color: #569480;
  border-color: #447666
}
node.ECS {
  color: #8dcc93;
  border-color: #5db665;
  text-color-internal: #000
}
node.Subnet {
  color: #57c7e3;
  border-color: #24b3d7;
  text-color-internal: #000
}
node.TG {
  color: #d9c8ae;
  border-color: #c0a378;
  text-color-internal: #000
}
node.SG {
  color: #da7194;
  border-color: #cc3c6c
}



// ==================================== Query ====================================
// 查詢所有 nodes
MATCH (n)
RETURN n

// ==================================== Add ====================================

// ==================================== Update ====================================

// ==================================== Delete ====================================
// 移除沒有 label 的 nodes
MATCH (n)
WHERE size(labels(n)) =0
DETACH DELETE n
