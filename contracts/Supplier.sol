// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
import "./RawMaterials.sol";

contract Supplier is User {
    mapping(address => address[]) public SupplierRegisteredRawMaterialList;
    mapping(address => address[]) public MaterialShipmentList;
    mapping(address => address[]) public TaggedInspectorMaterialList;

    //Event
    event RawMaterialInitialize(
        address indexed materialId,
        address indexed supplier,
        address manufacturer,
        address indexed shipper,
        string producerName,
        string description,
        string location,
        uint256 quantity,
        address inspector,
        uint256 packageStatus
    );
    event UpdatedRawMaterialPackageStatus(
        address materialId,
        uint256 packageStatus
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
        address _manufacturer,
        address _inspector
    ) public onlySupplier {
        RawMaterials rawMaterialData = new RawMaterials(
            msg.sender,
            _desc,
            _producerName,
            _location,
            _quantity,
            _transporter,
            _manufacturer,
            _inspector
        );
        //Push raw material address to list registered by supplier
        SupplierRegisteredRawMaterialList[msg.sender].push(
            address(rawMaterialData)
        );
        //Emit event after raw material registration
        emit RawMaterialInitialize(
            address(rawMaterialData),
            msg.sender,
            _manufacturer,
            _transporter,
            _producerName,
            _desc,
            _location,
            _quantity,
            _inspector,
            0
        );
    }

    //Update material details for materialid. Only supplier can call this.
    function updateRawMaterial(
        address _materialId,
        string memory _desc,
        string memory _producerName,
        string memory _location,
        uint256 _quantity,
        address _transporter,
        address _manufacturer,
        address _inspector
    ) public onlySupplier {
        RawMaterials(_materialId).updateRawMaterialDetails(
            _desc,
            _producerName,
            _location,
            _quantity,
            _transporter,
            _manufacturer
        );
        emit RawMaterialInitialize(
            _materialId,
            msg.sender,
            _manufacturer,
            _transporter,
            _producerName,
            _desc,
            _location,
            _quantity,
            _inspector,
            0
        );
    }

    //Supplier will send package to inspector for inspection
    function sendMaterialPackageForInspection(
        address _materialId,
        address _inspector
    ) public onlySupplier {
        bool result = RawMaterials(_materialId).sendPackageForInspection();
        if (result) {
            TaggedInspectorMaterialList[_inspector].push(_materialId);
            emit UpdatedRawMaterialPackageStatus(
                _materialId,
                RawMaterials(_materialId).getRawMaterialsStatus()
            );
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
