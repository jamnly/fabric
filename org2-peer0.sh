echo "######org2 peer0 startup start######"
echo "current path: $(pwd)"
echo "remove data/peer"
rm -rf ./data/peer/org2-peer0

export FABRIC_CFG_PATH=$(pwd)/config/peer/org2-peer0/

# Generic peer variables

export FABRIC_LOGGING_SPEC=INFO
 #export FABRIC_LOGGING_SPEC=DEBUG
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_PROFILE_ENABLED=true

# Peer specific variables
export CORE_PEER_ID=peer0.org2.example.com
export CORE_PEER_ADDRESS=peer0.org2.example.com:8050
export CORE_PEER_LISTENADDRESS=0.0.0.0:8050
export CORE_PEER_CHAINCODEADDRESS=peer0.org2.example.com:8051
export CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:8051
export CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org2.example.com:8050
export CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org2.example.com:8050
export CORE_PEER_LOCALMSPID=Org2MSP
export CORE_OPERATIONS_LISTENADDRESS=peer0.org2.example.com:8543

# Peer certificates and keys
export CORE_PEER_TLS_CERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp/tlscacerts/tlsca.org2.example.com-cert.pem
export CORE_PEER_TLS_CLIENTROOTCAS_FILES=$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/msp
# Ledger state database path
export CORE_PEER_FILESYSTEMPATH=$(pwd)/data/peer/org2-peer0

# Start the peer node
peer node start

