pragma solidity ^0.5.0;


import "./DidController.sol";

contract CptData {

    struct Signature {
        uint8 v; 
        bytes32 r; 
        bytes32 s;
    }

    struct Cpt {

        uint id;
        //store the weid address of cpt publisher
        string did;

        string title;
        
        //store json schema
        string jsonSchema;

        //0 private 1 public
        uint8 cptType;

        uint version;
        //store signature
        Signature signature;

        int256 created;

        int256 updated;
    }

    mapping (uint => Cpt) private cptMap;
    mapping (bytes32 => Cpt) private cptVersionMap;

    
    DidController private didController;

    uint private idIndex;


    constructor(address didControllerAddress) public {
        didController = DidController(didControllerAddress);
    }


    function createCpt(address identity, string memory did, string memory title, string memory jsonSchema, uint8 cptType,
        uint8 version,int256 created,int256 updated, uint8 v, bytes32 r, bytes32 s) public returns (uint) {
        
        //根据did获取地址,校验发送地址是否与did绑定地址相同
        require (identity == didController.getDidAddress(did));


        //TODO 只有可信企业才能创建cpt

        Signature memory signature = Signature({v: v, r: r, s: s});

        idIndex++;

        cptMap[idIndex] = Cpt({id: idIndex, did: did, title: title, jsonSchema: jsonSchema, cptType: cptType, version: version, created: created,
            updated: updated, signature: signature});

    }

    
    function getCpt(uint id) public view returns (string memory, string memory, string memory, uint8, uint, int256, int256, uint8, bytes32, bytes32) {

        Cpt storage cpt = cptMap[id];

        return (cpt.did, cpt.title,cpt.jsonSchema, cpt.cptType, cpt.version, cpt.created,cpt.updated, cpt.signature.v, cpt.signature.r, cpt.signature.s);
    }


    function updateCpt(uint id, address identity, string memory did, string memory title, string memory jsonSchema, uint8 cptType,
        uint8 version, int256 updated, uint8 v, bytes32 r, bytes32 s) public returns (uint) {
        
        //根据did获取地址,校验发送地址是否与did绑定地址相同
        require (identity == didController.getDidAddress(did));

        Cpt storage cpt = cptMap[id];

        //TODO 只有创建者才能更新cpt
        require (did == cpt.did);

        Signature memory signature = Signature({v: v, r: r, s: s});

        cptMap[idIndex] = Cpt({id: idIndex, did: did, title: title, jsonSchema: jsonSchema, cptType: cptType, version: version, 
            updated: now, signature: signature});

    }

    function strConcat(string _a, string _b) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory ret = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory bret = bytes(ret);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++)bret[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) bret[k++] = _bb[i];
        return string(ret);
   } 

}