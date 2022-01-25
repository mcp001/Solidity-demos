pragma solidity ^0.4.19;

contract MedicalPayment { 

    address owner;

    struct patient {
        bool hasId;
        string name;
        uint amountInsured;
    }

    mapping (address => patient) public patientmapping;
    mapping (address => bool) public doctormapping;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    function setDoctor(address _address) public onlyOwner view {
        require(!doctormapping[_address]);
        doctormapping[_address];
    }

    function setPatient(string _name, uint _amountInsured) public onlyOwner returns (address) {
        address id = address(keccak256(abi.encodePacked(msg.sender, now)));
        require(!patientmapping[id].hasId);
        patientmapping[id].hasId = true;
        patientmapping[id].name = _name;
        patientmapping[id].amountInsured = _amountInsured;
        return id;
    }

    function makePayment(address _id, uint _amountUsed) public returns (string) {
        require(doctormapping[msg.sender]);
        require(patientmapping[_id].amountInsured <= _amountUsed);
        patientmapping[_id].amountInsured -= _amountUsed;
        return "Transaction successful";
    }

}