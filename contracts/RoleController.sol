// SPDX-License-Identifier: SimPL-2.0

pragma solidity ^0.8.0;



import "./DidController.sol";

contract RoleController {


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


	mapping (address => bool) private authorityIssuerRoleBearer;
	mapping (address => bool) private committeeMemberRoleBearer;
	mapping (address => bool) private adminRoleBearer;

	mapping (uint => RoleOperation) private roleOperationMap;


    
    DidController private didController;

	constructor (address didControllerAddress) {


        didController = DidController(didControllerAddress);

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
		authorityIssuerRoleBearer[msg.sender] = true;
		committeeMemberRoleBearer[msg.sender] = true;
		adminRoleBearer[msg.sender] = true;
    }


    function checkPermission(string memory did, uint operation) public view returns (bool) {


    	address didAddr = didController.getDidAddress(did);

    	if(didAddr == address(0x0)){
            return false;
        }

    	//逐个角色判断是否包含指定操作
    	if (authorityIssuerRoleBearer[didAddr]) {

			RoleOperation storage ro = roleOperationMap[ROLE_AUTHORITY_ISSUER];
			return ro.operationMap[operation];
    	}


    	if (committeeMemberRoleBearer[didAddr]) {

			RoleOperation storage ro = roleOperationMap[ROLE_COMMITTEE];
			return ro.operationMap[operation];
    	}


    	if (committeeMemberRoleBearer[didAddr]) {

			RoleOperation storage ro = roleOperationMap[ROLE_ADMIN];
			return ro.operationMap[operation];
    	}

    	return false;

    }



    function addRole(string memory did, uint role) public {

    	address didAddr = didController.getDidAddress(did);

    	if(didAddr == address(0x0)){
            return;
        }

        if (role == ROLE_ADMIN){
        	if (checkPermission(did, MODIFY_ADMIN)) {
        		adminRoleBearer[didAddr] = true;
        	}
        }

        if (role == ROLE_COMMITTEE) {
        	if (checkPermission(did, MODIFY_COMMITTEE)){
        		committeeMemberRoleBearer[didAddr] = true;
        	}
        }

        if (role == ROLE_AUTHORITY_ISSUER) {
        	if (checkPermission(did, MODIFY_AUTHORITY_ISSUER)){
        		authorityIssuerRoleBearer[didAddr] = true;
        	}
        }
    }

    function removeRole(string memory did, uint role) public {

    	address didAddr = didController.getDidAddress(did);

    	if(didAddr == address(0x0)){
            return;
        }

        if (role == ROLE_ADMIN){
        	if (checkPermission(did, MODIFY_ADMIN)) {
        		adminRoleBearer[didAddr] = false;
        	}
        }

        if (role == ROLE_COMMITTEE) {
        	if (checkPermission(did, MODIFY_COMMITTEE)){
        		committeeMemberRoleBearer[didAddr] = false;
        	}
        }

        if (role == ROLE_AUTHORITY_ISSUER) {
        	if (checkPermission(did, MODIFY_AUTHORITY_ISSUER)){
        		authorityIssuerRoleBearer[didAddr] = false;
        	}
        }

    }

    function checkRole(string memory did, uint role) public {


    }

}