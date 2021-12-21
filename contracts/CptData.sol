// SPDX-License-Identifier: SimPL-2.0

pragma solidity ^0.8.0;


import "./DidController.sol";

contract CptData {

    struct Signature {
        uint8 v; 
        bytes32 r; 
        bytes32 s;
    }

    struct CptInfo {
        string title;
        string jsonSchema;
        uint version;
        uint8 cptType;
        bool deprecated;

        //store signature
        Signature signature;


        uint256 created;

        uint256 updated;
    }

    struct Cpt {

        uint id;
        //store the weid address of cpt publisher
        string did;

        uint version;

        bool deprecated;

        mapping (uint => CptInfo) verMap;
    }

    mapping (uint => Cpt) private cptMap;

    
    DidController private didController;

    uint private idIndex;


    constructor(address didControllerAddress) {
        didController = DidController(didControllerAddress);
    }


    function createCpt(address identity, string memory did, string memory title, string memory jsonSchema, uint8 cptType,
        uint8 v, bytes32 r, bytes32 s) public returns (uint8) {
        
        //根据did获取地址,校验发送地址是否与did绑定地址相同
        require (identity == didController.getDidAddress(did));


        //TODO 只有可信企业才能创建cpt

        Signature memory signature = Signature({v: v, r: r, s: s});

        uint cptId = idIndex++;

        Cpt storage cpt = cptMap[cptId];
        cpt.id = cptId;
        cpt.did = did;
        cpt.deprecated = false;

        uint newVersion = cpt.version + 1;
        cpt.version = newVersion;

        CptInfo storage cptInfo = cpt.verMap[newVersion];
        cptInfo.title = title;
        cptInfo.jsonSchema = jsonSchema;
        cptInfo.cptType = cptType;
        cptInfo.deprecated = false;
        cptInfo.created = block.timestamp;
        cptInfo.updated = block.timestamp;
        cptInfo.version = newVersion;
        cptInfo.signature = signature;

        return 0;
    }

    
    function getCptInfo(uint id) public view returns (uint, string memory, uint, bool) {

        Cpt storage cpt = cptMap[id];

        return (cpt.id, cpt.did, cpt.version, cpt.deprecated);
    }
    
    function getCptInfo(uint id, uint version) public view returns (string memory, string memory, 
        string memory, uint8, bool, uint, uint256, uint256, uint8, bytes32, bytes32) {

        Cpt storage cpt = cptMap[id];

        require (cpt.deprecated == false);

        if(version == 0) version = cpt.version;
        CptInfo storage cptInfo = cpt.verMap[version];

        return (cpt.did, cptInfo.title,cptInfo.jsonSchema, cptInfo.cptType, cptInfo.deprecated, cptInfo.version, cptInfo.created,cptInfo.updated, 
            cptInfo.signature.v, cptInfo.signature.r, cptInfo.signature.s);
    }


    function deprecateCpt(uint id, uint version) public returns (uint8) {

        Cpt storage cpt = cptMap[id];
        CptInfo storage cptInfo = cpt.verMap[version];
        cptInfo.deprecated = true;

        return 0;
    }


    function updateCpt(uint id, address identity, string memory did, string memory title, string memory jsonSchema, uint8 cptType,
        uint8 v, bytes32 r, bytes32 s) public returns (uint8) {
        
        //根据did获取地址,校验发送地址是否与did绑定地址相同
        require (identity == didController.getDidAddress(did));

        Cpt storage cpt = cptMap[id];
        string memory cptDid = cpt.did;

        //TODO 只有创建者才能更新cpt
        require (keccak256(bytes(did)) == keccak256(bytes(cptDid)));

        Signature memory signature = Signature({v: v, r: r, s: s});

        uint newVersion = cpt.version++;

        cpt.version = newVersion;

        CptInfo storage cptInfo = cpt.verMap[newVersion];
        cptInfo.title = title;
        cptInfo.jsonSchema = jsonSchema;
        cptInfo.cptType = cptType;
        cptInfo.deprecated = false;
        cptInfo.created = block.timestamp;
        cptInfo.updated = block.timestamp;
        cptInfo.version = newVersion;
        cptInfo.signature = signature;

        return 0;

    }

}