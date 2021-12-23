// SPDX-License-Identifier: SimPL-2.0

pragma solidity ^0.8.0;



import "./DidController.sol";
import "./RoleController.sol";

contract AuthorityIssuerData {

    //返回码
    uint constant public ERR_CODE_SUCCESS = 0;
    uint constant public ERR_CODE_AUTHORITY_ISSUER_EXIST = 500001;
    uint constant public ERR_CODE_NAME_ALREADY_EXIST = 500002;


    struct AuthorityIssuer {
    	string did;
        string name;
        string descirption;
        bool active;
        uint256 created;
        uint256 updated;
    }

    mapping (string => AuthorityIssuer) private aiMap;
    string[] private aiArray;
    mapping (bytes32 => bool) private uniqueNameMap;


    
    DidController private didController;
    RoleController private roleController;


    constructor (address didControllerAddress, address roleControllerAddress) {
        didController = DidController(didControllerAddress);
        roleController = RoleController(roleControllerAddress);
    }



    function addAuthorityIssuer(string memory operator, string memory did, string memory name, string memory descirption) public returns (uint) {


        require (didController.getDidAddress(operator) == tx.origin);

        if (!roleController.checkPermission(operator, roleController.getModifyAuthorityIssuerOperationId())) {
            return roleController.getNoPermissionErrCode();
        }

        if (isAuthorityIssuer(did)){
            return ERR_CODE_AUTHORITY_ISSUER_EXIST;
        }

        if (isNameDuplicate(name)){
            return ERR_CODE_NAME_ALREADY_EXIST;
        }

        roleController.addRole(operator, did, roleController.getAuthorityIssuerRoleId());

        AuthorityIssuer storage ai = aiMap[did];
        ai.did = did;
        ai.name = name;
        ai.descirption = descirption;
        ai.active = true;
        ai.created = block.timestamp;
        ai.updated = block.timestamp;

        aiArray.push(did);

        uniqueNameMap[keccak256(bytes(name))] = true;

        return ERR_CODE_SUCCESS;

    }

    function deleteAuthorityIssuer(string memory operator, string memory did) public returns (uint) {

        require (didController.getDidAddress(operator) == tx.origin);

        if (!roleController.checkPermission(operator, roleController.getModifyAuthorityIssuerOperationId())) {
            return roleController.getNoPermissionErrCode();
        }


        if (isAuthorityIssuer(did)){

            AuthorityIssuer storage ai = aiMap[did];
            ai.active = false;

            uniqueNameMap[keccak256(bytes(ai.name))] = false;

            bool inArr = false;
            for(uint i = 0; i < aiArray.length; i++) {
                if (keccak256(bytes(aiArray[i])) == keccak256(bytes(did))) {
                    inArr = true;
                }

                if(inArr && i != aiArray.length -1){
                    aiArray[i] = aiArray[i+1];
                }
            }

            delete aiArray[aiArray.length - 1];


            roleController.removeRole(operator, did, roleController.getAuthorityIssuerRoleId());
        }

        return ERR_CODE_SUCCESS;

        
    }

    function isAuthorityIssuer(string memory did) public view returns (bool) {
        return aiMap[did].active == true;
    }


    function isNameDuplicate(string memory name) public view returns (bool) {
        return uniqueNameMap[keccak256(bytes(name))];
    }




}