// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
import "./Admin.sol";

contract User is Admin {
    enum roles {
        norole,
        supplier,
        transporter,
        manufacturer,
        wholesaler,
        distributer,
        pharma,
        revoke
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
    }

    //Map user with address
    mapping(address => UserInfo) UsersDetails;

    //Store registered user address
    address[] Users;

    // Register New user by Owner/Admin
    // @param _address User Address
    // @param _name User name
    // @param _location User Location
    // @param _role User Role
    function registerUser(
        address _address,
        string memory _name,
        string memory _location,
        uint256 _role
    ) public onlyAdmin {
        require(
            UsersDetails[_address].userAddress != _address,
            "User already registered !"
        );
        //Create & Populate User object with request params
        UserInfo memory newUser;
        newUser.userAddress = _address;
        newUser.userName = _name;
        newUser.userLocation = _location;
        newUser.userRole = roles(_role);
        UsersDetails[_address] = newUser;
        //Push new user address to Users array
        Users.push(newUser.userAddress);
        //Emit user registered event after user creation
        emit UserRegistered(_address, _name);
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
}
