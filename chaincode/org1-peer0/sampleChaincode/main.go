package main

import (
	"errors"
	"fmt"

	"github.com/hyperledger/fabric-chaincode-go/shim"
	pb "github.com/hyperledger/fabric-protos-go/peer"
)

// SimpleChaincode example simple Chaincode implementation
type SimpleChaincode struct {
}

// Init 方法
func (sc *SimpleChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {
	// 可以在这里进行初始化逻辑，例如设置初始状态
	return shim.Success(nil)
}

// 获取状态的辅助函数
func (sc *SimpleChaincode) getState(stub shim.ChaincodeStubInterface, key string) ([]byte, error) {
	bytes, err := stub.GetState(key)
	if err != nil {
		return nil, errors.New("查询失败！")
	}
	return bytes, nil
}

// 上链
func (sc *SimpleChaincode) Create(stub shim.ChaincodeStubInterface, key string, value string) error {
	existing, err := sc.getState(stub, key)
	if err != nil {
		return err
	}
	if existing != nil {
		return fmt.Errorf("添加数据错误！%s已经存在。", key)
	}
	return stub.PutState(key, []byte(value))
}

// 更新
func (sc *SimpleChaincode) Update(stub shim.ChaincodeStubInterface, key string, value string) error {
	bytes, err := sc.getState(stub, key)
	if err != nil {
		return err
	}
	if bytes == nil {
		return fmt.Errorf("没有查询到%s对应的数据", key)
	}
	return stub.PutState(key, []byte(value))
}

// 查询
func (sc *SimpleChaincode) Read(stub shim.ChaincodeStubInterface, key string) (string, error) {
	bytes, err := sc.getState(stub, key)
	if err != nil {
		return "", err
	}
	if bytes == nil {
		return "", fmt.Errorf("数据不存在，读到的%s对应的数据为空！", key)
	}
	return string(bytes), nil
}

// 清除所有数据
func (sc *SimpleChaincode) ClearAll(stub shim.ChaincodeStubInterface) error {
	keysIter, err := stub.GetStateByRange("", "")
	if err != nil {
		return errors.New("无法获取现有状态")
	}
	defer keysIter.Close()

	for keysIter.HasNext() {
		response, err := keysIter.Next()
		if err != nil {
			return errors.New("状态迭代错误")
		}
		if err := stub.DelState(response.Key); err != nil {
			return errors.New("删除状态时发生错误")
		}
	}
	fmt.Println("所有数据已被清除")
	return nil
}

// Invoke 方法
func (sc *SimpleChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	function, args := stub.GetFunctionAndParameters()
	switch function {
	case "create":
		if len(args) != 2 {
			return shim.Error("参数个数不正确！")
		}
		if err := sc.Create(stub, args[0], args[1]); err != nil {
			return shim.Error(err.Error())
		}
		return shim.Success(nil)

	case "update":
		if len(args) != 2 {
			return shim.Error("参数个数不正确！")
		}
		if err := sc.Update(stub, args[0], args[1]); err != nil {
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

	case "clearAll":
		if err := sc.ClearAll(stub); err != nil {
			return shim.Error(err.Error())
		}
		return shim.Success(nil)

	default:
		return shim.Error("无效的函数调用！")
	}
}

// main function
func main() {
	fmt.Println("main start...")
	ccid := "sample:06b8b32c5fb8be0482c3ccb7b07d24aa8cb5b40d875eae4dd2c6793a5a2c908e"

	server := &shim.ChaincodeServer{
		CCID:    ccid,
		Address: "0.0.0.0:6666",
		CC:      new(SimpleChaincode),
		TLSProps: shim.TLSProperties{
			Disabled: true,
		},
	}

	if err := server.Start(); err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
		return
	}
}
