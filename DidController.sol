pragma solidity ^0.5.0;

import "./DidDocument.sol";

contract DidController {

    event didCreated(address indexed);

    DidDocumentData private didDocument;

    constructor(address didDocumentAddress) public {
        didDocument = DidDocumentData(didDocumentAddress);
    }

    function createDid(address identity,string memory did,string memory publicKey,string memory pkid,string memory pktype,int256 created,int256 updated) public {

        didDocument.createDid(identity,did,publicKey,pkid,pktype,created,updated);
        emit didCreated(identity);

    }

    function getDid(string memory did) public view returns (string memory,int256,int256) {
        return didDocument.getDid(did);
    }

    function getDidAddress(string memory did) public view returns (address) {
        return didDocument.getDidAddress(did);
    }

    function getKeys(string memory did, uint propertyType) public view returns (bytes32[16] memory) {
        return didDocument.getKeys(did,propertyType);
    }

    function getProperty(string memory did, uint propertyType,bytes32 key) public view returns (string memory,string memory,string memory,string memory) {
        return didDocument.getProperty(did,propertyType,key);
    }

    function getDidDataAddress() public view returns (address) {

        return address(didDocument);
    }

}