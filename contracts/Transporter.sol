// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";

import "./RawMaterials.sol";

import "./Medicine.sol";

import "./MedicineDP.sol";

contract Transporter is User {
    mapping(address => address[]) public ManufacturerTaggedMaterialList;
    mapping(address => address[]) public DistributorTaggedMedicineList;
    mapping(address => address[]) public PharmaTaggedMedicineSubBatchList;

    modifier onlyTransporter {
        require(
            UsersDetails[msg.sender].userRole == roles.transporter,
            "OTCC." //Only Transporter can call this function
        );
        _;
    }

    event UpdatedMaterialShipmentStatus(
        address materialId,
        uint256 packageStatus
    );

    event UpdatedMedicineShipmentStatus(
        address medicineId,
        uint256 packageStatus,
        uint256[] transactionBlocks
    );

    event UpdatedMedicineSubBatchShipmentStatus(
        address medicineSubContract,
        address medicineId,
        uint256 packageStatus,
        uint256[] transactionBlocksDP
    );

    //Load raw material package from sender & delivered to associated receiver
    function loadMaterialPackageForShipment(
        address _materialId,
        address _receiver
    ) public onlyTransporter {
        if (RawMaterials(_materialId).initiatePackageForShipment()) {
            ManufacturerTaggedMaterialList[_receiver].push(_materialId);
            emit UpdatedMaterialShipmentStatus(
                _materialId,
                RawMaterials(_materialId).getRawMaterialsStatus()
            );
        }
    }

    //deliver to associated receiver & update status
    function deliverShippedMaterialPackage(
        address _materialId,
        address _receiver
    ) public onlyTransporter {
        if (RawMaterials(_materialId).deliverPackageToReceiver()) {
            emit UpdatedMaterialShipmentStatus(
                _materialId,
                RawMaterials(_materialId).getRawMaterialsStatus()
            );
        }
    }

    //Load medicine package from sender & delivered to associated receiver
    function loadMedicineBatchForShipment(
        address _medicineId,
        address _receiver
    ) public onlyTransporter {
        if (Medicine(_medicineId).initiateMedicineBatchForShipment()) {
            DistributorTaggedMedicineList[_receiver].push(_medicineId);
            emit UpdatedMedicineShipmentStatus(
                _medicineId,
                Medicine(_medicineId).getMedicineStatus(),
                Medicine(_medicineId).getTransactionBlocks()
            );
        }
    }

    //deliver to associated receiver & update status
    function deliverShippedMedicineBatch(address _medicineId, address _receiver)
        public
        onlyTransporter
    {
        if (Medicine(_medicineId).deliverMedicineBatchToReceiver()) {
            emit UpdatedMedicineShipmentStatus(
                _medicineId,
                Medicine(_medicineId).getMedicineStatus(),
                Medicine(_medicineId).getTransactionBlocks()
            );
        }
    }

    //Load medicine package from sender & delivered to associated receiver (Dist-Pharma)
    function loadMedicineSubBatchForShipment(
        address _subContractId,
        address _receiver
    ) public onlyTransporter {
        if (MedicineDP(_subContractId).initiateMedicineSubBatchForShipment()) {
            PharmaTaggedMedicineSubBatchList[_receiver].push(_subContractId);
            emit UpdatedMedicineSubBatchShipmentStatus(
                _subContractId,
                MedicineDP(_subContractId).getMedicineID(),
                MedicineDP(_subContractId).getMedicineSubBatchStatus(),
                MedicineDP(_subContractId).getTransactionBlocksDP()
            );
        }
    }

    //deliver to associated receiver & update status (Dist-Pharma)
    function deliverShippedMedicineSubBatch(
        address _subContractId,
        address _receiver
    ) public onlyTransporter {
        if (MedicineDP(_subContractId).deliverMedicineSubBatchToReceiver()) {
            emit UpdatedMedicineSubBatchShipmentStatus(
                _subContractId,
                MedicineDP(_subContractId).getMedicineID(),
                MedicineDP(_subContractId).getMedicineSubBatchStatus(),
                MedicineDP(_subContractId).getTransactionBlocksDP()
            );
        }
    }
}
