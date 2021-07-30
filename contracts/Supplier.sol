// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
import "./RawMaterials.sol";

contract Supplier is User {
    mapping(address => address[]) public SupplierRegisteredRawMaterialList;
    mapping(address => address[]) public MaterialShipmentList;

    //Event
    event RawMaterialInitialize(
        address indexed MaterialID,
        address indexed Supplier,
        address Manufacturer,
        address indexed Transporter
    );

    modifier onlySupplier {
        require(UsersDetails[msg.sender].userRole == roles.supplier, "ORMSCC"); //Only Supplier can call this function.
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

    //Update material details for materialid. Only supplier can call this.
    function updateRawMaterial(
        address _materialID,
        string memory _desc,
        string memory _producerName,
        string memory _location,
        uint256 _quantity,
        address _transporter,
        address _manufacturer
    ) public onlySupplier {
        RawMaterials(_materialID).updateRawMaterialDetails(
            _desc,
            _producerName,
            _location,
            _quantity,
            _transporter,
            _manufacturer
        );
    }

    //Load & ship raw material from supplier to manufacturer. Only Supplier call this.
    function loadAndShipRawMaterialBatch(
        address _materialID,
        address _manufacturer
    ) public onlySupplier {
        RawMaterials(_materialID).pickRawMaterialPackage();
        if (RawMaterials(_materialID).getRawMaterialsStatus() == 1) {
            MaterialShipmentList[_manufacturer].push(_materialID);
        }
    }

    function getTotalMaterialPackagesShippedCount(address _manufacturer)
        public
        view
        returns (uint256)
    {
        return MaterialShipmentList[_manufacturer].length;
    }
}
