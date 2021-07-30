// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract RawMaterials {
    address owner;

    enum status {
        atProducer,
        pickedForManufacturer,
        deliveredAtManufacturer
    }

    //Raw material id
    address materialId;
    //Material description
    string description;
    //material producer/farmer name
    string producerName;
    //base location of material
    string location;
    //material quantity
    uint256 quantity;
    //material shipper
    address shipper;
    //product manufacturer
    address manufacturer;
    //material supplier/producer
    address supplier;
    //material package status
    status packageStatus;
    //transaction time
    uint256[] transactionBlocks;

    //Initiate new Raw Material package by supplier with necessary details.
    constructor(
        address _supplier,
        string memory _description,
        string memory _producerName,
        string memory _location,
        uint256 _quantity,
        address _shipper,
        address _receiver
    ) {
        owner = _supplier;
        materialId = address(this);
        description = _description;
        producerName = _producerName;
        location = _location;
        quantity = _quantity;
        shipper = _shipper;
        manufacturer = _receiver;
        supplier = _supplier;
        shipper = _shipper;
        packageStatus = status(0);
        transactionBlocks.push(block.number);
    }

    //Get the Raw material package details initiated using constructor
    function getSuppliedRawMaterialDetails()
        public
        view
        returns (
            address _materialId,
            address _supplier,
            string memory _description,
            string memory _producerName,
            string memory _location,
            uint256 _quantity,
            address _shipper,
            address _receiver,
            uint256 _status,
            uint256[] memory _transactionBlocks
        )
    {
        return (
            materialId,
            supplier,
            description,
            producerName,
            location,
            quantity,
            shipper,
            manufacturer,
            uint256(packageStatus),
            transactionBlocks
        );
    }

    function updateRawMaterialDetails(
        string memory _description,
        string memory _producerName,
        string memory _location,
        uint256 _quantity,
        address _shipper,
        address _receiver
    ) public {
        description = _description;
        producerName = _producerName;
        location = _location;
        quantity = _quantity;
        shipper = _shipper;
        manufacturer = _receiver;
    }

    //Get the Raw material package status.
    function getRawMaterialsStatus() public view returns (uint256) {
        return uint256(packageStatus);
    }

    //Get the Raw material/batch ID.
    function getRawMaterialID() public view returns (address) {
        return materialId;
    }

    //Pick & update raw material package status by tagged/associated shipper/transporter. Emit event with package details.
    //@param _shipper Transporter/Shipper Address
    function pickRawMaterialPackage() public {
        require(packageStatus == status(0), "RM_MUST_AT_S"); //Material package must be at producer before shippment
        transactionBlocks.push(block.number);
        packageStatus = status(1);
    }

    //Recieve & update raw material package status by tagged/associated receiver/manufacturer. Emit event with package details.
    //@param _shipper Transporter/Shipper Address
    function UpdatePackageStatusOnReceived() public {
        require(packageStatus == status(1), "RM_MUST_AT_M"); //Material package must be at manufacturer before status update.
        transactionBlocks.push(block.number);
        packageStatus = status(2);
    }
}
