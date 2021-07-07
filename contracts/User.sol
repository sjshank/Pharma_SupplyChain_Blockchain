// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
import "./Owner.sol";

contract User is Owner {
    enum roles {
        norole,
        supplier,
        transporter,
        manufacturer,
        wholesaler,
        distributor,
        pharma,
        revoke,
        admin
    }

    modifier onlyAdmin {
        require(UsersDetails[msg.sender].userRole == roles.admin, "OACC"); //"Only Admin can call this function."
        _;
    }

    //Register event for user registration
    event UserRegistered(address indexed UserAddress, string Name);
    //Register event for user role revokation
    event UserRoleRevoked(
        address indexed UserAddress,
        string Name,
        uint256 Role
    ); // Revisit & update with role as a string
    //Register event for user role re-assignment
    event UserRoleReassigned(
        address indexed UserAddress,
        string Name,
        uint256 Role
    ); // Revisit & update with role as a string

    //User struct with members
    struct UserInfo {
        address userAddress;
        string userName;
        string userLocation;
        roles userRole;
        string userStatus;
    }

    // UserInfo struct array to hold list of registered user
    UserInfo[] public UserList;

    //Map user with address
    mapping(address => UserInfo) UsersDetails;

    //Store registered user address
    address[] Users;

    // Register Admin by Owner who deployed contract
    // @param _address User Address
    // @param _name User name
    // @param _location User Location
    // @param _role User Role
    function registerAdmin(
        address _address,
        string memory _name,
        string memory _location,
        uint256 _role,
        string memory _userStatus
    ) public onlyOwner {
        require(UsersDetails[_address].userAddress != _address, "USR_EXIST");
        //Create & Populate User object with request params
        UserInfo memory newUser;
        newUser.userAddress = _address;
        newUser.userName = _name;
        newUser.userLocation = _location;
        newUser.userRole = roles(_role);
        newUser.userStatus = _userStatus;
        UsersDetails[_address] = newUser;
        //Push new user address to Users array
        Users.push(newUser.userAddress);
        //push user into array
        UserList.push(newUser);
        //Emit user registered event after user creation
        emit UserRegistered(_address, _name);
    }

    // Register New user by Owner/Admin
    // @param _address User Address
    // @param _name User name
    // @param _location User Location
    // @param _role User Role
    function registerUser(
        address _address,
        string memory _name,
        string memory _location,
        uint256 _role,
        string memory _userStatus
    ) public onlyAdmin {
        require(UsersDetails[_address].userAddress != _address, "USR_EXIST");
        //Create & Populate User object with request params
        UserInfo memory newUser;
        newUser.userAddress = _address;
        newUser.userName = _name;
        newUser.userLocation = _location;
        newUser.userRole = roles(_role);
        newUser.userStatus = _userStatus;
        UsersDetails[_address] = newUser;
        //Push new user address to Users array
        Users.push(newUser.userAddress);
        //push user into array
        UserList.push(newUser);
        // //Emit user registered event after user creation
        emit UserRegistered(_address, _name);
    }

    // Update user by Owner/Admin
    // @param _address User Address
    // @param _name User name
    // @param _location User Location
    // @param _role User Role
    function updateUser(
        address _address,
        string memory _name,
        string memory _location,
        uint256 _role,
        string memory _userStatus
    ) public onlyAdmin {
        require(UsersDetails[_address].userAddress == _address, "USR_NT_REG"); //User not registered
        //Update User object with request params
        UsersDetails[_address].userName = _name;
        UsersDetails[_address].userLocation = _location;
        UsersDetails[_address].userRole = roles(_role);
        UsersDetails[_address].userStatus = _userStatus;
        uint256 userToUpdateIndex;
        for (uint256 i = 0; i < UserList.length; i++) {
            if (UserList[i].userAddress == _address) {
                userToUpdateIndex = i;
            }
        }
        UserList[userToUpdateIndex].userName = _name;
        UserList[userToUpdateIndex].userLocation = _location;
        UserList[userToUpdateIndex].userRole = roles(_role);
        UserList[userToUpdateIndex].userStatus = _userStatus;
        emit UserRegistered(_address, _name);
    }

    function deleteUser(address _address) public onlyAdmin {
        require(UsersDetails[_address].userAddress == _address, "USR_NT_REG"); //User not registered
        //soft delete user from blockchain
        UsersDetails[_address].userStatus = "Inactive";
        findAndDeactivateUser(_address);
    }

    // Validate user based on address & username
    // @param _address User Address
    // @param _userName User Name
    function validateUser(address _address, string memory _userName)
        public
        view
        returns (UserInfo memory)
    {
        require(UsersDetails[_address].userAddress == _address, "USR_NT_REG"); //User not registered
        require(
            keccak256(bytes(UsersDetails[_address].userName)) ==
                keccak256(bytes(_userName)),
            "USR_NT_REG"
        ); //User not registered
        require(
            keccak256(bytes(UsersDetails[_address].userStatus)) ==
                keccak256(bytes("Active")),
            "USR_NT_ACTIVE"
        ); //User not active

        return getUserInfo(_address);
    }

    // Retrieve User information based on address
    // @param _address User Address
    function getUserInfo(address _address)
        public
        view
        returns (UserInfo memory)
    {
        return UsersDetails[_address];
    }

    // Retrieve Number of regsitered Users count
    function getUsersCount() public view returns (uint256 count) {
        return Users.length;
    }

    // Revoke user role based on address & emit event. Only admin can call this method
    // @param _address User Address
    function revokeUserRole(address _address) public onlyAdmin {
        require(UsersDetails[_address].userAddress == _address, "USR_NT_REG"); //User not registered
        UserInfo memory userInfo = getUserInfo(_address);
        userInfo.userRole = roles(7);
        UsersDetails[_address] = userInfo;
        //Emit user role revoked event after revoke operation
        emit UserRoleRevoked(
            _address,
            userInfo.userName,
            uint256(userInfo.userRole)
        );
    }

    // Re-Assign user role & emit event with updated user details. Only admin can call this method
    // @param _address User Address
    // @param _role User Role
    function reAssignUserRole(address _address, uint256 _role)
        public
        onlyAdmin
    {
        require(UsersDetails[_address].userAddress == _address, "USR_NT_REG"); //User not registered
        UserInfo memory userInfo = getUserInfo(_address);
        userInfo.userRole = roles(_role);
        UsersDetails[_address] = userInfo;
        //Emit user role re-assign event after role update operation
        emit UserRoleReassigned(
            _address,
            userInfo.userName,
            uint256(userInfo.userRole)
        );
    }

    //Function to retrieve all the registered users
    //Visibility - Public
    //Return type - list of user
    function getAllRegisteredUsers()
        public
        view
        onlyAdmin
        returns (UserInfo[] memory)
    {
        // UserInfo[] activeUsers;
        // for (uint256 i = 0; i < UserList.length; i++) {
        //     if ( keccak256(bytes(UserList[i].userStatus)) ==
        //         keccak256(bytes("active")) {
        //         activeUsers.push(i);
        //     }
        // }
        return UserList;
    }

    //Function to find user and delete based on address
    // Visibility - Public and payable
    function findAndDeactivateUser(address _address) public{
        uint256 userToDeleteIndex;
        //Find the index of user to be deleted
        for (uint256 i = 0; i < UserList.length; i++) {
            if (UserList[i].userAddress == _address) {
                userToDeleteIndex = i;
            }
        }
        UserList[userToDeleteIndex].userStatus = "Inactive";
    }
}
