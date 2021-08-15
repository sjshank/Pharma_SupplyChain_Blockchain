// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./User.sol";

import "./RawMaterials.sol";
import "./Medicine.sol";

contract Inspector is User {
    mapping(address => address[]) public TaggedTransporterMaterialList;
    mapping(address => address[]) public TaggedTransporterMedicineList;

    modifier onlyInspector {
        require(
            UsersDetails[msg.sender].userRole == roles.inspector,
            "OICC." //Only Inspector can call this function
        );
        _;
    }

    event UpdatedPackageStatus(address materialId, uint256 packageStatus);
    event UpdatedMedicineStatus(
        address medicineId,
        uint256 packageStatus,
        uint256[] transactionBlocks
    );

    //Inspect raw material & reject if condition not met
    function rejectMaterialPackageAfterInspection(
        address _materialId,
        address _transporter
    ) public onlyInspector {
        if (RawMaterials(_materialId).rejectPackageAtInspection()) {
            emit UpdatedPackageStatus(
                _materialId,
                RawMaterials(_materialId).getRawMaterialsStatus()
            );
        }
    }

    //Inspect raw material & approve is condition met
    function approveMaterialPackageAfterInspection(
        address _materialId,
        address _transporter
    ) public onlyInspector {
        if (RawMaterials(_materialId).approvePackageAtInspection()) {
            TaggedTransporterMaterialList[_transporter].push(_materialId);
            emit UpdatedPackageStatus(
                _materialId,
                RawMaterials(_materialId).getRawMaterialsStatus()
            );
        }
    }

    //Inspect medicine & reject if condition not met
    function rejectMedicineBatchAfterInspection(
        address _medicineId,
        address _transporter
    ) public onlyInspector {
        if (Medicine(_medicineId).rejectMedicineAtInspection()) {
            emit UpdatedMedicineStatus(
                _medicineId,
                Medicine(_medicineId).getMedicineStatus(),
                Medicine(_medicineId).getTransactionBlocks()
            );
        }
    }

    //Inspect medicine & approve is condition met
    function approveMedicineBatchAfterInspection(
        address _medicineId,
        address _transporter
    ) public onlyInspector {
        if (Medicine(_medicineId).approveMedicineAtInspection()) {
            TaggedTransporterMedicineList[_transporter].push(_medicineId);
            emit UpdatedMedicineStatus(
                _medicineId,
                Medicine(_medicineId).getMedicineStatus(),
                Medicine(_medicineId).getTransactionBlocks()
            );
        }
    }
}
