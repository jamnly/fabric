#!/bin/bash

# 引入 peer.sh 文件
source ./peer.sh

# 设定链码相关变量
CHANNEL_NAME="mychannel"
CC_TGZ_NAME="sample"
CC_VERSION="1"
CC_SEQUENCE="1"
INIT_REQUIRED="--init-required"

declare -A CC_NAMES=(
  ["Org1peer0"]="sampleOrg1"
  ["Org2peer0"]="sampleOrg2"
  ["Org2peer1"]="sampleOrg2Peer1"
  ["Org3peer0"]="sampleOrg3"
)


# 定义组织及其对应的 Peer 数量
declare -A ORG_PEER_COUNT=(
  ["Org1"]=1  # Org1 有 1 个 Peer
  ["Org2"]=1  # Org2 有 2 个 Peer
  ["Org3"]=1  # Org3 有 1 个 Peer
)

# 定义每个组织的 Peer 设置函数
declare -A PEER_SET_FUNCTIONS=(
  ["Org1peer0"]="setPeerOrg1Peer0"  # Org1 的 Peer 0
  ["Org2peer0"]="setPeerOrg2Peer0"  # Org2 的 Peer 0
  ["Org2peer1"]="setPeerOrg2Peer1"  # Org2 的 Peer 1
  ["Org3peer0"]="setPeerOrg3Peer0"  # Org3 的 Peer 0
)

# 定义链码路径
declare -A CC_SRC_PATHS=(
  ["Org1peer0"]="$(pwd)/chaincode/org1-peer0/sampleChaincode/external/"
  ["Org2peer0"]="$(pwd)/chaincode/org2-peer0/sampleChaincode/external/"
  ["Org2peer1"]="$(pwd)/chaincode/org2-peer1/sampleChaincode/external/"
  ["Org3peer0"]="$(pwd)/chaincode/org3-peer0/sampleChaincode/external/"
)

declare -A PEER_ADDRESSES=(
  ["sampleOrg1"]="peer0.org1.example.com:7051"
  ["sampleOrg2"]="peer0.org2.example.com:8050"
  ["sampleOrg3"]="peer0.org3.example.com:9050"
)

# 安装链码的 Peers
install_peers=("Org1peer0" "Org2peer0" "Org2peer1" "Org3peer0")
declare -A PEER_PACKAGE_IDS=()  # 创建一个字典来存储每个 Peer 的 PACKAGE_ID

# 循环遍历每个 peer 进行安装链码
for peerName in "${install_peers[@]}"; do
    # 调用设置 peer 的函数
    ${PEER_SET_FUNCTIONS[$peerName]}
    
    # 设置链码路径
    CC_SRC_PATH=${CC_SRC_PATHS[$peerName]}

    echo "Processing $peerName with chaincode path: $CC_SRC_PATH"
    
    # 打印当前的 CORE_PEER_ID 以便于调试
    echo "Using peer: $CORE_PEER_ID"

    # 检查链码文件是否存在
    if [ ! -f "${CC_SRC_PATH}/${CC_TGZ_NAME}.tgz" ]; then
        echo "Chaincode package not found: ${CC_SRC_PATH}/${CC_TGZ_NAME}.tgz"
        exit 1
    fi

    # 安装链码
    echo "##chaincode install on $CORE_PEER_ID"
    peer lifecycle chaincode install "${CC_SRC_PATH}/${CC_TGZ_NAME}.tgz"
    INSTALL_STATUS=$?  # 获取安装状态
    echo "Install status for $CORE_PEER_ID: $INSTALL_STATUS"

    peer lifecycle chaincode queryinstalled >&log.txt 
    echo "Log content after queryinstalled:"
    cat log.txt

    PACKAGE_ID=$(grep "${CC_TGZ_NAME}:" log.txt | awk '{print $3}' | tr -d ',')
    echo "Package ID: $PACKAGE_ID"

    # 检查 PACKAGE_ID 是否成功获取
    if [ -z "$PACKAGE_ID" ]; then
       echo "Failed to get Package ID for $CORE_PEER_ID. Please check the logs for more details."
       exit 1
    fi

    # 将 PACKAGE_ID 存入以 peer 名为键的字典
    PEER_PACKAGE_IDS["$peerName"]="$PACKAGE_ID"
done

# 所有安装了链码的 peers 都批准链码
approve_peers=("Org1peer0" "Org2peer0" "Org3peer0")

for peerName in "${approve_peers[@]}"; do
    # 调用设置 peer 的函数
    ${PEER_SET_FUNCTIONS[$peerName]}

    PACKAGE_ID=${PEER_PACKAGE_IDS[$peerName]}  # 使用对应的 PACKAGE_ID
    CC_NAME=${CC_NAMES[$peerName]}  # 使用不同的链码名称
    echo "##chaincode approveformyorg on $CORE_PEER_ID"
     echo "##chaincode PACKAGE_ID is $PACKAGE_ID"
    peer lifecycle chaincode approveformyorg \
        -o orderer.example.com:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --channelID "$CHANNEL_NAME" \
        --name "$CC_NAME" \
        --version "$CC_VERSION" \
        --package-id "$PACKAGE_ID" \
        --sequence "$CC_SEQUENCE" \
        "$INIT_REQUIRED" \
        --tls \
        --cafile "$(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

    if [ $? -ne 0 ]; then
        echo "Chaincode approve failed on $CORE_PEER_ID"
        exit 1
    fi
done

#setPeerOrg1Peer0
## 检查链码提交准备状态
#echo "##chaincode checkcommitreadiness"
#peer lifecycle chaincode checkcommitreadiness --channelID "$CHANNEL_NAME" --name "${CC_NAME}" --version "${CC_VERSION}" --sequence "${CC_SEQUENCE}" ${INIT_REQUIRED} --output json

## 检查链码提交准备状态
#for peerName in "${approve_peers[@]}"; do
#    ${PEER_SET_FUNCTIONS[$peerName]}  # 使用对应的函数设置环境变量
#
#    CC_NAME=${CC_NAMES[$peerName]}
#    echo "Checking commit readiness for $CC_NAME on $CORE_PEER_ID"
#    peer lifecycle chaincode checkcommitreadiness --channelID "$CHANNEL_NAME" --name "$CC_NAME" --version "$CC_VERSION" --sequence "$CC_SEQUENCE" ${INIT_REQUIRED} --output json
#done
#
#
## 提交链码
#echo "##chaincode commit"
#peer lifecycle chaincode commit \
#  -o orderer.example.com:7050 \
#  --channelID "$CHANNEL_NAME" \
#  --name "${CC_NAME}" \
#  --version "${CC_VERSION}" \
#  --sequence "${CC_SEQUENCE}" \
#  --init-required \
#  --tls true \
#  --cafile "$(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
#  --peerAddresses peer0.org1.example.com:7051 \
#  --tlsRootCertFiles "$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" \
#  --peerAddresses peer0.org2.example.com:8050 \
#  --tlsRootCertFiles "$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" \
#  --peerAddresses peer0.org3.example.com:9050 \
#  --tlsRootCertFiles "$(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt"

# 检查每个链码的提交准备状态并提交
for peerName in "${approve_peers[@]}"; do
    ${PEER_SET_FUNCTIONS[$peerName]}
    CC_NAME=${CC_NAMES[$peerName]}
    echo "Checking commit readiness and committing $CC_NAME on channel $CHANNEL_NAME"
    peer lifecycle chaincode checkcommitreadiness --channelID "$CHANNEL_NAME" --name "$CC_NAME" --version "$CC_VERSION" --sequence "$CC_SEQUENCE" ${INIT_REQUIRED} --output json
    peer lifecycle chaincode commit \
        -o orderer.example.com:7050 \
        --channelID "$CHANNEL_NAME" \
        --name "$CC_NAME" \
        --version "$CC_VERSION" \
        --sequence "$CC_SEQUENCE" \
        --init-required \
        --tls true \
        --cafile "$(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
        --peerAddresses peer0.org1.example.com:7051 \
        --tlsRootCertFiles "$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" \
        --peerAddresses peer0.org2.example.com:8050 \
        --tlsRootCertFiles "$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" \
        --peerAddresses peer0.org3.example.com:9050 \
        --tlsRootCertFiles "$(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt"
    if [ $? -ne 0 ]; then
        echo "Chaincode commit failed for $CC_NAME on $CORE_PEER_ID"
        exit 1
    fi
    echo "$CC_NAME committed successfully."
done

# 输出所有 peer 的 PACKAGE_ID
echo "##All Package IDs:"
for peer in "${!PEER_PACKAGE_IDS[@]}"; do
    echo "$peer: ${PEER_PACKAGE_IDS[$peer]}"
done

