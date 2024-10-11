echo "######org2 peer1 startup start######"
echo "current path: $(pwd)"
echo "remove data/peer"
rm -rf ./data/peer/org2-peer1

export FABRIC_CFG_PATH=$(pwd)/config/peer/org2-peer1


export FABRIC_LOGGING_SPEC=INFO
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_PROFILE_ENABLED=true

# Peer specific variables
export CORE_PEER_ID=peer1.org2.example.com
export CORE_PEER_ADDRESS=peer1.org2.example.com:8052
export CORE_PEER_LISTENADDRESS=0.0.0.0:8052
export CORE_PEER_CHAINCODEADDRESS=peer1.org2.example.com:8053
export CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:8053
export CORE_PEER_GOSSIP_BOOTSTRAP=peer1.org2.example.com:8052
export CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer1.org2.example.com:8052
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_OPERATIONS_LISTENADDRESS=peer1.org2.example.com:8544

# Peer certificates and keys
export CORE_PEER_TLS_CERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt

# Ledger state database path
export CORE_PEER_FILESYSTEMPATH=$(pwd)/data/peer/org2-peer1

# Start the peer node
peer node start

