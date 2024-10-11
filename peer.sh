# peer.sh

# 设置 peer0.org1.example.com 的环境变量
setPeerOrg1Peer0() {
    export FABRIC_CFG_PATH=$(pwd)/config/peer/org1-peer0/
    export CORE_PEER_ID=peer0.org1.example.com
    export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=Org1MSP
    export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
}

# 设置 peer0.org2.example.com 的环境变量
setPeerOrg2Peer0() {
    export FABRIC_CFG_PATH=$(pwd)/config/peer/org2-peer0/
    export CORE_PEER_ID=peer0.org2.example.com
    export CORE_PEER_ADDRESS=peer0.org2.example.com:8050
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=Org2MSP
    export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
}
# 设置 peer1.org2.example.com 的环境变量
setPeerOrg2Peer1() {
    export FABRIC_CFG_PATH=$(pwd)/config/peer/org2-peer1/
    export CORE_PEER_ID=peer1.org2.example.com
    export CORE_PEER_ADDRESS=peer1.org2.example.com:8052
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=Org2MSP
    export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
    export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt
}
# 设置 peer0.org3.example.com 的环境变量
setPeerOrg3Peer0() {
    export FABRIC_CFG_PATH=$(pwd)/config/peer/org3-peer0/
    export CORE_PEER_ID=peer0.org3.example.com
    export CORE_PEER_ADDRESS=peer0.org3.example.com:9050
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=Org3MSP
    export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org3.example.com/users/Admin@org3.example.com/msp
    export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
}


