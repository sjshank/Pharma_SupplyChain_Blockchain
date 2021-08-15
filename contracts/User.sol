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
        admin,
        inspector
    }

    modifier onlyAdmin {
        require(UsersDetails[msg.sender].userRole == roles.admin, "OACC"); //"Only Admin can call this function."
        _;
    }

    //User struct with members
    struct UserInfo {
        address userAddress;
        string userName;
        string userLocation;
        roles userRole;
        string userStatus;
        bool isDeleted;
        uint256 registrationDate;
    }

    // UserInfo struct array to hold list of registered user
    UserInfo[] public UserList;

    //Map user with address
    mapping(address => UserInfo) UsersDetails;

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
        newUser.isDeleted = false;
        newUser.registrationDate = block.timestamp;
        UsersDetails[_address] = newUser;
        //push user into array
        UserList.push(newUser);
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
        newUser.isDeleted = false;
        newUser.registrationDate = block.timestamp;
        UsersDetails[_address] = newUser;
        //push user into array
        UserList.push(newUser);
    }

    // Update user by Owner/Admin
    // @param _address User Address
    // @param _name User name
    // @param _location User Location
    // @param _role User Role
    function updateUser(
        address _address,
        string memory _location,
        string memory _userStatus
    ) public onlyAdmin {
        require(UsersDetails[_address].userAddress == _address, "USR_NT_REG"); //User not registered
        require(UsersDetails[_address].isDeleted == false, "USR_DELETED"); //User was deleted
        //Update User object with request params
        UsersDetails[_address].userLocation = _location;
        UsersDetails[_address].userStatus = _userStatus;
        uint256 userToUpdateIndex;
        for (uint256 i = 0; i < UserList.length; i++) {
            if (UserList[i].userAddress == _address) {
                userToUpdateIndex = i;
            }
        }
        UserList[userToUpdateIndex].userLocation = _location;
        UserList[userToUpdateIndex].userStatus = _userStatus;
    }

    function deleteUser(address _address) public onlyAdmin {
        require(UsersDetails[_address].userAddress == _address, "USR_NT_REG"); //User not registered
        //soft delete user from blockchain
        UsersDetails[_address].userStatus = "Inactive";
        UsersDetails[_address].isDeleted = true;
        findAndDeactivateUser(_address, true);
    }

    //Function to find user and delete based on address
    // Visibility - Public and payable
    function findAndDeactivateUser(address _address, bool _isDeleted) private {
        uint256 userToDeleteIndex;
        //Find the index of user to be deleted
        for (uint256 i = 0; i < UserList.length; i++) {
            if (UserList[i].userAddress == _address) {
                userToDeleteIndex = i;
            }
        }
        UserList[userToDeleteIndex].userStatus = "Inactive";
        if (_isDeleted == true) {
            UserList[userToDeleteIndex].isDeleted = true;
        }
    }
}
