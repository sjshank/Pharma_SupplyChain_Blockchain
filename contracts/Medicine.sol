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
        medicineRegistered,
        sentForInspection,
        rejectedByInspector,
        sentForShipment,
        pickedForDistributor,
        deliveredAtDistributor,
        rejectedByDistributor,
        approvedByDistributor
    }

    struct MedicineInfo {
        //Medicine id
        address medicineId;
        //Medicine name
        string medicineName;
        //Medicine description
        string description;
        //Medicine manufacturing unit location
        string location;
        //Medicine quantity
        uint256 quantity;
    }

    struct Entity {
        //Medicine shipper/transporter
        address shipper;
        //Medicine distributor
        address distributor;
        //Medicine manufacturer/manufacturer
        address manufacturer;
        //quality checker
        address inspector;
    }

    //Raw Material information used for creating medicine
    address materialId;
    //medicine package status
    status public packageStatus;
    //transaction time
    uint256[] transactionBlocks;
    //Different entities
    Entity entity;
    //Medicine details
    MedicineInfo medicineInfo;
    //Medicine at Pharmaceutical
    address pharma;

    //Initiate new Medicine package by manufacturer with necessary details.
    constructor(
        address _manufacturer,
        address _materialId,
        string memory _medicineName,
        string memory _description,
        string memory _location,
        uint256 _quantity,
        address _transporter,
        address _distributor,
        address _inspector
    ) {
        materialId = _materialId;
        medicineInfo.medicineId = address(this);
        medicineInfo.medicineName = _medicineName;
        medicineInfo.description = _description;
        medicineInfo.location = _location;
        medicineInfo.quantity = _quantity;
        entity.shipper = _transporter;
        entity.distributor = _distributor;
        entity.manufacturer = _manufacturer;
        entity.inspector = _inspector;
        packageStatus = status(0);
        transactionBlocks.push(block.number);
    }

    //Get the Medicine package details initiated using constructor
    function getManufacteredMedicineDetails()
        public
        view
        returns (
            address _medicineId,
            // MedicineInfo memory _medicineInfo,
            string memory _medicineName,
            string memory _description,
            string memory _location,
            Entity memory _entity,
            address _materialId,
            uint256 _quantity,
            uint256 _status,
            uint256[] memory _transactionBlocks
        )
    {
        return (
            medicineInfo.medicineId,
            medicineInfo.medicineName,
            medicineInfo.description,
            medicineInfo.location,
            entity,
            materialId,
            medicineInfo.quantity,
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
    ) public returns (bool) {
        medicineInfo.medicineName = _medicineName;
        medicineInfo.description = _description;
        medicineInfo.location = _location;
        medicineInfo.quantity = _quantity;
        entity.shipper = _shipper;
        entity.distributor = _receiver;
        return true;
    }

    //get medicine info
    function getMedicineInfo() public view returns (MedicineInfo memory) {
        return medicineInfo;
    }

    //get medicine entity
    function getMedicineEntity() public view returns (Entity memory) {
        return entity;
    }

    //Get the Medicine/batch ID.
    function getMedicineID() public view returns (address) {
        return medicineInfo.medicineId;
    }

    //Get the Material/batch ID.
    function getMaterialID() public view returns (address) {
        return materialId;
    }

    //Get the Medicine package status.
    function getMedicineStatus() public view returns (uint256) {
        return uint256(packageStatus);
    }

    //Get the Medicine package status.
    function getTransactionBlocks() public view returns (uint256[] memory) {
        return transactionBlocks;
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

    //send medicine for inspection
    function sendMedicineForInspection() public returns (bool) {
        return updateMedicineBatchStatus(1, 0);
    }

    //Reject medicine by inspector
    function rejectMedicineAtInspection() public returns (bool) {
        return updateMedicineBatchStatus(2, 1);
    }

    //Approve medicine or send medicine batch for shipment to transporter by inspector
    function approveMedicineAtInspection() public returns (bool) {
        return updateMedicineBatchStatus(3, 1);
    }

    //Pick approved medicine batch for shipment by shipper
    function initiateMedicineBatchForShipment() public returns (bool) {
        return updateMedicineBatchStatus(4, 3);
    }

    //Deliver & update medicine batch by shipper
    function deliverMedicineBatchToReceiver() public returns (bool) {
        return updateMedicineBatchStatus(5, 4);
    }

    //Delivered medicine batch rejected by distributor
    function rejectMedicineBatchAtReceiver() public returns (bool) {
        return updateMedicineBatchStatus(6, 5);
    }

    //Delivered medicine batch approved by distributor
    function approveMedicineBatchAtReceiver() public returns (bool) {
        return updateMedicineBatchStatus(7, 5);
    }

    function updateMedicineBatchStatus(
        uint256 _updatedStatus,
        uint256 _prevStatus
    ) private returns (bool) {
        if (packageStatus == status(_prevStatus)) {
            transactionBlocks.push(block.number);
            packageStatus = status(_updatedStatus);
            return true;
        } else {
            revert("IN_PROCESS");
        }
    }
}
