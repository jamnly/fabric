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
	fmt.Printf("Function: %s, Args: %v\n", function, args) // 修改此行
	fmt.Printf("111111111111111111\n")                     // 确保输出在新行
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
	ccid := "sample:c7ea2b0af46393fdba0467b5755980955a4a1080f203472280da4e608d920dbf"

	server := &shim.ChaincodeServer{
		CCID:    ccid,
		Address: "0.0.0.0:6668",
		CC:      new(SimpleChaincode),
		TLSProps: shim.TLSProperties{
			Disabled: true,
		},
	}

	err := server.Start()
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
		return
	}
}
