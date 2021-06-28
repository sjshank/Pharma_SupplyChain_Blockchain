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

    event ShippmentUpdate(
        address indexed BatchId,
        address indexed Shipper,
        address indexed Manufacturer,
        uint256 TransporterType,
        uint256 Status
    );

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
    }

    modifier onlyTransporter {
        require(msg.sender == shipper, "ORCC"); //"Only tagged shipper/transporter can call this."
        _;
    }

    modifier onlyManufacturer {
        require(msg.sender == manufacturer, "OMCC"); // "Only tagged reciever/manufacturer can call this."
        _;
    }

    //Get the Raw material package details initiated using constructor
    function getSuppliedRawMaterialDetails()
        public
        view
        returns (
            address _supplier,
            string memory _description,
            string memory _producerName,
            string memory _location,
            uint256 _quantity,
            address _shipper,
            address _receiver
        )
    {
        return (
            supplier,
            description,
            producerName,
            location,
            quantity,
            shipper,
            manufacturer
        );
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
    function pickRawMaterialPackage(address _shipper) public {
        require(_shipper == shipper, "OSCC"); //Only tagged shipper can call this.
        require(packageStatus == status(0), "RM_MUST_AT_S"); //Material package must be at producer before shippment
        packageStatus = status(1);
        emit ShippmentUpdate(materialId, _shipper, manufacturer, 1, 1);
    }

    //Recieve & update raw material package status by tagged/associated receiver/manufacturer. Emit event with package details.
    //@param _shipper Transporter/Shipper Address
    function UpdatePackageStatusOnReceived(address _receiver) public {
        require(_receiver == manufacturer, "ORMCC"); //Only tagged reciever/manufacturer can call this.
        require(packageStatus == status(1), "RM_MUST_AT_M"); //Material package must be at manufacturer before status update.
        packageStatus = status(2);
        emit ShippmentUpdate(materialId, shipper, _receiver, 1, 2);
    }
}
