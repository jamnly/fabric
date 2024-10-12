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
* 解压到自己想要的位置 `tar -xzvf hyperledger-fabric-ca-linux-amd64-1.5.9.tar.gz -C /home/test/fabric/`
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
### 静态加入
* 在当前目录下 新建 `org4-peer0.sh` [org4-peer0.sh详细内容](#0)
* 在config/peer/下 新建`org4-peer0`文件夹 进入再新建（最好是复制org3-peer0）的core.yaml文件 `core.yaml` [core.yaml详细内容](#1)
* 在chaincode/下 新建`org4-peer0`文件夹 进入在新建（自定义的合约名称，可参考org3-peer0里的内容） `sampleChaincode`文件夹 进入新建`main.go`（链码） 再新建`external`文件夹（用于打包合约）进入创建`connection.json`和`metadata.json` [connection.json 详细内容](#2) [metadata.json 详细内容](#3)
 #### 需要修改的地方

<span id="0"></span>

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
<span id="2"></span>

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
### 动态加入org
* 假设动态加入`org4peer0`
* 即不执行`sh generate-config-file.sh`重新创建 
* 在当前目录下 新建 `org4-peer0.sh` [org4-peer0.sh详细内容](#0)
* 在config/peer/下 新建`org4-peer0`文件夹 进入再新建（最好是复制org3-peer0）的core.yaml文件 `core.yaml` [core.yaml详细内容](#1)
* 在chaincode/下 新建`org4-peer0`文件夹 进入再新建（自定义的合约名称，可参考org3-peer0里的内容） `sampleChaincode`文件夹 进入新建`main.go`（链码） 再新建`external`文件夹（用于打包合约）进入创建`connection.json`和`metadata.json` [connection.json 详细内容](#2) [metadata.json 详细内容](#3)
* 在config/下 新建 `org4-configtx`文件夹 进入再新建 `configtx.yaml`作为org4的configtx [configtx.yaml 详细内容](#configtx)
* 在config/cryptogen/下 新建`crypto-config-org4.yaml`文件 [crypto-config-org4.yaml 详细内容](#crypto-config-org)
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
### 静态加入
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




