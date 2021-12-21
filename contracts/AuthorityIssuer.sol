// SPDX-License-Identifier: SimPL-2.0

pragma solidity ^0.8.0;



import "./DidController.sol";

contract AuthorityIssuerData {


    struct AuthorityIssuer {
    	string did;
        string name;
        string descirption;
        bool active;
        uint256 created;
        uint256 updated;
    }

    mapping (bytes32 => AuthorityIssuer) private aiMap;

    
    DidController private didController;


    constructor (address didControllerAddress) {
        didController = DidController(didControllerAddress);
    }



    function addAuthorityIssuer(string memory did, string memory name, string memory descirption) public returns (uint8) {



    }

}