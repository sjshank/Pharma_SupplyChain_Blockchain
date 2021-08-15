// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract RawMaterials {
    address owner;

    enum status {
        packageRegistered,
        sentForInspection,
        rejectedByInspector,
        sentForShipment,
        pickedForManufacturer,
        deliveredAtManufacturer,
        rejectedByManufacturer,
        approvedByManufacturer
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
    //quality checker
    address inspector;

    //Initiate new Raw Material package by supplier with necessary details.
    constructor(
        address _supplier,
        string memory _description,
        string memory _producerName,
        string memory _location,
        uint256 _quantity,
        address _shipper,
        address _receiver,
        address _inspector
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
        inspector = _inspector;
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
            uint256[] memory _transactionBlocks,
            address _inspector
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
            transactionBlocks,
            inspector
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

    //send package for inspection
    function sendPackageForInspection() public returns (bool) {
        return updatePackageStatus(1, 0);
    }

    //Reject package by inspector
    function rejectPackageAtInspection() public returns (bool) {
        return updatePackageStatus(2, 1);
    }

    //Approve package or send package for shipment to transporter by inspector
    function approvePackageAtInspection() public returns (bool) {
        return updatePackageStatus(3, 1);
    }

    //Pick approved package for shipment by shipper
    function initiatePackageForShipment() public returns (bool) {
        return updatePackageStatus(4, 3);
    }

    //Deliver & update package by shipper
    function deliverPackageToReceiver() public returns (bool) {
        return updatePackageStatus(5, 4);
    }

    //Delivered package rejected by manufacturer
    function rejectPackageAtReceiver() public returns (bool) {
        return updatePackageStatus(6, 5);
    }

    //Delivered package approved by manufacturer
    function approvePackageAtReceiver() public returns (bool) {
        return updatePackageStatus(7, 5);
    }

    //Recieve & update raw material package status by tagged/associated receiver/manufacturer. Emit event with package details.
    //@param _shipper Transporter/Shipper Address
    function UpdatePackageStatusOnReceived() public {
        require(packageStatus == status(1), "RM_MUST_AT_M"); //Material package must be at manufacturer before status update.
        transactionBlocks.push(block.number);
        packageStatus = status(2);
    }

    function updatePackageStatus(uint256 _updatedStatus, uint256 _prevStatus)
        private
        returns (bool)
    {
        if (packageStatus == status(_prevStatus)) {
            transactionBlocks.push(block.number);
            packageStatus = status(_updatedStatus);
            return true;
        } else {
            revert("IN_PROCESS");
        }
    }
}
