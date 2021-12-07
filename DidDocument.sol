<<<<<<< HEAD
pragma solidity ^0.5.0;

contract DidDocumentData {

    uint constant private PROPERTY_TYPE_VM = 1;
    uint constant private PROPERTY_TYPE_AUTH = 2;
    uint constant private PROPERTY_TYPE_SERVICE = 3;


    modifier onlyOwner(address identity, address actor) {
        require (actor == identity);
        _;
    }

    struct VerificationMethod {
        string id;
        string ptype;
        string controller;
        string property;
    }

    struct Authentication {
        string id;
        string ptype;
        string controller;
        string property;
    }

    struct Service {
        string id;
        string ptype;
        string serviceEndpoint;
    }

    struct DidDocument {
        string id;
        int created;
        int updated;

        bytes32[16] vmKeys;
        mapping(bytes32 => VerificationMethod) vms;

        bytes32[16] authKeys;
        mapping(bytes32 => Authentication) auths;

        bytes32[16] serviceKeys;
        mapping(bytes32 => Service) services;
    }

    mapping(bytes32 => DidDocument) dids;
    mapping(bytes32 => address) didAddrs;

    function createDid(address identity,string memory did,string memory publicKey,string memory pkid,string memory pktype,int256 created,int256 updated) public onlyOwner(identity,tx.origin) {

        bytes32 didhash = keccak256(bytes(did));

        if(didAddrs[didhash] != address(0x0)){
            return;
        }

        bytes32 pkhash = keccak256(bytes(pkid));

        bytes32[16] memory vmKeys;
        vmKeys[0] = pkhash;

        bytes32[16] memory authKeys;
        authKeys[0] = pkhash;

        bytes32[16] memory serviceKeys;

        dids[didhash] = DidDocument({id:did,created:created,updated:updated,vmKeys:vmKeys,authKeys:authKeys,serviceKeys:serviceKeys});

        DidDocument storage dd = dids[didhash];

        dd.vms[pkhash] = VerificationMethod({id: pkid,ptype: pktype,controller:did,property:publicKey});
        dd.auths[pkhash] = Authentication({id: pkid,ptype: pktype,controller:did,property:publicKey});

        didAddrs[didhash] = identity;
    }

    function getDid(string memory did) public view returns (string memory,int256,int256) {

        bytes32 didhash = keccak256(bytes(did));

        DidDocument storage dd = dids[didhash];

        return (dd.id,dd.created,dd.updated);
    }

    function getDidAddress(string memory did) public view returns (address) {

        bytes32 didhash = keccak256(bytes(did));

        return didAddrs[didhash];
    }

    function getKeys(string memory did, uint propertyType) public view returns (bytes32[16] memory) {

        bytes32 didhash = keccak256(bytes(did));
        DidDocument storage dd = dids[didhash];

        if(PROPERTY_TYPE_VM == propertyType){

            return dd.vmKeys;
        }else if(PROPERTY_TYPE_AUTH == propertyType){

            return dd.authKeys;
        }else if(PROPERTY_TYPE_SERVICE == propertyType){

            return dd.serviceKeys;
        }else {
            return dd.vmKeys;
        }
    }

    function getProperty(string memory did, uint propertyType,bytes32 key) public view returns (string memory,string memory,string memory,string memory) {

        bytes32 didhash = keccak256(bytes(did));

        DidDocument storage dd = dids[didhash];

        if(PROPERTY_TYPE_VM == propertyType){

            return (dd.vms[key].id, dd.vms[key].ptype, dd.vms[key].controller,  dd.vms[key].property);
        }else if(PROPERTY_TYPE_AUTH == propertyType){

            return (dd.auths[key].id, dd.auths[key].ptype, dd.auths[key].controller,  dd.auths[key].property);
        }else if(PROPERTY_TYPE_SERVICE == propertyType){

            return (dd.services[key].id, dd.services[key].ptype, "",  dd.services[key].serviceEndpoint);
        }else {
            return ("","","","");
        }
    }

=======
pragma solidity ^0.5.0;

contract DidDocumentData {

    uint constant private PROPERTY_TYPE_VM = 1;
    uint constant private PROPERTY_TYPE_AUTH = 2;
    uint constant private PROPERTY_TYPE_SERVICE = 3;


    modifier onlyOwner(address identity, address actor) {
        require (actor == identity);
        _;
    }

    struct VerificationMethod {
        string id;
        string ptype;
        string controller;
        string property;
    }

    struct Authentication {
        string id;
        string ptype;
        string controller;
        string property;
    }

    struct Service {
        string id;
        string ptype;
        string serviceEndpoint;
    }

    struct DidDocument {
        string id;
        int created;
        int updated;

        bytes32[16] vmKeys;
        mapping(bytes32 => VerificationMethod) vms;

        bytes32[16] authKeys;
        mapping(bytes32 => Authentication) auths;

        bytes32[16] serviceKeys;
        mapping(bytes32 => Service) services;
    }

    mapping(bytes32 => DidDocument) dids;
    mapping(bytes32 => address) didAddrs;

    function createDid(address identity,string memory did,string memory publicKey,string memory pkid,string memory pktype,int256 created,int256 updated) public onlyOwner(identity,tx.origin) {

        bytes32 didhash = keccak256(bytes(did));

        if(didAddrs[didhash] != address(0x0)){
            return;
        }

        bytes32 pkhash = keccak256(bytes(pkid));

        bytes32[16] memory vmKeys;
        vmKeys[0] = pkhash;

        bytes32[16] memory authKeys;
        authKeys[0] = pkhash;

        bytes32[16] memory serviceKeys;

        dids[didhash] = DidDocument({id:did,created:created,updated:updated,vmKeys:vmKeys,authKeys:authKeys,serviceKeys:serviceKeys});

        DidDocument storage dd = dids[didhash];

        dd.vms[pkhash] = VerificationMethod({id: pkid,ptype: pktype,controller:did,property:publicKey});
        dd.auths[pkhash] = Authentication({id: pkid,ptype: pktype,controller:did,property:publicKey});

        didAddrs[didhash] = identity;
    }

    function getDid(string memory did) public view returns (string memory,int256,int256) {

        bytes32 didhash = keccak256(bytes(did));

        DidDocument storage dd = dids[didhash];

        return (dd.id,dd.created,dd.updated);
    }

    function getDidAddress(string memory did) public view returns (address) {

        bytes32 didhash = keccak256(bytes(did));

        return didAddrs[didhash];
    }

    function getKeys(string memory did, uint propertyType) public view returns (bytes32[16] memory) {

        bytes32 didhash = keccak256(bytes(did));
        DidDocument storage dd = dids[didhash];

        if(PROPERTY_TYPE_VM == propertyType){

            return dd.vmKeys;
        }else if(PROPERTY_TYPE_AUTH == propertyType){

            return dd.authKeys;
        }else if(PROPERTY_TYPE_SERVICE == propertyType){

            return dd.serviceKeys;
        }else {
            return dd.vmKeys;
        }
    }

    function getProperty(string memory did, uint propertyType,bytes32 key) public view returns (string memory,string memory,string memory,string memory) {

        bytes32 didhash = keccak256(bytes(did));

        DidDocument storage dd = dids[didhash];

        if(PROPERTY_TYPE_VM == propertyType){

            return (dd.vms[key].id, dd.vms[key].ptype, dd.vms[key].controller,  dd.vms[key].property);
        }else if(PROPERTY_TYPE_AUTH == propertyType){

            return (dd.auths[key].id, dd.auths[key].ptype, dd.auths[key].controller,  dd.auths[key].property);
        }else if(PROPERTY_TYPE_SERVICE == propertyType){

            return (dd.services[key].id, dd.services[key].ptype, "",  dd.services[key].serviceEndpoint);
        }else {
            return ("","","","");
        }
    }

>>>>>>> b5143897a4f0aa56e81e1304af15fe9eacd76a07
}