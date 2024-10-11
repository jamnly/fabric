echo "######org3 peer0 startup start######"
echo "current path: $(pwd)"
echo "remove data/peer"
rm -rf ./data/peer/org3-peer0

export FABRIC_CFG_PATH=$(pwd)/config/peer/org3-peer0/


export FABRIC_LOGGING_SPEC=INFO
# export FABRIC_LOGGING_SPEC=DEBUG
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_PROFILE_ENABLED=true

# Peer specific variables
export CORE_PEER_ID=peer0.org3.example.com
export CORE_PEER_ADDRESS=peer0.org3.example.com:9050
export CORE_PEER_LISTENADDRESS=0.0.0.0:9050
export CORE_PEER_CHAINCODEADDRESS=peer0.org3.example.com:9051
export CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:9051
export CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org3.example.com:9050
export CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org3.example.com:9050
export CORE_PEER_LOCALMSPID=Org3MSP
export CORE_OPERATIONS_LISTENADDRESS=peer0.org3.example.com:9543

# Peer certificates and keys
export CORE_PEER_TLS_CERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=$(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/msp/tlscacerts/tlsca.org3.example.com-cert.pem

# Ledger state database path
export CORE_PEER_FILESYSTEMPATH=$(pwd)/data/peer/org3-peer0

# Start the peer node
peer node start

