#!/bin/bash

# 引入 peer.sh 文件
source ./peer.sh

# 设定通道名称
CHANNEL_NAME="mychannel"

# 定义组织及其对应的 Peer 数量
declare -A ORG_PEER_COUNT=(
  ["Org1"]=1  # Org1 有 1 个 Peer
  ["Org2"]=2  # Org2 有 2 个 Peer
  ["Org3"]=1  # Org3 有 1 个 Peer
)

# 定义每个组织的 Peer 设置函数
declare -A PEER_SET_FUNCTIONS=(
  ["Org1peer0"]="setPeerOrg1Peer0"  # Org1 的 Peer 0
  ["Org2peer0"]="setPeerOrg2Peer0"  # Org2 的 Peer 0
  ["Org2peer1"]="setPeerOrg2Peer1"  # Org2 的 Peer 1
  ["Org3peer0"]="setPeerOrg3Peer0"  # Org3 的 Peer 0
)

# 循环遍历每个组织，加入通道并更新 Anchor Peer
for ORG in "${!ORG_PEER_COUNT[@]}"; do
  PEER_COUNT=${ORG_PEER_COUNT[$ORG]}
  
  # 循环遍历每个 Peer 节点
  for (( i=0; i<PEER_COUNT; i++ )); do
    PEER="peer$i"
    ${PEER_SET_FUNCTIONS["${ORG}peer$i"]}

    # 加入 Peer 到通道
    echo "Joining ${PEER}.${ORG,,}.example.com to channel..."
    peer channel join -b ./channel-artifacts/mychannel.block
    if [ $? -ne 0 ]; then
      echo "Failed to join channel on ${PEER}.${ORG,,}.example.com"
      exit 1
    fi
  done

  # 更新 Anchor Peer
  peer channel update \
    -o orderer.example.com:7050 \
    -c $CHANNEL_NAME \
    -f ./channel-artifacts/${ORG}MSPanchors.tx \
    --tls true \
    --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
done

