// SPDX-License-Identifier: SimPL-2.0

pragma solidity ^0.8.0;



import "./DidController.sol";

contract RoleController {


	uint constant public ERR_CODE_NO_PERMISSION = 50000;

	//角色
	uint constant public ROLE_ADMIN = 1;
	uint constant public ROLE_COMMITTEE = 2;
	uint constant public ROLE_AUTHORITY_ISSUER = 3;

	//操作
	uint constant public MODIFY_ADMIN= 100;
	uint constant public MODIFY_COMMITTEE = 101;
	uint constant public MODIFY_AUTHORITY_ISSUER = 102;
	uint constant public MODIFY_CPT = 103;

	struct RoleOperation {
		mapping (uint => bool) operationMap;
	}


	mapping (string => bool) private authorityIssuerRoleBearer;
	mapping (string => bool) private committeeMemberRoleBearer;
	mapping (string => bool) private adminRoleBearer;

	mapping (uint => RoleOperation) private roleOperationMap;


    
    DidController private didController;

	constructor (string memory did, address didControllerAddress) {


        didController = DidController(didControllerAddress);

        require (didController.getDidAddress(did) == tx.origin);

		//初始化角色-操作
		RoleOperation storage roAdmin = roleOperationMap[ROLE_ADMIN];
		roAdmin.operationMap[MODIFY_ADMIN] = true;
		roAdmin.operationMap[MODIFY_COMMITTEE] = true;
		roAdmin.operationMap[MODIFY_AUTHORITY_ISSUER] = true;
		roAdmin.operationMap[MODIFY_CPT] = true;


		RoleOperation storage roCommittee = roleOperationMap[ROLE_COMMITTEE];
		roCommittee.operationMap[MODIFY_AUTHORITY_ISSUER] = true;
		roCommittee.operationMap[MODIFY_CPT] = true;


		RoleOperation storage roAi = roleOperationMap[ROLE_AUTHORITY_ISSUER];
		roAi.operationMap[MODIFY_CPT] = true;


		//初始化角色
		authorityIssuerRoleBearer[did] = true;
		committeeMemberRoleBearer[did] = true;
		adminRoleBearer[did] = true;
    }


    function checkPermission(string memory did, uint operation) public view returns (bool) {

    	//逐个角色判断是否包含指定操作
    	if (authorityIssuerRoleBearer[did]) {

			RoleOperation storage ro = roleOperationMap[ROLE_AUTHORITY_ISSUER];
			return ro.operationMap[operation];
    	}


    	if (committeeMemberRoleBearer[did]) {

			RoleOperation storage ro = roleOperationMap[ROLE_COMMITTEE];
			return ro.operationMap[operation];
    	}


    	if (committeeMemberRoleBearer[did]) {

			RoleOperation storage ro = roleOperationMap[ROLE_ADMIN];
			return ro.operationMap[operation];
    	}

    	return false;

    }



    function addRole(string memory operator, string memory did, uint role) public {

    	address operatorAddr = didController.getDidAddress(operator);
    	require (operatorAddr == tx.origin);

    	
        if (role == ROLE_ADMIN){
        	if (checkPermission(operator, MODIFY_ADMIN)) {
        		adminRoleBearer[did] = true;
        	}
        }

        if (role == ROLE_COMMITTEE) {
        	if (checkPermission(operator, MODIFY_COMMITTEE)){
        		committeeMemberRoleBearer[did] = true;
        	}
        }

        if (role == ROLE_AUTHORITY_ISSUER) {
        	if (checkPermission(operator, MODIFY_AUTHORITY_ISSUER)){
        		authorityIssuerRoleBearer[did] = true;
        	}
        }
    }

    function removeRole(string memory operator, string memory did, uint role) public {


    	address operatorAddr = didController.getDidAddress(operator);
    	require (operatorAddr == tx.origin);


        if (role == ROLE_ADMIN){
        	if (checkPermission(operator, MODIFY_ADMIN)) {
        		adminRoleBearer[did] = false;
        	}
        }

        if (role == ROLE_COMMITTEE) {
        	if (checkPermission(operator, MODIFY_COMMITTEE)){
        		committeeMemberRoleBearer[did] = false;
        	}
        }

        if (role == ROLE_AUTHORITY_ISSUER) {
        	if (checkPermission(operator, MODIFY_AUTHORITY_ISSUER)){
        		authorityIssuerRoleBearer[did] = false;
        	}
        }

    }

    function checkRole(string memory did, uint role) public {


    }


    function getNoPermissionErrCode() public pure returns (uint) {
        return ERR_CODE_NO_PERMISSION;
    }  

    function getAuthorityIssuerRoleId() public pure returns (uint) {
        return ROLE_AUTHORITY_ISSUER;
    }

    function getModifyAuthorityIssuerOperationId() public pure returns (uint) {
        return MODIFY_AUTHORITY_ISSUER;
    }

}