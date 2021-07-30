// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

/**************************************************
 * TransporterType
 * 1 - Supplier to Manufacturer
 * 2 - Manufacturer to Distributor
 * 3 - Distributor to Pharma
 **************************************************/

contract Medicine {
    address owner;

    enum status {
        atManufacturer,
        pickedForDistributor,
        deliveredAtDistributor,
        pickedForPharma,
        deliveredAtPharma
    }

    //Medicine id
    address public medicineId;
    //Medicine description
    string description;
    //Medicine name
    string medicineName;
    //Medicine manufacturing unit location
    string location;
    //Medicine quantity
    uint256 quantity;
    //Raw Material information used for creating medicine
    address materialId;
    //Medicine shipper/transporter
    address shipper;
    //Medicine distributor
    address distributor;
    //Medicine at Pharmaceutical
    address pharma;
    //Medicine manufacturer/manufacturer
    address manufacturer;
    //medicine package status
    status public packageStatus;
    //transaction time
    uint256[] transactionBlocks;

    // event ShippmentUpdate(
    //     address indexed BatchId,
    //     address indexed Shipper,
    //     address indexed Manufacturer,
    //     uint256 TransporterType,
    //     uint256 Status
    // );

    //Initiate new Medicine package by manufacturer with necessary details.
    constructor(
        address _manufacturer,
        address _materialId,
        string memory _description,
        string memory _medicineName,
        string memory _location,
        uint256 _quantity,
        address _shipper,
        address _receiver
    ) {
        owner = _manufacturer;
        materialId = _materialId;
        medicineId = address(this);
        description = _description;
        medicineName = _medicineName;
        location = _location;
        quantity = _quantity;
        shipper = _shipper;
        distributor = _receiver;
        manufacturer = _manufacturer;
        shipper = _shipper;
        packageStatus = status(0);
        transactionBlocks.push(block.number);
    }

    //Get the Medicine package details initiated using constructor
    function getManufacteredMedicineDetails()
        public
        view
        returns (
            address _medicineId,
            address _manufacturer,
            string memory _description,
            string memory _medicineName,
            string memory _location,
            address _materialId,
            uint256 _quantity,
            address _shipper,
            address _distributor,
            uint256 _status,
            uint256[] memory _transactionBlocks
        )
    {
        return (
            medicineId,
            manufacturer,
            description,
            medicineName,
            location,
            materialId,
            quantity,
            shipper,
            distributor,
            uint256(packageStatus),
            transactionBlocks
        );
    }

    function updateMedicineBatchDetails(
        string memory _medicineName,
        string memory _description,
        string memory _location,
        uint256 _quantity,
        address _shipper,
        address _receiver
    ) public {
        description = _description;
        medicineName = _medicineName;
        location = _location;
        quantity = _quantity;
        shipper = _shipper;
        distributor = _receiver;
    }

    //Get the Medicine/batch ID.
    function getMedicineID() public view returns (address) {
        return medicineId;
    }

    //Get the Medicine package status.
    function getMedicineStatus() public view returns (uint256) {
        return uint256(packageStatus);
    }

    /************************************************************************* MANUFACTURER TO DISTRIBUTOR SHIPPMENT *************************************************************************/

    //Pick & update medicine package status by tagged/associated shipper/transporter. Emit event with package details.
    //@param _shipper Transporter/Shipper Address
    function pickMedicinePackageForDistributor() public {
        // require(_shipper == shipper, "OSCC"); //Only tagged shipper can call this.
        require(packageStatus == status(0), "M_MUST_AT_M"); //"Medicine package must be at manufacturer before shippment."
        transactionBlocks.push(block.number);
        packageStatus = status(1);
        // emit ShippmentUpdate(medicineId, _shipper, distributor, 2, 1);
    }

    //Recieve & update medicine package status by tagged/associated receiver/distributor. Emit event with package details.
    //@param _shipper Transporter/Shipper Address
    function updatePackageStatusOnReceivedByDistributor() public {
        // require(_receiver == distributor, "ORDCC"); //Only tagged reciever/distributor can call this.
        require(packageStatus == status(1), "M_MUST_AT_D"); //Medicine package must be at distributor before status update.
        transactionBlocks.push(block.number);
        packageStatus = status(2);
        // emit ShippmentUpdate(materialId, shipper, _receiver, 2, 2);
    }

    /************************************************************************* DISTRIBUTOR TO PHARMA SHIPPMENT *************************************************************************/

    //Pick & update medicine package status by tagged/associated shipper/transporter. Emit event with package details.
    //@param _shipper Transporter/Shipper Address
    function pickMedicinePackageForPharma(address _receiver) public {
        // require(_shipper == shipper, "OSCC"); //Only tagged shipper can call this.
        require(packageStatus == status(2), "M_MUST_AT_D"); //"Medicine package must be at distributor before shippment."
        transactionBlocks.push(block.number);
        packageStatus = status(3);
        pharma = _receiver;
        // emit ShippmentUpdate(medicineId, _shipper, pharma, 3, 3);
    }

    //Recieve & update medicine package status by tagged/associated receiver/pharma. Emit event with package details.
    //@param _shipper Transporter/Shipper Address
    function updatePackageStatusOnReceivedByPharma() public {
        // require(_receiver == pharma, "ORPCC"); //Only tagged reciever/pharma can call this.
        require(packageStatus == status(3), "M_MUST_AT_P"); //"Medicine package must be at pharma before status update."
        transactionBlocks.push(block.number);
        packageStatus = status(4);
        // emit ShippmentUpdate(materialId, shipper, _receiver, 3, 4);
    }
}
