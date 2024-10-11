echo "######generate config file start######"
echo "current path: $(pwd)"

# 清理之前的 crypto-config 目录
echo "remove crypto-config"
rm -rf ./config/crypto-config

# 生成新的 crypto-config 目录
cryptogen generate --config=./config/cryptogen/crypto-config.yaml --output=./config/crypto-config


# 清理之前的 channel-artifacts 目录
echo "remove channel-artifacts"
rm -rf ./channel-artifacts

# 设置 Fabric 配置路径
export FABRIC_CFG_PATH=$(pwd)/config/

# 生成创世区块
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block

# 生成通道创建交易文件
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/mychannel.tx -channelID mychannel

# 生成 Org1 的 Anchor Peer 更新文件
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP

# 生成 Org2 的 Anchor Peer 更新文件
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID mychannel -asOrg Org2MSP

# 生成 Org3 的 Anchor Peer 更新文件
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID mychannel -asOrg Org3MSP

echo "######generate config file over######"

