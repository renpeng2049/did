pragma solidity ^0.5.0;

import "./RoleController.sol";
import "./DidController.sol";

contract Evds {

    struct VcStub {
        string did;
        int created;
        int updated;
        bool revoked;
    }

    
    DidController private didController;

    mapping (bytes32 => VcStub) private evdsMap;


    constructor(address didControllerAddress) public {
        didController = DidController(didControllerAddress);
    }

    function createEvds(string memory did, bytes32 vcHash, int256 created, int256 updated) public {

        //根据did获取地址,校验发送地址是否与did绑定地址相同
        require (tx.origin == didController.getDidAddress(did));

        evdsMap[vcHash] = VcStub({did: did, created: created,updated: updated, revoked: false});

    }

    function getEvds(bytes32 vcHash) public view returns (string memory,int256,int256, bool) {

        VcStub storage stub = evdsMap[vcHash];

        return (stub.did, stub.created, stub.updated, stub.revoked);

    }
    
    function revoke(string memory did, bytes32 vcHash) public {

        //根据did获取地址,校验发送地址是否与did绑定地址相同
        require (tx.origin == didController.getDidAddress(did));

        VcStub storage stub = evdsMap[vcHash];

        evdsMap[vcHash] = VcStub({did: stub.did, created: stub.created, updated: stub.updated, revoked: true});

    }


}