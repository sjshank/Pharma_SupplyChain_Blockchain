// const SupplyChain = artifacts.require("SupplyChain");
// const BigNumber = require('bignumber.js');


// /*
// * This test class register accounts[9] as a shipper/transporter for loading consignment. 
// */

// contract("SupplyChain - Transporter Section", function (accounts) {
//   before(async () => {
//     this.supplyChain = await SupplyChain.deployed();
//   });

//   it("should deploy supplyChain contract", () => {
//     console.log("*******************************************************************************");
//     assert(this.supplyChain.address != '');
//     console.log("*******************************************************************************");
//   });

//   it("should register new supplier & create Raw Material package", async () => {
//     console.log("*******************************************************************************");
//     await this.supplyChain.registerUser(accounts[1], 'user_SUP', 'koradi', 1, {
//       from: accounts[0]
//     })
//     const rawMaterialCrtn = await this.supplyChain.createRawMaterialPackage("package desc", "Saurabh", "Koradi", 250, accounts[9], accounts[2], { from: accounts[1] });
//     console.log("*******************************************************************************");
//   });

//   it("should register new transporter/shipper & load consignment for Supplier to Manufacturer delivery", async () => {
//     console.log("*******************************************************************************");
//     const shprUser = await this.supplyChain.registerUser(accounts[9], 'user_SHPR', 'Nagpur', 2, {
//       from: accounts[0]
//     });

//     console.log("----Transporter user---", shprUser.logs[0].args);
//     const pkgCount = await this.supplyChain.getSupplierRegisteredRawMaterialPackageCount({ from: accounts[1] });
//     const pkgCountBN = new BigNumber(pkgCount);
//     console.log("pkg count----", pkgCountBN.toNumber());
//     if (pkgCountBN.toNumber() > 0) {
//       const packageID = await this.supplyChain.getSupplierRegisteredRawMaterialIDByIndex(0, { from: accounts[1] });
//       const statusBeforeConsignmentLoaded = await this.supplyChain.getSupplierRegisteredRawMaterialPackageStatus(packageID, { from: accounts[1] });
//       console.log("statusBeforeConsignmentLoaded----->>>>", statusBeforeConsignmentLoaded);
//       const result = await this.supplyChain.loadConsignment(packageID, 1, accounts[6], { from: accounts[9] });
//       console.log("result----->>>>", result);
//       const statusAfterConsignmentLoaded = await this.supplyChain.getSupplierRegisteredRawMaterialPackageStatus(packageID, { from: accounts[1] });
//       console.log("statusAfterConsignmentLoaded----->>>>", statusAfterConsignmentLoaded);
//     }
//     console.log("*******************************************************************************");
//   });

// });
