package main

import (
	"fmt"
	"strconv"
        "math/rand"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)


type SimpleChaincode struct {
}

func (t *SimpleChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {
	fmt.Println("ex02 Init")
	_, args := stub.GetFunctionAndParameters()
	var A, B string    // Entities
	var Aval, Bval int // Asset holdings
	var err error

	if len(args) != 4 {
		return shim.Error("Incorrect argument numbers. Expecting 4")
	}

	// Initialize the chaincode
	A = args[0]
	Aval, err = strconv.Atoi(args[1])
	if err != nil {
		return shim.Error("Expecting integer value for asset holding")
	}
	B = args[2]
	Bval, err = strconv.Atoi(args[3])
	if err != nil {
		return shim.Error("Expecting integer value for asset holding")
	}
	fmt.Printf("Aval = %d, Bval = %d\n", Aval, Bval)

	// Write the state to the ledger
	err = stub.PutState(A, []byte(strconv.Itoa(Aval)))
	if err != nil {
		return shim.Error(err.Error())
	}

	err = stub.PutState(B, []byte(strconv.Itoa(Bval)))
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func (t *SimpleChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fmt.Println("Invoke weather cc:")
	function, args := stub.GetFunctionAndParameters()
	if function == "measure" {
		return t.invoke(stub, args)
	} else if function == "query" {
		return t.query(stub, args)
	} else if function == "forecast" {
		return t.forecast(stub, args)
	}

	return shim.Error("Invalid invoke function name. Expecting \"measure\" \"forecast\" \"query\"")
}

func (t *SimpleChaincode) invoke(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var A string    // Entities
	var Aval int // Asset holdings
	var err error

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2, got " + string(len(args)))
	}

	//Measure some temperature
	A = args[0]
        Aval, _ = strconv.Atoi(args[1])
        Aval = Aval + rand.Intn(10)

	// Write the state back to the ledger
	err = stub.PutState(A, []byte(strconv.Itoa(Aval)))
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

// query callback representing the query of a chaincode
func (t *SimpleChaincode) query(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var A string // Entities
	var err error

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting name of the person to query")
	}

	A = args[0]

	// Get the state from the ledger
	Avalbytes, err := stub.GetState(A)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + A + "\"}"
		return shim.Error(jsonResp)
	}

	if Avalbytes == nil {
		jsonResp := "{\"Error\":\"Nil amount for " + A + "\"}"
		return shim.Error(jsonResp)
	}

	jsonResp := "{\"Name\":\"" + A + "\",\"Amount\":\"" + string(Avalbytes) + "\"}"
	fmt.Printf("Query Response:%s\n", jsonResp)
	return shim.Success(Avalbytes)
}

func (t *SimpleChaincode) forecast(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var A, B string // Entities
	var Aval, Bval int
	var T int
	var err error

	A = args[0]
	B = args[1]

	// Get the state from the ledger
	Avalbytes, err := stub.GetState(A)
        
        if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + A + "\"}"
		return shim.Error(jsonResp)
	}
        
        Bvalbytes, err := stub.GetState(B)
        
        if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + A + "\"}"
		return shim.Error(jsonResp)
	}

	if Avalbytes == nil  {
		jsonResp := "{\"Error\":\"No data of  " + A + "\"}"
		return shim.Error(jsonResp)
	}
	if Bvalbytes == nil  {
		jsonResp := "{\"Error\":\"No data of  " + B + "\"}"
		return shim.Error(jsonResp)
	}
	
	Aval, _ = strconv.Atoi(string(Avalbytes))
        Bval, _ = strconv.Atoi(string(Bvalbytes))
        T = (Aval + Bval)/2

	jsonResp := "{\"Avarage temperature \":\"" + string(T) + "\"}"
	fmt.Printf("Query Response:%s\n", jsonResp)
	return shim.Success( []byte(strconv.Itoa(T)) )
}

func main() {
	err := shim.Start(new(SimpleChaincode))
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
	}
}
