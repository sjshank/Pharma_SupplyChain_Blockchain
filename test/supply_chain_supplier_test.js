// const SupplyChain = artifacts.require("SupplyChain");
// const BigNumber = require('bignumber.js');


// /*
// * This test class register accounts[1] as a supplier/producer of raw material. 
// */

// contract("SupplyChain - Supplier Section", function (accounts) {
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
//     const _rawMaterialCrtnEvt = rawMaterialCrtn.logs[0] && rawMaterialCrtn.logs[0].args;
//     console.log("_rawMaterialCrtnEvt-----", _rawMaterialCrtnEvt);

//     // const pkgCount = await this.supplyChain.getSupplierRegisteredRawMaterialPackageCount({ from: accounts[1] });
//     // console.log("pkgCount----", pkgCount);
//     console.log("*******************************************************************************");
//   });

//   it("should get count of raw material packages registered by supplier/producer", async () => {
//     console.log("*******************************************************************************");
//     await this.supplyChain.createRawMaterialPackage("package desc1", "Saurabh1", "Koradi1", 250, accounts[9], accounts[2], { from: accounts[1] });
//     const pkgCount = await this.supplyChain.getSupplierRegisteredRawMaterialPackageCount({ from: accounts[1] });
//     const pkgCountBN = new BigNumber(pkgCount);
//     console.log("Count in Number -----", pkgCountBN.toNumber());
//     console.log("*******************************************************************************");
//   });

//   it("should throw an error when function is called by other than supplier/producer", async () => {
//     console.log("*******************************************************************************");
//     await this.supplyChain.getSupplierRegisteredRawMaterialPackageCount({ from: accounts[4] });
//     console.log("*******************************************************************************");
//   });

//   it("should display raw material package details based on index", async () => {
//     console.log("*******************************************************************************");
//     const pkgCount = await this.supplyChain.getSupplierRegisteredRawMaterialPackageCount({ from: accounts[1] });
//     const pkgCountBN = new BigNumber(pkgCount);
//     for (let index = 0; index < pkgCountBN.toNumber(); index++) {
//       let materialObjAddr = await this.supplyChain.getSupplierRegisteredRawMaterialIDByIndex(index, { from: accounts[1] });
//       console.log("materialObj address for - " + index + " -  index-----", materialObjAddr);
//     }
//     console.log("*******************************************************************************");
//   });
// });
