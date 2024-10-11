export FABRIC_CFG_PATH=$(pwd)/config/
export CHANNEL_NAME=mychannel

# 设置 peer0.org1.example.com 环境变量

export CORE_PEER_ID=peer0.org1.example.com
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

# 创建通道 (使用 Orderer)
peer channel create \
  -o orderer.example.com:7050 \
  -c $CHANNEL_NAME \
  --ordererTLSHostnameOverride orderer.example.com \
  -f ./channel-artifacts/mychannel.tx \
  --outputBlock ./channel-artifacts/mychannel.block \
  --tls true \
  --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

