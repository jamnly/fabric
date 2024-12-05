# 非docker部署fabric网络
`环境:`   
`go1.21.6(至少要1.21以上)`   
`sh`  
`fabric 2.2.0`  

## 环境安装
### go 安装
* `wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz `
* 删除旧版本 `sudo rm -rf /usr/local/go` 
* `sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz`
* `sudo gedit  ~/.bashrc`
* 最下面两行加入，如果有旧版本的路径不同，记得改路径
```
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin

```
* `source ~/.bashrc`
* `go version`
* 出现这个就算成功！ `go version go1.21.0 linux/amd64`
#### 配置go代理
* `go env -w GO111MODULE=on`
* `go env -w GOPROXY=https://goproxy.cn,direct`
### fabric安装
* 浏览器打开下载压缩包 https://github.com/hyperledger/fabric/releases/download/v2.2.15/hyperledger-fabric-linux-amd64-2.2.15.tar.gz
* 浏览器打开下载压缩包 https://github.com/hyperledger/fabric-ca/releases/download/v1.5.9/hyperledger-fabric-ca-linux-amd64-1.5.9.tar.gz
* 解压到自己想要的位置 `tar -xzvf hyperledger-fabric-ca-linux-amd64-1.5.9.tar.gz -C /home/test/fabric/bin`
* 同上`tar -xzvf hyperledger-fabric-linux-amd64-2.2.15.tar.gz -C /home/test/fabric/`
* `sudo gedit  ~/.bashrc`
* 最下面行加入，如果有旧版本的路径不同，记得改路径
```
export PATH=$PATH:/home/test/fabric/bin
```
* `source ~/.bashrc`
* `peer version`
* 出现这个就算成功！ 

```
peer:
 Version: 2.2.15
 Commit SHA: 79c8cc2
 Go version: go1.21.6
 OS/Arch: linux/amd64
 Chaincode:
  Base Docker Label: org.hyperledger.fabric
  Docker Namespace: hyperledger
```

## 节点情况
`peer0.org1.example.com` `peer0.org2.example.com` `peer1.org2.example.com` `peer0.org3.example.com` `orderer.example.com`

## 执行命令（一切顺利的话）
* 执行`sh generate-config-file.sh`创建证书，创世块、通道文件和锚点文件等
* 执行`sh orderer.sh`启动orderer节点
* 执行`sh org1-peer0.sh`启动peer0.org1节点
* 执行`sh org2-peer0.sh`启动peer0.org2节点
* 执行`sh org2-peer1.sh`启动peer1.org2节点
* 执行`sh org3-peer0.sh`启动peer0.org3节点
* 执行`sh create_channel1.sh`创建通道
* 执行`bash join_channel.sh`加入通道
* 执行`bash approveformyorg_chaincode.sh`安装链码、批准链码、提交链码、并输出所有链码ID
* 前往 `cd chaincode/org1-peer0/sampleChaincode` 执行`./sample` 启动peer0.org1的链码
* 前往 `cd chaincode/org2-peer0/sampleChaincode` 执行`./sample` 启动peer0.org2的链码
* 前往 `cd chaincode/org2-peer1/sampleChaincode` 执行`./sample` 启动peer1.org2的链码
* 前往 `cd chaincode/org3-peer0/sampleChaincode` 执行`./sample` 启动peer0.org3的链码
* 回到根目录
可以查看peer.sh里的环境变量，进行引用
```
# 设置 peer0.org1.example.com 的环境变量
    export FABRIC_CFG_PATH=$(pwd)/config/
    export CORE_PEER_ID=peer0.org1.example.com
    export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=Org1MSP
    export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
 ```
* 初始化链码
```
peer chaincode invoke \
  -o orderer.example.com:7050 \
  -C "mychannel" \
  -n "sample" \
  --isInit \
  --tls true \
  --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
  --peerAddresses peer0.org1.example.com:7051 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
  --peerAddresses peer0.org2.example.com:8050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
  --peerAddresses peer0.org3.example.com:9050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt \
   -c '{"Args":[]}'
```


* 设置a
```
  peer chaincode invoke \
  -o orderer.example.com:7050 \
  -C "mychannel" \
  -n "sample" \
  --tls true \
  --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
  --peerAddresses peer0.org1.example.com:7051 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
  --peerAddresses peer0.org2.example.com:8050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
  --peerAddresses peer0.org3.example.com:9050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt \
  -c '{"function":"create","Args":["a","20"]}'
  ```

* 执行`peer chaincode query -C mychannel -n sample -c '{"Args":["read","a"]}' `查询a
* 查询的时候也可以带上证书，这样org1peer0那边的链码也会进行查询，也可以多带几个证书
```peer chaincode query -C mychannel -n sample -c '{"Args":["read","b"]}' /
--peerAddresses peer0.org1.example.com:7051 /
--tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt 
```

## 可能需要修改的地方


* 保证端口 7050（orderer） 7051 7052（peer0.org1） 8050 8051（peer0.org2） 9050 9051（peer0.org3）6666(peer0.org1链码) 6667(peer0.org2链码) 6668(peer0.org3链码) 没有被占用
否则需要对peer的端口进行修改
* 检查端口是否被占用
```
lsof -i :6666
lsof -i :6667
lsof -i :6668
lsof -i :7050
lsof -i :7051
lsof -i :7052
lsof -i :8050
lsof -i :8051
lsof -i :9050
lsof -i :9051

```
假设7051被占用
* 关联文件：`peer.sh` `peer0.org1.sh` `config/peer/org1-peer0/core.yaml`
* 请修改关于端口的地方
假设6666被占用
* 关联文件：`chaincode/org1-peer0/sampleChaincode/external/connection.json` `chaincode/org1-peer0/sampleChaincode/main.go` 
* 请修改关于端口的地方
* 并需要重新在/external下  `tar cfz code.tar.gz connection.json `  `tar cfz sample.tgz metadata.json code.tar.gz` 和在/sampleChaincode 下 go build `go build`
### 增加新的peer或org的情况
* 必须到所有的`core.yaml` 里
```
gossip:
        bootstrap: peer0.org1.example.com:7051,peer0.org2.example.com:8050,peer1.org2.example.com:8052,peer0.org3.example.com:9050
```
* 加上新增加的peer！

## 添加org

* 假设现在需要添加org4
* 以下端口会占用10050 10051 7000！
* 检查端口是否被占用
```
lsof -i :10050
lsof -i :10051
lsof -i :7000

```
<span id=static_join></span>
### 静态加入org
* 在当前目录下 新建 `org4-peer0.sh` [org4-peer0.sh详细内容](#0)
* 在config/peer/下 新建`org4-peer0`文件夹 进入再新建（最好是复制org3-peer0）的core.yaml文件 `core.yaml` [core.yaml详细内容](#1)
* 在chaincode/下 新建`org4-peer0`文件夹 进入在新建（自定义的合约名称，可参考org3-peer0里的内容） `sampleChaincode`文件夹 进入新建`main.go`（链码） 再新建`external`文件夹（用于打包合约）进入创建`connection.json`和`metadata.json` [connection.json 详细内容](#2) [metadata.json 详细内容](#3)
 #### 需要修改的地方

<span id="0"></span>
[回到动态加入org](#dynamic_join)

* `org4-peer0.sh`:
```
echo "######org4 peer0 startup start######"
echo "current path: $(pwd)"
echo "remove data/peer"
rm -rf ./data/peer/org4-peer0

export FABRIC_CFG_PATH=$(pwd)/config/peer/org4-peer0/


export FABRIC_LOGGING_SPEC=INFO
# export FABRIC_LOGGING_SPEC=DEBUG
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_PROFILE_ENABLED=true

# Peer specific variables
export CORE_PEER_ID=peer0.org4.example.com
export CORE_PEER_ADDRESS=peer0.org4.example.com:10050
export CORE_PEER_LISTENADDRESS=0.0.0.0:10050
export CORE_PEER_CHAINCODEADDRESS=peer0.org4.example.com:10051
export CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:10051
export CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org4.example.com:10050
export CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org4.example.com:10050
export CORE_PEER_LOCALMSPID=Org4MSP
export CORE_OPERATIONS_LISTENADDRESS=peer0.org4.example.com:10543

# Peer certificates and keys
export CORE_PEER_TLS_CERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp/tlscacerts/tlsca.org4.example.com-cert.pem
export CORE_PEER_TLS_CLIENTROOTCAS_FILES=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp

# Ledger state database path
export CORE_PEER_FILESYSTEMPATH=$(pwd)/data/peer/org4-peer0

# Start the peer node
peer node start

```
* `peer.sh`:添加内容
```
# 设置 peer0.org4.example.com 的环境变量
setPeerOrg4Peer0() {
    export FABRIC_CFG_PATH=$(pwd)/config/peer/org4-peer0/
    export CORE_PEER_ID=peer0.org4.example.com
    export CORE_PEER_ADDRESS=peer0.org4.example.com:10050
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=Org4MSP
    export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp
    export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt
}
```
* `generate-config-file.sh`:添加内容
```
# 生成 Org4 的 Anchor Peer 更新文件
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org4MSPanchors.tx -channelID mychannel -asOrg Org4MSP
```
* `join_channel.sh`:添加内容 
```
# 定义组织及其对应的 Peer 数量
declare -A ORG_PEER_COUNT=(
  ["Org1"]=1  # Org1 有 1 个 Peer
  ["Org2"]=2  # Org2 有 2 个 Peer
  ["Org3"]=1  # Org3 有 1 个 Peer
  ["Org4"]=1  # Org4 有 1 个 Peer
)

# 定义每个组织的 Peer 设置函数
declare -A PEER_SET_FUNCTIONS=(
  ["Org1peer0"]="setPeerOrg1Peer0"  # Org1 的 Peer 0
  ["Org2peer0"]="setPeerOrg2Peer0"  # Org2 的 Peer 0
  ["Org2peer1"]="setPeerOrg2Peer1"  # Org2 的 Peer 1
  ["Org3peer0"]="setPeerOrg3Peer0"  # Org3 的 Peer 0
  ["Org4peer0"]="setPeerOrg4Peer0"  # Org4 的 Peer 0
)

```
* `approveformyorg_chaincode.sh`:添加内容 
```
# 定义组织及其对应的 Peer 数量
declare -A ORG_PEER_COUNT=(
  ["Org1"]=1  # Org1 有 1 个 Peer
  ["Org2"]=1  # Org2 有 2 个 Peer
  ["Org3"]=1  # Org3 有 1 个 Peer
  ["Org4"]=1  # Org4 有 1 个 Peer
)

# 定义每个组织的 Peer 设置函数
declare -A PEER_SET_FUNCTIONS=(
  ["Org1peer0"]="setPeerOrg1Peer0"  # Org1 的 Peer 0
  ["Org2peer0"]="setPeerOrg2Peer0"  # Org2 的 Peer 0
  ["Org2peer1"]="setPeerOrg2Peer1"  # Org2 的 Peer 1
  ["Org3peer0"]="setPeerOrg3Peer0"  # Org3 的 Peer 0
  ["Org4Peer0"]="setPeerOrg4Peer0"  # Org4 的 Peer 0
)

# 定义链码路径
declare -A CC_SRC_PATHS=(
  ["Org1peer0"]="$(pwd)/chaincode/org1-peer0/sampleChaincode/external/"
  ["Org2peer0"]="$(pwd)/chaincode/org2-peer0/sampleChaincode/external/"
  ["Org2peer1"]="$(pwd)/chaincode/org2-peer1/sampleChaincode/external/"
  ["Org3peer0"]="$(pwd)/chaincode/org3-peer0/sampleChaincode/external/"
  ["Org4Peer0"]="$(pwd)/chaincode/org4-peer0/sampleChaincode/external/"
)
# 所有安装了链码的 peers 都批准链码
approve_peers=("Org1peer0" "Org2peer0" "Org3peer0" "Org4peer0")
# 提交链码
echo "##chaincode commit"
peer lifecycle chaincode commit \
  -o orderer.example.com:7050 \
  --channelID "$CHANNEL_NAME" \
  --name "${CC_NAME}" \
  --version "${CC_VERSION}" \
  --sequence "${CC_SEQUENCE}" \
  --init-required \
  --tls true \
  --cafile "$(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" \
  --peerAddresses peer0.org1.example.com:7051 \
  --tlsRootCertFiles "$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" \
  --peerAddresses peer0.org2.example.com:8050 \
  --tlsRootCertFiles "$(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" \
  --peerAddresses peer0.org3.example.com:9050 \
  --tlsRootCertFiles "$(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt" \
  --peerAddresses peer0.org4.example.com:10050 \
  --tlsRootCertFiles "$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt"
```
* 在config/下 `configtx.yaml`:添加内容 
```
- &Org4
        # DefaultOrg defines the organization which is used in the sampleconfig
        # of the fabric.git development environment
        Name: Org4MSP

        # ID to load the MSP definition as
        ID: Org4MSP

        MSPDir: ./crypto-config/peerOrganizations/org4.example.com/msp

        # Policies defines the set of policies at this level of the config tree
        # For organization policies, their canonical path is usually
        #   /Channel/<Application|Orderer>/<OrgName>/<PolicyName>
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('Org4MSP.member')"
            Writers:
                Type: Signature
                Rule: "OR('Org4MSP.member')"
            Admins:
                Type: Signature
                Rule: "OR('Org4MSP.admin')"
            Endorsement:
                Type: Signature
                Rule: "OR('Org4MSP.member')"
        
        AnchorPeers:
            - Host: peer0.org4.example.com
              Port: 10050
    TwoOrgsOrdererGenesis:
        <<: *ChannelDefaults
        Orderer:
            <<: *OrdererDefaults
            Organizations:
                - *OrdererOrg
            Capabilities:
                <<: *OrdererCapabilities
        Consortiums:
            SampleConsortium:
                Organizations:
                    - *Org1
                    - *Org2
                    - *Org3
                    - *Org4
    TwoOrgsChannel:
        Consortium: SampleConsortium
        <<: *ChannelDefaults
        Application:
            <<: *ApplicationDefaults
            Organizations:
                - *Org1
                - *Org2
                - *Org3
                - *Org4
            Capabilities:
                <<: *ApplicationCapabilities
```
<span id="1"></span>
[回到静态加入org](#static_join)
[回到动态加入org](#dynamic_join)

* 在config/peer/org4-peer0 下 `core.yaml`:添加内容 
```
peer:

    id: peer0.org4.example.com

    networkId: dev

    listenAddress: peer0.org4.example.com:10050

    chaincodeListenAddress: peer0.org4.example.com:10051

    chaincodeAddress: peer0.org4.example.com:10051

    address: peer0.org4.example.com:10050

    addressAutoDetect: false

    keepalive:
        interval: 7200s
        timeout: 20s
        minInterval: 60s
        client:
            interval: 60s
            timeout: 20s
        deliveryClient:
            interval: 60s
            timeout: 20s


    gossip:
        bootstrap: peer0.org3.example.com:9050,peer0.org2.example.com:8050,peer0.org1.example.com:7051,peer0.org4.example.com:10050


        useLeaderElection: false
        orgLeader: true

        membershipTrackerInterval: 5s

        endpoint:
        maxBlockCountToStore: 10
        maxPropagationBurstLatency: 10ms
        maxPropagationBurstSize: 10
        propagateIterations: 1
        propagatePeerNum: 3
        pullInterval: 4s
        pullPeerNum: 3
        requestStateInfoInterval: 4s
        publishStateInfoInterval: 4s
        stateInfoRetentionInterval:
        publishCertPeriod: 10s
        skipBlockVerification: false
        dialTimeout: 3s
        connTimeout: 2s
        recvBuffSize: 20
        sendBuffSize: 200
        digestWaitTime: 1s
        requestWaitTime: 1500ms
        responseWaitTime: 2s
        aliveTimeInterval: 5s
        aliveExpirationTimeout: 25s
        reconnectInterval: 25s
        maxConnectionAttempts: 120
        msgExpirationFactor: 20
        externalEndpoint:
        election:
            startupGracePeriod: 15s
            membershipSampleInterval: 1s
            leaderAliveThreshold: 10s
            leaderElectionDuration: 5s

        pvtData:
            pullRetryThreshold: 60s
            transientstoreMaxBlockRetention: 1000
            pushAckTimeout: 3s
            btlPullMargin: 10
            reconcileBatchSize: 10
            reconcileSleepInterval: 1m
            reconciliationEnabled: true
            skipPullingInvalidTransactionsDuringCommit: false
            implicitCollectionDisseminationPolicy:
               requiredPeerCount: 0
               maxPeerCount: 1

        state:
            enabled: false
            checkInterval: 10s
            responseTimeout: 3s
            batchSize: 10
            blockBufferSize: 20
            maxRetries: 3

    tls:
        enabled:  true
        clientAuthRequired: false
        cert:
            file: ../../crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/server.crt
        key:
            file: ../../crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/server.key
        rootcert:
            file: ../../crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp/tlscacerts/tlsca.org4.example.com-cert.pem
        clientRootCAs:
            files:
              - ../../crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt
        clientKey:
            file:
        clientCert:
            file:

    authentication:
        timewindow: 15m

    fileSystemPath: data/peer

    BCCSP:
        Default: SW
        SW:
            Hash: SHA2
            Security: 256
            FileKeyStore:
                KeyStore:
        PKCS11:
            Library:
            Label:
            Pin:
            Hash:
            Security:

    mspConfigPath: ../../crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp

    localMspId: Org4MSP

    client:
        connTimeout: 3s

    deliveryclient:
        reconnectTotalTimeThreshold: 3600s

        connTimeout: 3s

        reConnectBackoffThreshold: 3600s

        addressOverrides:

    localMspType: bccsp

    profile:
        enabled:     true
        listenAddress: 0.0.0.0:6064

    handlers:
        authFilters:
          -
            name: DefaultAuth
          -
            name: ExpirationCheck    # This filter checks identity x509 certificate expiration
        decorators:
          -
            name: DefaultDecorator
        endorsers:
          escc:
            name: DefaultEndorsement
            library:
        validators:
          vscc:
            name: DefaultValidation
            library:

    validatorPoolSize:

    discovery:
        enabled: true
        authCacheEnabled: true
        authCacheMaxSize: 1000
        authCachePurgeRetentionRatio: 0.75
        orgMembersAllowedAccess: false

    limits:
        concurrency:
            endorserService: 2500
            deliverService: 2500

vm:

    endpoint: 

    docker:
        tls:
            enabled: false
            ca:
                file: docker/ca.crt
            cert:
                file: docker/tls.crt
            key:
                file: docker/tls.key

        attachStdout: false

        hostConfig:
            NetworkMode: host
            Dns:
            LogConfig:
                Type: json-file
                Config:
                    max-size: "50m"
                    max-file: "5"
            Memory: 2147483648

chaincode:

    id:
        path:
        name:

    builder: hyperledger/fabric-ccenv:2.2.0

    pull: false

    golang:
        runtime: hyperledger/fabric-baseos:2.2.0

        dynamicLink: false

    java:
        runtime: $(DOCKER_NS)/fabric-javaenv:$(TWO_DIGIT_VERSION)

    node:
        runtime: $(DOCKER_NS)/fabric-nodeenv:$(TWO_DIGIT_VERSION)

    externalBuilders: 
      - name: simple
        path: ./external
        propagateEnvironment:
         - ../../crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt
         - ../../crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/server.crt
         - ../../crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/server.key
         - ../../crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/msp/tlscacerts/tlsca.org4.example.com-cert.pem

    installTimeout: 300s

    startuptimeout: 300s

    executetimeout: 30s

    mode: net

    keepalive: 0

    system:
        _lifecycle: enable
        cscc: enable
        lscc: enable
        escc: enable
        vscc: enable
        qscc: enable

    logging:
      level:  info
      shim:   warning
      format: '%{color}%{time:2006-01-02 15:04:05.000 MST} [%{module}] %{shortfunc} -> %{level:.4s} %{id:03x}%{color:reset} %{message}'

ledger:

  blockchain:

  state:
    stateDatabase: goleveldb
    totalQueryLimit: 100000
    couchDBConfig:
       couchDBAddress: 127.0.0.1:5984
       username:
       password:
       maxRetries: 3
       maxRetriesOnStartup: 10
       requestTimeout: 35s
       internalQueryLimit: 1000
       maxBatchUpdateSize: 1000
       warmIndexesAfterNBlocks: 1
       createGlobalChangesDB: false
       cacheSize: 64

  history:
    enableHistoryDatabase: true

  pvtdataStore:
    collElgProcMaxDbBatchSize: 5000
    collElgProcDbBatchesInterval: 1000

operations:
    listenAddress: 127.0.0.1:9443

    tls:
        enabled: false

        cert:
            file:

        key:
            file:

        clientAuthRequired: false

        clientRootCAs:
            files: []

metrics:
    provider: disabled

    statsd:
        network: udp

        address: 127.0.0.1:8125

        writeInterval: 10s

        prefix:
```
* 在config/cryptogen 下 `cryto-config.yaml`:添加内容 
```
- Name: Org4
    Domain: org4.example.com
    EnableNodeOUs: false
    Template:
      Count: 1
    Users:
      Count: 1
```
 <span id="2"> </span>
[回到静态加入org](#static_join)
[回到动态加入org](#dynamic_join)

* 在chaincode/org4-peer0/sampleChaincode/external 下 `connection.json` 编写
```
{
    "address": "0.0.0.0:7000",
    "dial_timeout": "10s",
    "tls_required": false,
    "client_auth_required": true,
    "client_key": "-----BEGIN EC PRIVATE KEY----- ... -----END EC PRIVATE KEY-----",
    "client_cert": "-----BEGIN CERTIFICATE----- ... -----END CERTIFICATE-----",
    "root_cert": "-----BEGIN CERTIFICATE---- ... -----END CERTIFICATE-----"
}

```
<span id="3"></span>
[回到静态加入org](#static_join)
[回到动态加入org](#dynamic_join)

* 在chaincode/org4-peer0/sampleChaincode/external 下 `metadata.json` 编写
```
{"path":"","type":"external","label":"sample"}

```

* 执行`sh generate-config-file.sh`创建证书，创世块、通道文件和锚点文件等
* 执行`sh orderer.sh`启动orderer节点
* 执行`sh org1-peer0.sh`启动peer0.org1节点
* 执行`sh org2-peer0.sh`启动peer0.org2节点
* 执行`sh org2-peer1.sh`启动peer1.org2节点
* 执行`sh org3-peer0.sh`启动peer0.org3节点
* 执行`sh create_channel1.sh`创建通道
* 执行`bash join_channel.sh`加入通道
* 执行`bash approveformyorg_chaincode.sh`安装链码、批准链码、提交链码、并输出所有链码ID
* 前往 `cd chaincode/org1-peer0/sampleChaincode` 执行`./sample` 启动peer0.org1的链码
* 前往 `cd chaincode/org2-peer0/sampleChaincode` 执行`./sample` 启动peer0.org2的链码
* 前往 `cd chaincode/org2-peer1/sampleChaincode` 执行`./sample` 启动peer1.org2的链码
* 前往 `cd chaincode/org3-peer0/sampleChaincode` 执行`./sample` 启动peer0.org3的链码
* 你会得到以下内容，xxx即为peer0.org4的需要安装的链码
```
##All Package IDs:
Org2peer1: sample:c7ea2b0af46393fdba0467b5755980955a4a1080f203472280da4e608d920dbf
Org2peer0: sample:a2e9208cf7edec5352d0efd78f2ac86a50b68c373a260ee818e0f83c9985788f
Org1peer0: sample:541650006fca0f91d04695fe29f8891e6f5bed60fa2d0bdda67c064a0d528e37
Org3peer0: sample:8cc38988372d607b605d88d7c7cd521d252fe3eb086cb75c83a24e10c710b1e2
Org4peer0: xxxx
```

### 编写新的链码
**!!!!!!!!!!!!!!!!!!!!!**
* 请复制上面的xxx！，这将在下面的内容里用到，并替换
* ccid := "sample:xxx" //这里替换!!!
* 在chaincode/org4-peer0/sampleChaincode/ 下 `main.go` 编写
```
package main

import (
	"errors"
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	pb "github.com/hyperledger/fabric-protos-go/peer" // 确保导入这个包
)

// SimpleChaincode example simple Chaincode implementation
type SimpleChaincode struct {
}

// Init 方法
func (sc *SimpleChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {
	// 可以在这里进行初始化逻辑，例如设置初始状态
	return shim.Success(nil)
}

// 上链
func (sc *SimpleChaincode) Create(stub shim.ChaincodeStubInterface, key string, value string) error {
	existing, err := stub.GetState(key)
	if err != nil {
		return errors.New("查询失败！")
	}
	if existing != nil {
		return fmt.Errorf("添加数据错误！%s已经存在。", key)
	}
	err = stub.PutState(key, []byte(value))
	if err != nil {
		return errors.New("添加数据失败！")
	}
	return nil
}

// 更新
func (sc *SimpleChaincode) Update(stub shim.ChaincodeStubInterface, key string, value string) error {
	bytes, err := stub.GetState(key)
	if err != nil {
		return errors.New("查询失败！")
	}
	if bytes == nil {
		return fmt.Errorf("没有查询到%s对应的数据", key)
	}
	err = stub.PutState(key, []byte(value))
	if err != nil {
		return errors.New("更新失败：" + err.Error())
	}
	return nil
}

// 查询
func (sc *SimpleChaincode) Read(stub shim.ChaincodeStubInterface, key string) (string, error) {
	bytes, err := stub.GetState(key)
	if err != nil {
		return "", errors.New("查询失败！")
	}
	if bytes == nil {
		return "", fmt.Errorf("数据不存在，读到的%s对应的数据为空！", key)
	}
	return string(bytes), nil
}

// Invoke 方法
func (sc *SimpleChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	function, args := stub.GetFunctionAndParameters()
	switch function {
	case "create":
		if len(args) != 2 {
			return shim.Error("参数个数不正确！")
		}
		err := sc.Create(stub, args[0], args[1])
		if err != nil {
			return shim.Error(err.Error())
		}
		return shim.Success(nil)

	case "update":
		if len(args) != 2 {
			return shim.Error("参数个数不正确！")
		}
		err := sc.Update(stub, args[0], args[1])
		if err != nil {
			return shim.Error(err.Error())
		}
		return shim.Success(nil)

	case "read":
		if len(args) != 1 {
			return shim.Error("参数个数不正确！")
		}
		value, err := sc.Read(stub, args[0])
		if err != nil {
			return shim.Error(err.Error())
		}
		return shim.Success([]byte(value))

	default:
		return shim.Error("无效的函数调用！")
	}
}

// main function
func main() {
	fmt.Println("main start...")

	// The ccid is assigned to the chaincode on install (using the “peer lifecycle chaincode install <package>” command)
	ccid := "sample:xxx" //这里替换!!!

	server := &shim.ChaincodeServer{
		CCID:    ccid,
		Address: "0.0.0.0:7000",
		CC:      new(SimpleChaincode),
		TLSProps: shim.TLSProperties{
			Disabled:      true,
		},
	}

	err := server.Start()
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
		return
	}
}

```
* 之后保证go版本要在1.21以上
* `go mod init sample` 这里的sample可以自定义
* `go mod tidy`
* `go build` 之后会生成一个sample文件
* `./sample` 启动合约
* 之后就是invoke合约，记得加上org4的证书和路径
* 使用`peer.sh`里的peer1.org4的环境
```
    export FABRIC_CFG_PATH=$(pwd)/config/peer/org4-peer0/
    export CORE_PEER_ID=peer0.org4.example.com
    export CORE_PEER_ADDRESS=peer0.org4.example.com:10050
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=Org4MSP
    export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp
    export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt
```
* 初始化
```

peer chaincode invoke \
  -o orderer.example.com:7050 \
  -C "mychannel" \
  -n "sample" \
  --isInit \
  --tls true \
  --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
  --peerAddresses peer0.org1.example.com:7051 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
  --peerAddresses peer0.org2.example.com:8050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
  --peerAddresses peer0.org3.example.com:9050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt \
  --peerAddresses peer0.org4.example.com:10050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt \
  -c '{"Args":[]}'

```
* 设置b属性
```
  peer chaincode invoke \
  -o orderer.example.com:7050 \
  -C "mychannel" \
  -n "sample" \
  --tls true \
  --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
  --peerAddresses peer0.org1.example.com:7051 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
  --peerAddresses peer0.org2.example.com:8050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
  --peerAddresses peer0.org3.example.com:9050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt \
  --peerAddresses peer0.org4.example.com:10050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt \
  -c '{"function":"create","Args":["b","20"]}'
```
<span id=dynamic_join></span>

### 动态加入org
* 假设动态加入`org4peer0`
* 即不执行`sh generate-config-file.sh`重新创建 
* 在当前目录下 新建 `org4-peer0.sh` [org4-peer0.sh详细内容](#0)
* 在config/peer/下 新建`org4-peer0`文件夹 进入再新建（最好是复制org3-peer0）的core.yaml文件 `core.yaml` [core.yaml详细内容](#1)
* 在chaincode/下 新建`org4-peer0`文件夹 进入再新建（自定义的合约名称，可参考org3-peer0里的内容） `sampleChaincode`文件夹 进入新建`main.go`（链码） 再新建`external`文件夹（用于打包合约）进入创建`connection.json`和`metadata.json` [connection.json 详细内容](#2) [metadata.json 详细内容](#3)
* 在config/下 新建 `org4-configtx`文件夹 进入再新建 `configtx.yaml`作为org4的configtx [configtx.yaml 详细内容](#configtx)
* 在config/cryptogen/下 新建`crypto-config-org4.yaml`文件 [crypto-config-org4.yaml 详细内容](#crypto-config-org4)
 #### 需要修改的地方

 <span id="configtx"></span>

* `configtx.yaml`:
```
Organizations:
    - &Org4
        # DefaultOrg defines the organization which is used in the sampleconfig
        # of the fabric.git development environment
        Name: Org4MSP

        # ID to load the MSP definition as
        ID: Org4MSP

        MSPDir: ../crypto-config/peerOrganizations/org4.example.com/msp

        # Policies defines the set of policies at this level of the config tree
        # For organization policies, their canonical path is usually
        #   /Channel/<Application|Orderer>/<OrgName>/<PolicyName>
        Policies:
            Readers:
                Type: Signature
                Rule: "OR('Org4MSP.member')"
            Writers:
                Type: Signature
                Rule: "OR('Org4MSP.member')"
            Admins:
                Type: Signature
                Rule: "OR('Org4MSP.admin')"
            Endorsement:
                Type: Signature
                Rule: "OR('Org4MSP.member')"
        
        AnchorPeers:
            - Host: peer0.org4.example.com
              Port: 10050

```
 <span id="crypto-config-org4"></span>
[回到动态加入org](#dynamic_join)

 * `crypto-config-org4`: 这里设置了2个peer
```
PeerOrgs:
  - Name: Org4
    Domain: org4.example.com
    EnableNodeOUs: false
    Template:
      Count: 2
    Users:
      Count: 1
```
* `cryptogen generate --config=./config/cryptogen/crypto-config-org4.yaml --output=./config/crypto-config` 生成组织文件
* `cd config/org4-configtx/`进入org4的configtx `configtxgen -printOrg Org4MSP > ../crypto-config/peerOrganizations/org4.example.com/msp/org4.json` 生成org4的msp 
*  `cd ../../` 回到根目录 , 使用org1的配置
```
    export FABRIC_CFG_PATH=$(pwd)/config/peer/org1-peer0/
    export CORE_PEER_ID=peer0.org1.example.com
    export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=Org1MSP
    export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
```
* 获取最新的配置块
* `peer channel fetch config ./channel-artifacts/config_block.pb -o orderer.example.com:7050 -c mychannel --tls --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem` 
* 进入通道文件夹 `cd channel-artifacts`
* 将配置转换为JSON并将其修剪下来
*  `configtxlator proto_decode --input config_block.pb --type common.Block --output config_block.json` `jq ".data.data[0].payload.data.config" config_block.json > config.json` 
*  添加org4锚节点和MSP配置
* `jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"Org4MSP":.[1]}}}}} | .channel_group.groups.Application.groups.Org4MSP.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "peer0.org4.example.com","port": 10050}]},"version": "0"}}' config.json ../config/crypto-config/peerOrganizations/org4.example.com/msp/org4.json > modified_config.json`
* 现在可以将原始和修改后的通道配置转换回protobuf格式，并计算它们之间的差异
* `configtxlator proto_encode --input config.json --type common.Config --output config.pb`
* `configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb`
* `configtxlator compute_update --channel_id mychannel --original config.pb --updated modified_config.pb --output config_update.pb`
* `configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate | jq . > config_update.json`
* `echo '{"payload":{"header":{"channel_header":{"channel_id":"mychannel","type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . > config_update_in_envelope.json`
* `configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output config_update_in_envelope.pb`
* 回到根目录 `cd ..` 
* org1进行签名
* `peer channel signconfigtx -f channel-artifacts/config_update_in_envelope.pb` 
* 之后切换加入通道的org的peer0配置，都进行签名，最后一个进行更新操作
* `peer channel update -f channel-artifacts/config_update_in_envelope.pb -c mychannel -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem`
* `sudo gedit /etc/hosts `添加 `127.0.0.1   peer0.org4.example.com`
* 下面使用peer channel fetch命令拉取创世区块：
* `peer channel fetch 0 channel-artifacts/mychannel.block -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c mychannel --tls --cafile "$(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"`
* 这时候可以启动org4peer0的节点了，并切换他的环境
* `sh org4-peer0.sh` 
* 加入通道
* `peer channel join -b channel-artifacts/mychannel.block`
* `cd chaincode/org4-peer0/sampleChaincode/external`
* 打包 安装 build 链码
* [打包 安装 build 链码 详细内容](#chaincode)
* 回到根目录 `cd ../../../../`
* 批准链码
```
peer lifecycle chaincode approveformyorg \
        -o orderer.example.com:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --channelID mychannel \
        --name sample \
        --version 1 \
        --package-id $PACKAGE_ID \
        --sequence 1 \
        --init-required \
        --tls \
        --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
		
```
* 初始化链码
```
peer chaincode invoke \
  -o orderer.example.com:7050 \
  -C "mychannel" \
  -n "sample" \
  --isInit \
  --tls true \
  --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
  --peerAddresses peer0.org1.example.com:7051 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
  --peerAddresses peer0.org2.example.com:8050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
  --peerAddresses peer1.org2.example.com:8052 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt \
  --peerAddresses peer0.org3.example.com:9050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt \
  --peerAddresses peer0.org4.example.com:10050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt \
  -c '{"Args":[]}'
  ```
* 设置c
```
  peer chaincode invoke \
  -o orderer.example.com:7050 \
  -C "mychannel" \
  -n "sample" \
  --tls true \
  --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
  --peerAddresses peer0.org1.example.com:7051 \
  --tlsRootCertFiles /home/jamnly/fabric-2.2/fabric-native-network/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
  --peerAddresses peer0.org2.example.com:8050 \
  --tlsRootCertFiles /home/jamnly/fabric-2.2/fabric-native-network/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
  --peerAddresses peer0.org3.example.com:9050 \
  --tlsRootCertFiles /home/jamnly/fabric-2.2/fabric-native-network/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt \
  --peerAddresses peer0.org4.example.com:10050 \
  --tlsRootCertFiles /home/jamnly/fabric-2.2/fabric-native-network/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt \
  -c '{"function":"create","Args":["c","20"]}'
  ```
* 查询c
* `  peer chaincode query -C mychannel -n sample -c '{"Args":["read","c"]}'`
* 查询的时候也可以带上证书，这样org1peer0那边的链码也会进行查询，也可以多带几个证书
```peer chaincode query -C mychannel -n sample -c '{"Args":["read","b"]}' /
--peerAddresses peer0.org1.example.com:7051 /
--tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt 
```

## 增加peer
* 假设增加peer1.org4.example.com
* 以下端口会占用10052 10053 7000！
* 检查端口是否被占用
**同一个组织下的peer统一使用peer0的链码**
```
lsof -i :10052
lsof -i :10053
lsof -i :7000

```

<span id=static_join_peer></span>

### 静态加入peer

* 在当前目录下 新建 `org4-peer1.sh` [org4-peer1.sh 详细内容](#org4-peer1.sh)
* 在config/peer/下 新建`org4-peer1`文件夹 进入再新建（最好是复制org3-peer1）的core.yaml文件 `core.yaml`[org4-peer1-core 详细内容](#org4-peer1-core)
* 在chaincode/下 保证有`org4-peer0`文件夹 里面要有org4peer0的链码
 #### 需要修改的地方

<span id="org4-peer1.sh"> </span>

* `org4-peer1.sh`:
```
echo "######org4 peer1 startup start######"
echo "current path: $(pwd)"
echo "remove data/peer"
rm -rf ./data/peer/org4-peer1

export FABRIC_CFG_PATH=$(pwd)/config/peer/org4-peer1/


export FABRIC_LOGGING_SPEC=INFO
# export FABRIC_LOGGING_SPEC=DEBUG
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_PROFILE_ENABLED=true

# Peer specific variables
export CORE_PEER_ID=peer1.org4.example.com
export CORE_PEER_ADDRESS=peer1.org4.example.com:10052
export CORE_PEER_LISTENADDRESS=0.0.0.0:10052
export CORE_PEER_CHAINCODEADDRESS=peer1.org4.example.com:10053
export CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:10053
export CORE_PEER_GOSSIP_BOOTSTRAP=peer1.org4.example.com:10052
export CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer1.org4.example.com:10052
export CORE_PEER_LOCALMSPID=Org4MSP
export CORE_OPERATIONS_LISTENADDRESS=peer1.org4.example.com:11543

# Peer certificates and keys
export CORE_PEER_TLS_CERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp/tlscacerts/tlsca.org4.example.com-cert.pem
export CORE_PEER_TLS_CLIENTROOTCAS_FILES=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp
# Ledger state database path
export CORE_PEER_FILESYSTEMPATH=$(pwd)/data/peer/org4-peer1

# Start the peer node
peer node start

```
* `peer.sh`:添加内容
```
# 设置 peer1.org4.example.com 的环境变量
setPeerOrg4Peer1() {
    export FABRIC_CFG_PATH=$(pwd)/config/peer/org4-peer1/
    export CORE_PEER_ID=peer1.org4.example.com
    export CORE_PEER_ADDRESS=peer1.org4.example.com:10052
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=Org4MSP
    export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp
    export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/ca.crt
}
```
* `join_channel.sh`:添加内容 
```
# 定义组织及其对应的 Peer 数量
declare -A ORG_PEER_COUNT=(
  ["Org1"]=1  # Org1 有 1 个 Peer
  ["Org2"]=2  # Org2 有 2 个 Peer
  ["Org3"]=1  # Org3 有 1 个 Peer
  ["Org4"]=2  # Org4 有 2 个 Peer
)

# 定义每个组织的 Peer 设置函数
declare -A PEER_SET_FUNCTIONS=(
  ["Org1peer0"]="setPeerOrg1Peer0"  # Org1 的 Peer 0
  ["Org2peer0"]="setPeerOrg2Peer0"  # Org2 的 Peer 0
  ["Org2peer1"]="setPeerOrg2Peer1"  # Org2 的 Peer 1
  ["Org3peer0"]="setPeerOrg3Peer0"  # Org3 的 Peer 0
  ["Org4peer0"]="setPeerOrg4Peer0"  # Org4 的 Peer 0
  ["Org4peer1"]="setPeerOrg4Peer1"  # Org4 的 Peer 1
)

```
* `approveformyorg_chaincode.sh`:添加内容 
```
# 定义组织及其对应的 Peer 数量
declare -A ORG_PEER_COUNT=(
  ["Org1"]=1  # Org1 有 1 个 Peer
  ["Org2"]=1  # Org2 有 2 个 Peer
  ["Org3"]=1  # Org3 有 1 个 Peer
  ["Org4"]=2  # Org4 有 2 个 Peer
)

# 定义每个组织的 Peer 设置函数
declare -A PEER_SET_FUNCTIONS=(
  ["Org1peer0"]="setPeerOrg1Peer0"  # Org1 的 Peer 0
  ["Org2peer0"]="setPeerOrg2Peer0"  # Org2 的 Peer 0
  ["Org2peer1"]="setPeerOrg2Peer1"  # Org2 的 Peer 1
  ["Org3peer0"]="setPeerOrg3Peer0"  # Org3 的 Peer 0
  ["Org4Peer0"]="setPeerOrg4Peer0"  # Org4 的 Peer 0
  ["Org4Peer1"]="setPeerOrg4Peer1"  # Org4 的 Peer 1
)

# 定义链码路径
declare -A CC_SRC_PATHS=(
  ["Org1peer0"]="$(pwd)/chaincode/org1-peer0/sampleChaincode/external/"
  ["Org2peer0"]="$(pwd)/chaincode/org2-peer0/sampleChaincode/external/"
  ["Org2peer1"]="$(pwd)/chaincode/org2-peer1/sampleChaincode/external/"
  ["Org3peer0"]="$(pwd)/chaincode/org3-peer0/sampleChaincode/external/"
  ["Org4Peer0"]="$(pwd)/chaincode/org4-peer0/sampleChaincode/external/"
  ["Org4Peer1"]="$(pwd)/chaincode/org4-peer1/sampleChaincode/external/"
)
```

<span id="org4-peer1-core"></span>
[回到静态加入peer](#static_join_peer)

* 在config/peer/org4-peer1 下 `core.yaml`:添加内容 
```

peer:

    id: peer1.org4.example.com

    networkId: dev

    listenAddress: peer1.org4.example.com:10052

    chaincodeListenAddress: peer1.org4.example.com:10053

    chaincodeAddress: peer1.org4.example.com:10053

    address: peer1.org4.example.com:10052

    addressAutoDetect: false

    keepalive:
        interval: 7200s
        timeout: 20s
        minInterval: 60s
        client:
            interval: 60s
            timeout: 20s
        deliveryClient:
            interval: 60s
            timeout: 20s


    gossip:
        bootstrap: peer0.org3.example.com:9050,peer0.org2.example.com:8050,peer0.org1.example.com:7051,peer0.org4.example.com:10050,peer1.org4.example.com:10052


        useLeaderElection: false
        orgLeader: true

        membershipTrackerInterval: 5s

        endpoint:
        maxBlockCountToStore: 10
        maxPropagationBurstLatency: 10ms
        maxPropagationBurstSize: 10
        propagateIterations: 1
        propagatePeerNum: 3
        pullInterval: 4s
        pullPeerNum: 3
        requestStateInfoInterval: 4s
        publishStateInfoInterval: 4s
        stateInfoRetentionInterval:
        publishCertPeriod: 10s
        skipBlockVerification: false
        dialTimeout: 3s
        connTimeout: 2s
        recvBuffSize: 20
        sendBuffSize: 200
        digestWaitTime: 1s
        requestWaitTime: 1500ms
        responseWaitTime: 2s
        aliveTimeInterval: 5s
        aliveExpirationTimeout: 25s
        reconnectInterval: 25s
        maxConnectionAttempts: 120
        msgExpirationFactor: 20
        externalEndpoint:
        election:
            startupGracePeriod: 15s
            membershipSampleInterval: 1s
            leaderAliveThreshold: 10s
            leaderElectionDuration: 5s

        pvtData:
            pullRetryThreshold: 60s
            transientstoreMaxBlockRetention: 1000
            pushAckTimeout: 3s
            btlPullMargin: 10
            reconcileBatchSize: 10
            reconcileSleepInterval: 1m
            reconciliationEnabled: true
            skipPullingInvalidTransactionsDuringCommit: false
            implicitCollectionDisseminationPolicy:
               requiredPeerCount: 0
               maxPeerCount: 1

        state:
            enabled: false
            checkInterval: 10s
            responseTimeout: 3s
            batchSize: 10
            blockBufferSize: 20
            maxRetries: 3

    tls:
        enabled:  true
        clientAuthRequired: false
        cert:
            file: ../../crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/server.crt
        key:
            file: ../../crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/server.key
        rootcert:
            file: ../../crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp/tlscacerts/tlsca.org4.example.com-cert.pem
        clientRootCAs:
            files:
              - ../../crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/ca.crt
        clientKey:
            file:
        clientCert:
            file:

    authentication:
        timewindow: 15m

    fileSystemPath: data/peer

    BCCSP:
        Default: SW
        SW:
            Hash: SHA2
            Security: 256
            FileKeyStore:
                KeyStore:
        PKCS11:
            Library:
            Label:
            Pin:
            Hash:
            Security:

    mspConfigPath: ../../crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp

    localMspId: Org4MSP

    client:
        connTimeout: 3s

    deliveryclient:
        reconnectTotalTimeThreshold: 3600s

        connTimeout: 3s

        reConnectBackoffThreshold: 3600s

        addressOverrides:

    localMspType: bccsp

    profile:
        enabled:     true
        listenAddress: 0.0.0.0:6065

    handlers:
        authFilters:
          -
            name: DefaultAuth
          -
            name: ExpirationCheck    # This filter checks identity x509 certificate expiration
        decorators:
          -
            name: DefaultDecorator
        endorsers:
          escc:
            name: DefaultEndorsement
            library:
        validators:
          vscc:
            name: DefaultValidation
            library:

    validatorPoolSize:

    discovery:
        enabled: true
        authCacheEnabled: true
        authCacheMaxSize: 1000
        authCachePurgeRetentionRatio: 0.75
        orgMembersAllowedAccess: false

    limits:
        concurrency:
            endorserService: 2500
            deliverService: 2500

vm:

    endpoint: 

    docker:
        tls:
            enabled: false
            ca:
                file: docker/ca.crt
            cert:
                file: docker/tls.crt
            key:
                file: docker/tls.key

        attachStdout: false

        hostConfig:
            NetworkMode: host
            Dns:
            LogConfig:
                Type: json-file
                Config:
                    max-size: "50m"
                    max-file: "5"
            Memory: 2147483648

chaincode:

    id:
        path:
        name:

    builder: hyperledger/fabric-ccenv:2.2.0

    pull: false

    golang:
        runtime: hyperledger/fabric-baseos:2.2.0

        dynamicLink: false

    java:
        runtime: $(DOCKER_NS)/fabric-javaenv:$(TWO_DIGIT_VERSION)

    node:
        runtime: $(DOCKER_NS)/fabric-nodeenv:$(TWO_DIGIT_VERSION)

    externalBuilders: 
      - name: simple
        path: ./external
        propagateEnvironment:
         - ../../crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/ca.crt
         - ../../crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/server.crt
         - ../../crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/server.key
         - ../../crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/msp/tlscacerts/tlsca.org4.example.com-cert.pem

    installTimeout: 300s

    startuptimeout: 300s

    executetimeout: 30s

    mode: net

    keepalive: 0

    system:
        _lifecycle: enable
        cscc: enable
        lscc: enable
        escc: enable
        vscc: enable
        qscc: enable

    logging:
      level:  info
      shim:   warning
      format: '%{color}%{time:2006-01-02 15:04:05.000 MST} [%{module}] %{shortfunc} -> %{level:.4s} %{id:03x}%{color:reset} %{message}'

ledger:

  blockchain:

  state:
    stateDatabase: goleveldb
    totalQueryLimit: 100000
    couchDBConfig:
       couchDBAddress: 127.0.0.1:5984
       username:
       password:
       maxRetries: 3
       maxRetriesOnStartup: 10
       requestTimeout: 35s
       internalQueryLimit: 1000
       maxBatchUpdateSize: 1000
       warmIndexesAfterNBlocks: 1
       createGlobalChangesDB: false
       cacheSize: 64

  history:
    enableHistoryDatabase: true

  pvtdataStore:
    collElgProcMaxDbBatchSize: 5000
    collElgProcDbBatchesInterval: 1000

operations:
    listenAddress: 127.0.0.1:9443

    tls:
        enabled: false

        cert:
            file:

        key:
            file:

        clientAuthRequired: false

        clientRootCAs:
            files: []

metrics:
    provider: disabled

    statsd:
        network: udp

        address: 127.0.0.1:8125

        writeInterval: 10s

        prefix:
```
* 在config/cryptogen 下 `cryto-config.yaml`:修改内容 
```
- Name: Org4
    Domain: org4.example.com
    EnableNodeOUs: false
    Template:
      Count: 2
    Users:
      Count: 1
```

* 以下前提为安装了peer0.org4！，如果你想添加的别的peer，别按照下面的来哦
* 执行`sh generate-config-file.sh`创建证书，创世块、通道文件和锚点文件等
* 执行`sh orderer.sh`启动orderer节点
* 执行`sh org1-peer0.sh`启动peer0.org1节点
* 执行`sh org2-peer0.sh`启动peer0.org2节点
* 执行`sh org2-peer1.sh`启动peer1.org2节点
* 执行`sh org3-peer0.sh`启动peer0.org3节点
* 执行`sh org4-peer0.sh`启动peer0.org4节点
* 执行`sh create_channel1.sh`创建通道
* 执行`bash join_channel.sh`加入通道
* 执行`bash approveformyorg_chaincode.sh`安装链码、批准链码、提交链码、并输出所有链码ID
* 前往 `cd chaincode/org1-peer0/sampleChaincode` 执行`./sample` 启动peer0.org1的链码
* 前往 `cd chaincode/org2-peer0/sampleChaincode` 执行`./sample` 启动peer0.org2的链码
* 前往 `cd chaincode/org2-peer1/sampleChaincode` 执行`./sample` 启动peer1.org2的链码
* 前往 `cd chaincode/org3-peer0/sampleChaincode` 执行`./sample` 启动peer0.org3的链码
* 前往 `cd chaincode/org4-peer0/sampleChaincode` 执行`./sample` 启动peer0.org4的链码
**由于org4peer1属于org4，所以只能使用org4peer0的链码**
* 所以直接去[这里](#chaincode) 去到org4-peer4的链码文件那 install就可以了
* 初始化 （如果org4peer0初始化过了也就不用了）
```
peer chaincode invoke \
  -o orderer.example.com:7050 \
  -C "mychannel" \
  -n "sample" \
  --isInit \
  --tls true \
  --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
  --peerAddresses peer0.org1.example.com:7051 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
  --peerAddresses peer0.org2.example.com:8050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
  --peerAddresses peer0.org3.example.com:9050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt \
  --peerAddresses peer0.org4.example.com:10050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt \
  -c '{"Args":[]}'

```
* 设置b属性
```
  peer chaincode invoke \
  -o orderer.example.com:7050 \
  -C "mychannel" \
  -n "sample" \
  --tls true \
  --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
  --peerAddresses peer0.org1.example.com:7051 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
  --peerAddresses peer0.org2.example.com:8050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
  --peerAddresses peer0.org3.example.com:9050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt \
  --peerAddresses peer0.org4.example.com:10050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt \
  -c '{"function":"create","Args":["b","20"]}'
```
* 查询b
* `peer chaincode query -C mychannel -n sample -c '{"Args":["read","b"]}' `
### 动态加入peer
* 假设动态加入 `org4peer1`
* 即不执行`sh generate-config-file.sh`重新创建 
**前提得有org4-peer0已经加入了！**
* 在当前目录下 新建 `org4-peer1.sh` [org4-peer1.sh 详细内容](#org4-peer1.sh)
* 在config/peer/下 新建`org4-peer1`文件夹 进入再新建（最好是复制org3-peer1）的core.yaml文件 `core.yaml`[org4-peer1-core 详细内容](#org4-peer1-core)
* 在chaincode/下 保证有`org4-peer0`文件夹 里面要有org4peer0的链码
* 使用`peer.sh` 里的 org4-peer1 的环境变量
```
export FABRIC_CFG_PATH=$(pwd)/config/peer/org4-peer1/
    export CORE_PEER_ID=peer1.org4.example.com
    export CORE_PEER_ADDRESS=peer1.org4.example.com:10052
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=Org4MSP
    export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/users/Admin@org4.example.com/msp
    export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer1.org4.example.com/tls/ca.crt
```
* 使用peer channel fetch命令拉取创世区块：
* `peer channel fetch 0 channel-artifacts/mychannel.block -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c mychannel --tls --cafile "$(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"`
* 加入通道
* `peer channel join -b channel-artifacts/mychannel.block`
**由于org4peer1属于org4，所以只能使用org4peer0的链码**
* 所以直接去[这里](#chaincode) 去到org4-peer4的链码文件那 install就可以了
* 初始化 （如果org4peer0初始化过了也就不用了）
```
peer chaincode invoke \
  -o orderer.example.com:7050 \
  -C "mychannel" \
  -n "sample" \
  --isInit \
  --tls true \
  --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
  --peerAddresses peer0.org1.example.com:7051 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
  --peerAddresses peer0.org2.example.com:8050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
  --peerAddresses peer0.org3.example.com:9050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt \
  --peerAddresses peer0.org4.example.com:10050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt \
  -c '{"Args":[]}'

```
* 设置c属性
```
  peer chaincode invoke \
  -o orderer.example.com:7050 \
  -C "mychannel" \
  -n "sample" \
  --tls true \
  --cafile $(pwd)/config/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
  --peerAddresses peer0.org1.example.com:7051 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
  --peerAddresses peer0.org2.example.com:8050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
  --peerAddresses peer0.org3.example.com:9050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt \
  --peerAddresses peer0.org4.example.com:10050 \
  --tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org4.example.com/peers/peer0.org4.example.com/tls/ca.crt \
  -c '{"function":"create","Args":["c","20"]}'
```
* 查询c
* `peer chaincode query -C mychannel -n sample -c '{"Args":["read","c"]}' `
* 查询的时候也可以带上证书，这样org1peer0那边的链码也会进行查询，也可以多带几个证书
```peer chaincode query -C mychannel -n sample -c '{"Args":["read","b"]}' /
--peerAddresses peer0.org1.example.com:7051 /
--tlsRootCertFiles $(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt 
```

## 改变通道名称
* 默认是mychannel 想要更改的话，需要更改以下三个文件包括invoke之后的命令
* `create_channel1.sh` `join_channel.sh` `approveformyorg_chaincode.sh` 中的 CHANNEL_NAME

<span id="chaincode"> </span>

## 打包 安装 build 链码 
* 必须保证go版本要在1.21以上
* 打包路径一般为 `chaincode/org4-peer0/sampleChaincode/external` 下有`connection.json`和`metadata.json`文件[connection.json 详细内容](#2) [metadata.json 详细内容](#3)
* 打包链码
* `tar cfz code.tar.gz connection.json ` `tar cfz sample.tgz metadata.json code.tar.gz`
* 安装链码(需要先切换成需要安装链码的peer环境)
* `peer lifecycle chaincode install sample.tgz`
* 查询链码
* `peer lifecycle chaincode queryinstalled`
* 出现如 Package ID: sample:xxx, Label: sample
* `export PACKAGE_ID=sample:xxx`
* build 链码
* `cd ../` 
* `go mod init sample` 这里的sample可以自定义
* `go mod tidy`
* `go build` 之后会生成一个sample文件
* `./sample` 启动合约
# 非容器化部署 hyperledger explorer
* 官方地址: https://github.com/hyperledger-labs/blockchain-explorer/tree/main
* 安装版本: 2.0.0 支持的fabric版本: 2.2~2.5  支持NodeJS:^12.13.1,^14.13.1,^16.14.1  
  <br>
* 先决条件:
* Nodejs:^12.13.1,^14.13.1,^16.14.1
* PostgreSQL 9.5 或更高版本
* jq
## 克隆 GIT 存储库
* `git clone https://github.com/hyperledger/blockchain-explorer.git`
* `cd blockchain-explorer`
## 安装PostgreSQL
* 以下为ubuntu的安装方法，参考:https://blog.csdn.net/qq_36973384/article/details/142363304
* 执行更新命令 `sudo apt update`
* postgresql安装命令 `sudo apt install postgresql`
* 修改postgresql密码命令 `sudo passwd postgres`
## 数据库设置
* `cd blockchain-explorer/app`
* 修改 app/explorerconfig.json 以更新 PostgreSQL 数据库设置。
```
"postgreSQL": {
    "host": "127.0.0.1",
    "port": "5432",
    "database": "fabricexplorer",
    "username": "hppoc",
    "passwd": "password"
}
```
* 配置数据库设置的另一种替代方法是使用环境变量
```
export DATABASE_HOST=127.0.0.1
export DATABASE_PORT=5432
export DATABASE_DATABASE=fabricexplorer
export DATABASE_USERNAME=hppoc
export DATABASE_PASSWD=pass12345
```
* 每次 git pull 后都要重复（在某些情况下，你可能需要向 db/ 目录应用权限，从 blockchain-explorer/app/persistence/fabric/postgreSQL 运行：chmod -R 775 db/
## 更新配置
* 修改 `app/platform/fabric/config.json`
  * 假设组织有3个
```
{
	"network-configs": {
		"org1-network": {
			"name": "org1-network",
			"profile": "./connection-profile/org1-network.json",
			"bootMode": "ALL",
			"noOfBlocks": 0
		},
		"org2-network": {
			"name": "org2-network",
			"profile": "./connection-profile/org2-network.json",
			"bootMode": "ALL",
			"noOfBlocks": 0
		},
		"org3-network": {
			"name": "org3-network",
			"profile": "./connection-profile/org3-network.json",
			"bootMode": "ALL",
			"noOfBlocks": 0
		}
	},
	"license": "Apache-2.0"
}
```
  * `test-network` 是连接配置文件的名称，可以更改为任何名称
  * `name`是您想要为 Fabric 网络指定的名称。您可以更改键名称的唯一值
  * `profile`是 Connection 配置文件的位置。您可以更改密钥配置文件的唯一值
* 在 JSON 文件中 `app/platform/fabric/connection-profile/test-network.json` 修改连接配置文件 ：
  * 将`test-network.json`复制三份分别取名为`org1-network.json`,`org2-network.json`,`org3-network.json`
  * 假设org2有peer0和peer1，以下为`org2-network.json`的配置:
```
{
	"name": "org2-network",
	"version": "1.0.0",
	"license": "Apache-2.0",
	"client": {
		"tlsEnable": true,
		"adminCredential": {
			"id": "exploreradmin",
			"password": "exploreradminpw"
		},
		"enableAuthentication": true,
		"organization": "Org2MSP",
		"connection": {
			"timeout": {
				"peer": {
					"endorser": "300"
				},
				"orderer": "300"
			}
		}
	},
	"channels": {
		"mychannel": {
			"peers": {
				"peer0.org2.example.com": {},
				"peer1.org2.example.com": {}
			},
			"connection": {
				"timeout": {
					"peer": {
						"endorser": "6000",
						"eventHub": "6000",
						"eventReg": "6000"
					}
				}
			}
		}
	},
	"organizations": {
		"Org2MSP": {
			"mspid": "Org2MSP",
			"adminPrivateKey": {
				"path": "/home/jamnly/fabric-2.2/fabric-native-network/config/crypto-config/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/keystore/priv_sk"
			},
			"peers": ["peer0.org2.example.com"],
			"signedCert": {
				"path": "/home/jamnly/fabric-2.2/fabric-native-network/config/crypto-config/peerOrganizations/org2.example.com/users/User1@org2.example.com/msp/signcerts/User1@org2.example.com-cert.pem"
			}
		}
	},
	"peers": {
		"peer0.org2.example.com": {
			"tlsCACerts": {
				"path": "/home/jamnly/fabric-2.2/fabric-native-network/config/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt"
			},
			"url": "grpcs://peer0.org2.example.com:8050",
			"grpcOptions": {
				"ssl-target-name-override": "peer0.org2.example.com"
			}
		},
		"peer1.org2.example.com": {
			"tlsCACerts": {
				"path": "/home/jamnly/fabric-2.2/fabric-native-network/config/crypto-config/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt"
			},
			"url": "grpcs://peer1.org2.example.com:8052",
			"grpcOptions": {
				"ssl-target-name-override": "peer1.org2.example.com"
			}
		}
		
	}
}
```
* 需要对路径和端口进行修改
* `exploreradmin` 和 `exploreradminpw` 是 Explorer 用户登录 dashboard 的凭证
* `enableAuthentication` 是使用登录页面启用身份验证的标志。设置为 false 将跳过身份验证。
* 更多配置内容见: https://github.com/hyperledger-labs/blockchain-explorer/blob/main/README-CONFIG.md
## 创建数据库
* **Ubuntu**

    ```
    $ cd blockchain-explorer/app/persistence/fabric/postgreSQL/db
    $ sudo -u postgres ./createdb.sh
    ```

* **MacOS**

    ```
    $ cd blockchain-explorer/app/persistence/fabric/postgreSQL/db
    $ ./createdb.sh
    $ createdb `whoami`
    ```
* 连接到 PostgreSQL 数据库并运行 DB status 命令。要将设置从 `app/explorerconfig.json` 导出到环境，请运行 `source app/exportConfig.sh`;这将设置 `$DATABASE_DATABASE` 和相关 envvars。
* **Ubuntu**

    ```shell
    sudo -u postgres psql -c '\l'
    sudo -u postgres psql $DATABASE_DATABASE -c '\d'
    ```

* **MacOS**

    ```shell
    psql -c '\l'
    psql $DATABASE_DATABASE -c '\d'
    ```

* 预期输出
```shell
$ sudo -u postgres psql -c '\l'
                                     List of databases
      Name      |        Owner        | Encoding | Collate |  Ctype  |   Access privileges
----------------+---------------------+----------+---------+---------+-----------------------
 fabricexplorer | $DATABASE_USERNAME  | UTF8     | C.UTF-8 | C.UTF-8 |
 postgres       | postgres            | UTF8     | C.UTF-8 | C.UTF-8 |
 template0      | postgres            | UTF8     | C.UTF-8 | C.UTF-8 | =c/postgres          +
                |                     |          |         |         | postgres=CTc/postgres
 template1      | postgres            | UTF8     | C.UTF-8 | C.UTF-8 | =c/postgres          +
                |                     |          |         |         | postgres=CTc/postgres
(4 rows)

$ sudo -u postgres psql $DATABASE_DATABASE -c '\d'
                   List of relations
 Schema |           Name            |   Type   |       Owner
--------+---------------------------+----------+-------------------
 public | blocks                    | table    | $DATABASE_USERNAME
 public | blocks_id_seq             | sequence | $DATABASE_USERNAME
 public | chaincodes                | table    | $DATABASE_USERNAME
 public | chaincodes_id_seq         | sequence | $DATABASE_USERNAME
 public | channel                   | table    | $DATABASE_USERNAME
 public | channel_id_seq            | sequence | $DATABASE_USERNAME
 public | orderer                   | table    | $DATABASE_USERNAME
 public | orderer_id_seq            | sequence | $DATABASE_USERNAME
 public | peer                      | table    | $DATABASE_USERNAME
 public | peer_id_seq               | sequence | $DATABASE_USERNAME
 public | peer_ref_chaincode        | table    | $DATABASE_USERNAME
 public | peer_ref_chaincode_id_seq | sequence | $DATABASE_USERNAME
 public | peer_ref_channel          | table    | $DATABASE_USERNAME
 public | peer_ref_channel_id_seq   | sequence | $DATABASE_USERNAME
 public | transactions              | table    | $DATABASE_USERNAME
 public | transactions_id_seq       | sequence | $DATABASE_USERNAME
 public | write_lock                | table    | $DATABASE_USERNAME
 public | write_lock_write_lock_seq | sequence | $DATABASE_USERNAME
(18 rows)

```
* （在 MacOS 上，期望看到您的“whoami”而不是 postgres。带有 $DATABASE_USERNAME 的条目将具有该参数的 valuei，无论是设置为环境变量还是 JSON keyval;它不会显示 Literal String。
## 改变数据库
* 更改为kingbase数据库
* 首先要删除掉`/wallet`内的内容
* 修改`/app`内`explorerconfig.json`内的配置
* 启动kingbase的时候记得DB_MODE=pg
* 使用脚本创建数据库
* 完成
### ubuntu手动创建方法
* 当以上方法无法创建时 （排除node版本的问题）
* 可以试试以下方法:
* 进到执行脚本文件 `blockchain-explorer/app/persistence/fabric/postgreSQL/db`
* 通过修改脚本文件来创建数据库,以下是重写的脚本文件，命名为1.sh:
```
#!/bin/bash

# SPDX-License-Identifier: Apache-2.0

echo "Setting ENV variables directly..."
export USER="hppoc"
export DATABASE="fabricexplorer"
export PASSWD='password'

echo "USER=${USER}"
echo "DATABASE=${DATABASE}"
echo "PASSWD=${PASSWD}"


# 生成替换后的临时 SQL 脚本
TEMP_SQL_FILE="./temp_script.sql"
sed "s/:user/${USER}/g; s/:passwd/'${PASSWD}'/g; s/:dbname/${DATABASE}/g" ./explorerpg.sql > ${TEMP_SQL_FILE}


echo "Executing SQL scripts, OS="$OSTYPE

# support for OS
case $OSTYPE in
darwin*) 
    psql postgres -f ${TEMP_SQL_FILE} ;;
linux*)
    if [ $(id -un) = 'postgres' ]; then
        PSQL="psql"
    else
        PSQL="sudo -u postgres psql"
    fi
    ${PSQL} -f ${TEMP_SQL_FILE} ;;
esac

# 清理临时文件
rm ${TEMP_SQL_FILE}
```
* 需要根据之前设置的数据库配置文件来更新环境配置
* 接下来要获取postgres的路径
* 进入postgres用户 `sudo -u postgres -i`
* 获取当前路径 `pwd`
* 假设获取的路径是 `/var/lib/postgresql` 退出 `exit`
* 复制脚本和sql文件到postgres用户 `sudo cp ./ /var/lib/postgresql/`
* 再进入postgres用户执行脚本 `sudo -u postgres -i` `./1.sh`
## 构建 Hyperledger Explorer
  **重要提示：在每次修改配置之后重复以下步骤**
* 从存储库的根目录：
  * `./main.sh clean`
    * 清理 /node_modules、client/node_modules client/build、client/coverage、app/test/node_modules 目录
  * `./main.sh install`
    * 安装、运行测试和构建项目

或
```
 cd blockchain-explorer
 npm install
 cd client/
 npm install
 npm run build
```
## 运行hyperledger explorer
* 启动fabric网络
* 在根目录 ` cd blockchain-explorer`
* 执行`./start.sh`
* 日志会存储在`logs/console/`里
* 网页为`http://localhost:8080/#/`
## 其他
* 报错[ERROR] Sync - Error : [ 'Channel name [%s] already exist in DB , Kindly re-run the DB scripts to proceed',
'*****' ]
Error : [ 'Explorer is closing due to channel name [%s] is already exist in DB'...]
  * 进入用户 `su - postgres`
  * 进入 postgresql `psql`
  * 查看数据库列表 `\l`
  * 进入fabricexplorer数据库里面 `\c fabricexplorer `
  * 表示展示数据库中的表信息 `\d`
  * 查询channel表信息 ` select * from channel;`
  * 删除报错的channel `delete from channel where name = 'mychannel';`
* 报错[2024-11-03T15:34:22.791] [ERROR] FabricGateway - Failed to create wallet, please check the configuration, and valid file paths: {}
[2024-11-03T15:34:22.791] [ERROR] FabricClient - ExplorerError {
  name: 'ExplorerError',
  message: '[\n' +
    "  'Failed to create wallet, please check the configuration, and valid file paths'\n" +
    ']'
}
[2024-11-03T15:34:22.792] [ERROR] main - <<<<<<<<<<<<<<<<<<<<<<<<<< Explorer Error >>>>>>>>>>>>>>>>>>>>>
[2024-11-03T15:34:22.792] [ERROR] main - Error :  [ 'Invalid platform configuration, Please check the log' ]
  * 可能需要手动创建文件夹，在根目录上 ` -p wallet/org1-network `
  * 这种一般是配置连接文件的问题，仔细检查MSP的名称，还有如果一个组织下有多个peer，需要将组织下的所有peer都加入
# 非容器化部署 couchdb
* 官方文档: https://docs.couchdb.org/en/stable/install/unix.html#installation-using-the-apache-couchdb-convenience-binary-packages
## ubuntu 安装
* 启用 Apache CouchDB 软件包存储库
```
sudo apt update && sudo apt install -y curl apt-transport-https gnupg
curl https://couchdb.apache.org/repo/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/couchdb-archive-keyring.gpg >/dev/null 2>&1
source /etc/os-release
echo "deb [signed-by=/usr/share/keyrings/couchdb-archive-keyring.gpg] https://apache.jfrog.io/artifactory/couchdb-deb/ ${VERSION_CODENAME} main" \
    | sudo tee /etc/apt/sources.list.d/couchdb.list >/dev/null
```
*  安装 Apache CouchDB 软件包
```
sudo apt update
sudo apt install -y couchdb
```
* 寻找couchdb的执行脚本，默认应该是在`/opt/couchdb/bin`里 有couchdb
* 配置环境 `sudo gedit ~/.bashrc` 在最后一行加上:
```
export COUCHDB_HOME=/opt/couchdb
export PATH=$COUCHDB_HOME/bin:$PATH
```
* 加载配置 `source ~/.bashrc`
* 修改`/opt/couchdb/bin/couchdb` 脚本
```
#!/bin/sh

# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

canonical_readlink ()
{
  FILE=$(dirname "$1")/$(basename "$1")
  if [ -h "$FILE" ]; then
    cd $(dirname "$1")
    canonical_readlink $(readlink "$FILE")
  else
    cd "${1%/*}" && pwd -P
  fi
}

COUCHDB_BIN_DIR=$(canonical_readlink "$0")
ERTS_BIN_DIR=$COUCHDB_BIN_DIR/../
cd "$COUCHDB_BIN_DIR/../"

export ROOTDIR=${ERTS_BIN_DIR%/*}

START_ERL=`cat "$ROOTDIR/releases/start_erl.data"`
ERTS_VSN=${START_ERL% *}

export BINDIR="$ROOTDIR/erts-$ERTS_VSN/bin"
export EMU=beam
export PROGNAME=`echo $0 | sed 's/.*\///'`

export COUCHDB_QUERY_SERVER_JAVASCRIPT="${COUCHDB_QUERY_SERVER_JAVASCRIPT:-./bin/couchjs ./share/server/main.js}"
export COUCHDB_QUERY_SERVER_COFFEESCRIPT="${COUCHDB_QUERY_SERVER_COFFEESCRIPT:-./bin/couchjs ./share/server/main-coffee.js}"
DEFAULT_FAUXTON_ROOT=./share/www
export COUCHDB_FAUXTON_DOCROOT="${COUCHDB_FAUXTON_DOCROOT:-${DEFAULT_FAUXTON_ROOT}}"

# 读取命令行参数
while getopts "c:f:" opt; do
  case $opt in
    c)
      COUCHDB_INI_FILE="$OPTARG"
      ;;
    f)
      ARGS_FILE="$OPTARG"
      ;;
    *)
      echo "用法: $0 -c <ini文件> -f <vm.args文件>"
      exit 1
      ;;
  esac
done

# 确保参数存在
if [ -z "$COUCHDB_INI_FILE" ] || [ -z "$ARGS_FILE" ]; then
  echo "请提供 -c 和 -f 参数"
  exit 1
fi

INI_ARGS="-couch_ini $COUCHDB_INI_FILE"
SYSCONFIG_FILE="${COUCHDB_SYSCONFIG_FILE:-$ROOTDIR/releases/sys.config}"

exec "$BINDIR/erlexec" -boot "$ROOTDIR/releases/couchdb" \
     -args_file "$ARGS_FILE" \
     $INI_ARGS \
     -config "$SYSCONFIG_FILE" "$@"

```
## 配置couchdb
* 在fabric网络配置下，新建一个文件夹命名为`couchdb-config`
* 进入`couchdb-config` 再创建不同peer需要的couchdb配置文件夹，假设现在有三个组织，在第二个组织下有两个peer，那么就是创建`org1-peer0-data` `org1-peer0-local.ini` `org2-peer0-data` `org2-peer0-local.ini` `org2-peer1-data` `org2-peer1-local.ini` `org3-peer0-data` `org3-peer0-local.ini`
* 其中`org-peer0-data` 这种是文件夹，进入文件夹后每一个再创建一个`mem3-data`文件夹与`vm.args`文件
* `org1-peer0-local.ini`配置如下:
* 不同的peer对应不同的ini配置，需修改node下的name,couchdb下的路径，name，uuid删除或注释，mem3下的路径，chttpd_auth下的删除或注释，chttpd下的端口
```
; CouchDB Configuration Settings
[node]
name = couchdb-org1-peer0@127.0.0.1
[couchdb]
max_document_size = 4294967296 ; 最大文档大小（字节）
os_process_timeout = 5000        ; OS 进程超时设置（毫秒）
;uuid = 2b799f2bda8eb634e8edaa75cf5799a2 ;注释或删除掉，让他重新生成
name = org1_peer0_db             ; 数据库名称
database_dir = /home/jamnly/fabric-2.2/fabric-native-network/couchdb-config/org1-peer0-data
view_index_dir = /home/jamnly/fabric-2.2/fabric-native-network/couchdb-config/org1-peer0-data
[admins]
admin = 123456 ;在安装couchdb时填写的密码
[cluster]
n = 1
[log]
;writer = file ;选择日志为文件的形式
writer = stderr ;日志为启动时的命令行形式
file = /var/log/couchdb/couchdb0.log ;日志文件路径
[mem3]
db = /home/jamnly/fabric-2.2/fabric-native-network/couchdb-config/org1-peer0-data/mem3-data

; Optional SSL Configuration

[chttpd_auth]
;secret = 0069cbe6d88bc5f00ab478ec7db05647  ;注释或删除掉，让他重新生成

[chttpd]
;HTTP 服务器选项
bind_address = 0.0.0.0  ;定义群集端口可用的 IP 地址
port = 5984 ;端口
[couch_httpd_auth]
; WARNING! This only affects the node-local port (5986 by default).
; You probably want the settings under [chttpd].
authentication_db = _users
[indexers]
couch_mrview = true
[feature_flags]
; This enables any database to be created as a partitioned databases (except system db's).
; Setting this to false will stop the creation of partitioned databases.
; partitioned||allowed* = true will scope the creation of partitioned databases
; to databases with 'allowed' prefix.
partitioned||* = true
```

* 请先参考`/opt/couchdb/etc/vm.args`的内容，更换以下的setcookie
* 以下就添加了
```
-kernel inet_dist_listen_min 9100
-kernel inet_dist_listen_max 9200
```
* 和对`-name  couchdb0@127.0.0.1`的修改，需要保证不同的peer,-name都需要不同
* `vm.args`配置如下:
```
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

# Each node in the system must have a unique name. These are specified through
# the Erlang -name flag, which takes the form:
#
#    -name nodename@<FQDN>
#
# or
#
#    -name nodename@<IP-ADDRESS>
#
# CouchDB recommends the following values for this flag:
#
# 1. If this is a single node, not in a cluster, use:
#    -name couchdb@127.0.0.1
#
# 2. If DNS is configured for this host, use the FQDN, such as:
#    -name couchdb@my.host.domain.com
#
# 3. If DNS isn't configured for this host, use IP addresses only, such as:
#    -name couchdb@192.168.0.1
#
# Do not rely on tricks with /etc/hosts or libresolv to handle anything
# other than the above 3 approaches correctly. They will not work reliably.
#
# Multiple CouchDBs running on the same machine can use couchdb1@, couchdb2@,
# etc.
-name couchdb0@127.0.0.1

# All nodes must share the same magic cookie for distributed Erlang to work.
# Uncomment the following line and append a securely generated random value.
-setcookie 'jamnly'

# Which interfaces should the node listen on?
-kernel inet_dist_use_interface '{0,0,0,0}'
-kernel inet_dist_listen_min 9100
-kernel inet_dist_listen_max 9200

# Tell kernel and SASL not to log anything
-kernel error_logger silent
-sasl sasl_error_logger false

# This will toggle to true in Erlang 25+. However since we don't use global
# any longer, and have our own auto-connection module, we can keep the
# existing global behavior to avoid surprises. See
# https://github.com/erlang/otp/issues/6470#issuecomment-1337421210 for more
# information about possible increased coordination and messages being sent on
# disconnections when this setting is enabled.
#
-kernel prevent_overlapping_partitions false

# Increase the pool of dirty IO schedulers from 10 to 16
# Dirty IO schedulers are used for file IO.
+SDio 16

# Increase distribution buffer size from default of 1MB to 32MB. The default is
# usually a bit low on busy clusters. Has no effect for single-node setups.
# The unit is in kilobytes.
+zdbbl 32768

# When running on Docker, Kubernetes or an OS using CFS (Completely Fair
# Scheduler) with CPU quota limits set, disable busy waiting for schedulers to
# avoid busy waiting consuming too much of Erlang VM's CPU time-slice shares.
#+sbwt none
#+sbwtdcpu none
#+sbwtdio none

# Comment this line out to enable the interactive Erlang shell on startup
+Bd -noinput

# Set maximum SSL session lifetime to reap terminated replication readers
-ssl session_lifetime 300

## TLS Distribution
## Use TLS for connections between Erlang cluster members.
## http://erlang.org/doc/apps/ssl/ssl_distribution.html
##
## Generate Cert(PEM) File
## This is just an example command to generate a certfile (PEM).
## This is not an endorsement of specific expiration limits, key sizes, or algorithms.
##    $ openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem
##    $ cat key.pem cert.pem > dev/erlserver.pem && rm key.pem cert.pem
##
## Generate a Config File (couch_ssl_dist.conf)
##    [{server,
##      [{certfile, "</path/to/erlserver.pem>"},
##       {secure_renegotiate, true}]},
##     {client,
##      [{secure_renegotiate, true}]}].
##
## CouchDB recommends the following values for no_tls flag:
## 1. Use TCP only, set to true, such as:
##      -couch_dist no_tls true
## 2. Use TLS only, set to false, such as:
##      -couch_dist no_tls false
## 3. Specify which node to use TCP, such as:
##      -couch_dist no_tls \"*@127.0.0.1\"
##
## To ensure search works, make sure to set 'no_tls' option for the clouseau node.
## By default that would be "clouseau@127.0.0.1".
## Don't forget to override the paths to point to your certificate(s) and key(s)!
##
#-proto_dist couch
#-couch_dist no_tls '"clouseau@127.0.0.1"'
#-ssl_dist_optfile <path/to/couch_ssl_dist.conf>

# Enable FIPS mode
#   https://www.erlang.org/doc/apps/crypto/fips.html
#   Ensure that:
#    - Erlang is built with --enable-fips configuration option
#    - Crypto library (e.g. OpenSSL) supports this mode
#
# When the mode is successfully enabled "Welcome" message should show `fips`
# in the features list.
#
#-crypto fips_mode true

# OS Mon Settings

# only start disksup
-os_mon start_cpu_sup false
-os_mon start_memsup false

# Check disk space every 5 minutes
-os_mon disk_space_check_interval 5

# don't let disksup send alerts
-os_mon disk_almost_full_threshold 1.0
```
* 在`couchdb-config`外设置内部所有文件的权限为777
* `sudo chmod -R 777 ./couchdb-config`
* 因为couchdb执行的时候会使用couchdb的用户组，我们创建的文件都是所属我们的用户组，要将其他组的权限打开，能访问和修改到我们用户组所创建的文件。
### 可能会碰到的问题
* 若遇到权限不足的问题，可将权限不够的路径设置权限
  * 如
  * `sudo chmod -R 777 /var/lib/couchdb`
  * `sudo chown -R couchdb:couchdb /var/lib/couchdb`
* Protocol 'inet_tcp': the name couchdb@127.0.0.1 seems to be in use by another Erlang node
  * 查找couchdb进程`ps aux | grep couchdb`
  * 杀死最长的那个进程 `sudo kill -9 1234`
  * 确保你的vm.args里的-name是唯一的！！！
## 配置peer
* 打开peer的`core.yaml`
* 找到`stateDatabase:`，修改如下:
```
    stateDatabase: CouchDB
    totalQueryLimit: 100000
    couchDBConfig:
       couchDBAddress: 127.0.0.1:5984 #修改对应的端口
       username: admin
       password: 123456 #修改自己设置的密码
       maxRetries: 3
       maxRetriesOnStartup: 10
       requestTimeout: 35s
       internalQueryLimit: 1000
       maxBatchUpdateSize: 1000
       warmIndexesAfterNBlocks: 1
       createGlobalChangesDB: true
       cacheSize: 64
```
* 还可以将`org1-peer0.sh`修改成这样
```
echo "######org1 peer startup start######"
echo "current path: $(pwd)"
echo "remove data/peer"
rm -rf ./data/peer/org1-peer0


# 默认不使用 CouchDB
export CORE_LEDGER_STATE_STATEDATABASE=leveldb

# 解析参数
while getopts ":c" opt; do
  case ${opt} in
    c )
      echo "使用 CouchDB 数据库"
      export CORE_LEDGER_STATE_STATEDATABASE=CouchDB
      ;;
    \? )
      echo "无效的选项: $OPTARG" 1>&2
      ;;
  esac
done

export FABRIC_CFG_PATH=$(pwd)/config/peer/org1-peer0
#export FABRIC_LOGGING_SPEC=INFO
export FABRIC_LOGGING_SPEC=DEBUG
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_PROFILE_ENABLED=true

# Peer specific variables
export CORE_PEER_ID=peer0.org1.example.com
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LISTENADDRESS=0.0.0.0:7051
export CORE_PEER_CHAINCODEADDRESS=peer0.org1.example:7052
export CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7052
export CORE_PEER_GOSSIP_BOOTSTRAP=peer0.org1.example.com:7051
export CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer0.org1.example.com:7051
export CORE_OPERATIONS_LISTENADDRESS=peer0.org1.example.com:7543
export CORE_PEER_LOCALMSPID=Org1MSP


# Peer certificates and keys
export CORE_PEER_TLS_CERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
export CORE_PEER_TLS_ROOTCERT_FILE=$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp/tlscacerts/tlsca.org1.example.com-cert.pem
export CORE_PEER_TLS_CLIENTROOTCAS_FILES=$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$(pwd)/config/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp

# Ledger state database path
export CORE_PEER_FILESYSTEMPATH=$(pwd)/data/peer/org1-peer0

# Start the peer node
peer node start

```
* 这样 `sh org1-peer0.sh`是不启动db
* `sh org1-peer0.sh -c`是启动db
## 启动couchdb
* `couchdb -c /home/jamnly/fabric-2.2/fabric-native-network/couchdb-config/org1-peer0-local.ini -f /home/jamnly/fabric-2.2/fabric-native-network/couchdb-config/org1-peer0-data/vm.args `
* 修改对应的路径
* 进入`http://127.0.0.1:5984/_utils/#`
* 点击左边第二个的工具，选择Configure a Single Node
* 填写自己要使用的端口
* 再点击左边倒数第二个，验证安装
* 再启动peer节点
* 点击左边第一个会出现多几个数据库即可
