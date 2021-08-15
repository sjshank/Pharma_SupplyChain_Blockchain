// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";
import "./Medicine.sol";
import "./MedicineDP.sol";

contract Distributor is User {
    mapping(address => address[]) MedicineBatchesTransferred;
    mapping(address => address[]) public TaggedTransporterMedicineSubBatchList;

    modifier onlyDistributor {
        require(UsersDetails[msg.sender].userRole == roles.distributor, "ODCC"); //"Only Distributor can call this function."
        _;
    }

    event MedicineTransferredDPInitiated(
        address MedicineID,
        address indexed SubContractID,
        uint256 MedicineSubBatchStatus,
        uint256[] transactionBlocksDP
    );

    event UpdatedMedicineStatusOnReceived(
        address medicineId,
        uint256 packageStatus,
        uint256[] transactionBlocks
    );

    //Transfer received Medicine batch(from Manufacturer) to Pharma using tagged/associated shipper/transporter only. Only Distributor can call this.
    //@param _medicineID Medicine Batch/Package ID Address
    //@param _pharma Registered Pharma user Address
    //@param _transporter Registered Shipper/Transporter user Address
    function transferMedicineFromDistributorToPharma(
        address _medicineId,
        address _pharma,
        address _transporter
    ) public onlyDistributor {
        MedicineDP medicineDPData = new MedicineDP(
            _medicineId,
            msg.sender,
            _transporter,
            _pharma
        );
        address medicineSubContractId = address(medicineDPData);
        bool result = MedicineDP(medicineSubContractId)
        .initiateMedicineSubBatchTransfer();
        if (result) {
            MedicineBatchesTransferred[msg.sender].push(
                medicineSubContractId
            );
            TaggedTransporterMedicineSubBatchList[_transporter].push(
                medicineSubContractId
            );
            emit MedicineTransferredDPInitiated(
                _medicineId,
                medicineSubContractId,
                MedicineDP(medicineSubContractId).getMedicineSubBatchStatus(),
                MedicineDP(medicineSubContractId).getTransactionBlocksDP()
            );
        }
    }

    //Reject received medicine batch if damaged
    function rejectMedicineBatch(address _medicineId) public onlyDistributor {
        bool result = Medicine(_medicineId).rejectMedicineBatchAtReceiver();
        if (result) {
            emit UpdatedMedicineStatusOnReceived(
                _medicineId,
                Medicine(_medicineId).getMedicineStatus(),
                Medicine(_medicineId).getTransactionBlocks()
            );
        }
    }

    //Approve received medicine batch
    function approveMedicineBatch(address _medicineId) public onlyDistributor {
        bool result = Medicine(_medicineId).approveMedicineBatchAtReceiver();
        if (result) {
            emit UpdatedMedicineStatusOnReceived(
                _medicineId,
                Medicine(_medicineId).getMedicineStatus(),
                Medicine(_medicineId).getTransactionBlocks()
            );
        }
    }
}
