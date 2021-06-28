// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
import "./RawMaterials.sol";

contract Supplier is User {
    mapping(address => address[]) SupplierRegisteredRawMaterialList;

    //Event
    event RawMaterialInitialize(
        address indexed MaterialID,
        address indexed Supplier,
        address Manufacturer,
        address indexed Transporter
    );

    modifier onlySupplier {
        require(
            UsersDetails[msg.sender].userRole == roles.supplier,
            "ORMSCC"
        );//Only Supplier can call this function.
        _;
    }

    //Initialize Raw Material Package with required details, transporter & manufacturer. Emit event with new package details.
    //@param _desc Raw Material description String
    //@param _producerName Raw material producer String
    //@param _location Supplier location String
    //@param _quantity Material Quantity Uint
    //@param _transporter Transporter/Shipper Address
    //@param _manufacturer Reciever/Manufacturer Address
    function createRawMaterialPackage(
        string memory _desc,
        string memory _producerName,
        string memory _location,
        uint256 _quantity,
        address _transporter,
        address _manufacturer
    ) public onlySupplier {
        RawMaterials rawMaterialData = new RawMaterials(
            msg.sender,
            _desc,
            _producerName,
            _location,
            _quantity,
            _transporter,
            _manufacturer
        );
        //populate raw material ID
        address _materialID = rawMaterialData.getRawMaterialID();
        //Push raw material address to list registered by supplier
        SupplierRegisteredRawMaterialList[msg.sender].push(_materialID);
        //Emit event after raw material registration
        emit RawMaterialInitialize(
            _materialID,
            msg.sender,
            _manufacturer,
            _transporter
        );
    }

    //Retrieve number of raw material packages registered by supplier. Only supplier can call this.
    function getSupplierRegisteredRawMaterialPackageCount()
        public
        view
        onlySupplier
        returns (uint256)
    {
        return SupplierRegisteredRawMaterialList[msg.sender].length;
    }

    //Retrieve raw material/package ID using index registered by supplier. Only supplier can call this.
    //@param index Uint
    function getSupplierRegisteredRawMaterialIDByIndex(uint256 index)
        public
        view
        onlySupplier
        returns (address materialID)
    {
        return SupplierRegisteredRawMaterialList[msg.sender][index];
    }

    //Retrieve material/package status using packageID. Only supplier can call this.
    //@param _packageID Address
    function getSupplierRegisteredRawMaterialPackageStatus(address _packageID)
        public
        view
        returns (uint256)
    {
        return RawMaterials(_packageID).getRawMaterialsStatus();
    }

    //Retrieve material/package details using packageID. Only supplier can call this.
    //@param _packageID Address
    function getSupplierRegisteredRawMaterialByPackageID(address _packageID)
        public
        view
        returns (
            address,
            string memory,
            string memory,
            string memory,
            uint256,
            address,
            address
        )
    {
        return RawMaterials(_packageID).getSuppliedRawMaterialDetails();
    }
}
