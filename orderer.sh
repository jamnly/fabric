echo "######orderer startup start######"
echo "current path: $(pwd)"
echo "remove data/orderer"
rm -rf ./data/orderer

export FABRIC_CFG_PATH=$(pwd)/config/

# 设置 Orderer 的主机名
export ORDERER_HOST=orderer.example.com

# 日志级别
export FABRIC_LOGGING_SPEC=INFO

# 启用 TLS
export ORDERER_GENERAL_TLS_ENABLED=true
export ORDERER_GENERAL_TLS_PRIVATEKEY=$(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key
export ORDERER_GENERAL_TLS_CERTIFICATE=$(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_GENERAL_TLS_ROOTCAS=$(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt

# Genesis block 和本地 MSP
export ORDERER_GENERAL_GENESISMETHOD=file
export ORDERER_GENERAL_GENESISFILE=$(pwd)/channel-artifacts/genesis.block
export ORDERER_GENERAL_LOCALMSPID=OrdererMSP
export ORDERER_GENERAL_LOCALMSPDIR=$(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp

# 监听地址和端口
export ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
export ORDERER_GENERAL_LISTENPORT=7050

# 操作监听地址
export ORDERER_OPERATIONS_LISTENADDRESS=orderer.example.com:9443

# 文件账本的位置
export ORDERER_FILELEDGER_LOCATION=$(pwd)/data/orderer


# 集群 TLS 配置
export ORDERER_GENERAL_CLUSTER_CLIENTCERTIFICATE=$(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export ORDERER_GENERAL_CLUSTER_CLIENTPRIVATEKEY=$(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key
export ORDERER_GENERAL_CLUSTER_ROOTCAS=$(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt

# 启动 Orderer
orderer

