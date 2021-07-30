const SupplyChain = artifacts.require("SupplyChain");
const BigNumber = require('bignumber.js');


// /*
// * This test class register accounts[1] as a supplier/producer of raw material. 
// */

contract("SupplyChain - Supplier Section", function (accounts) {
  before(async () => {
    this.supplyChain = await SupplyChain.deployed();
  });

  it("should deploy supplyChain contract", () => {
    console.log("*******************************************************************************");
    assert(this.supplyChain.address != '');
    console.log("*******************************************************************************");
  });

  it("should register new supplier & create Raw Material package", async () => {
    console.log("*******************************************************************************");
    await this.supplyChain.registerAdmin(accounts[5], 'USER_ADMIN', 'India', 8, 'Active', {
      from: accounts[0]
    });
    await this.supplyChain.registerUser(accounts[2], 'user_SUP', 'koradi', 1, 'Active', {
      from: accounts[5]
    })
    await this.supplyChain.createRawMaterialPackage("package desc", "Saurabh", "Koradi", 250, accounts[9], accounts[3], { from: accounts[2] });
    await this.supplyChain.createRawMaterialPackage("package desc", "Guddu", "Nagpur", 350, accounts[9], accounts[3], { from: accounts[2] });
    // const _rawMaterialCrtnEvt = rawMaterialCrtn.logs[0] && rawMaterialCrtn.logs[0].args;
    // console.log("_rawMaterialCrtnEvt-----", _rawMaterialCrtnEvt);
    const list = await this.supplyChain.getListOfRegisteredRawMateriaAddress(accounts[2]);
    let data = await this.supplyChain.getRegisteredRawMaterialDetails(list[1]);
    console.log("----data---", data);
    list.forEach(async (element) => {
      let data = await this.supplyChain.getRegisteredRawMaterialDetails(element);
      console.log("----data---", data);
    });


    // const pkgCount = await this.supplyChain.getSupplierRegisteredRawMaterialPackageCount({ from: accounts[1] });
    // console.log("pkgCount----", pkgCount);
    console.log("*******************************************************************************");
  });

  // it("should get count of raw material packages registered by supplier/producer", async () => {
  //   console.log("*******************************************************************************");
  //   await this.supplyChain.createRawMaterialPackage("package desc1", "Saurabh1", "Koradi1", 250, accounts[9], accounts[2], { from: accounts[1] });
  //   const pkgCount = await this.supplyChain.getSupplierRegisteredRawMaterialPackageCount({ from: accounts[1] });
  //   const pkgCountBN = new BigNumber(pkgCount);
  //   console.log("Count in Number -----", pkgCountBN.toNumber());
  //   console.log("*******************************************************************************");
  // });

  // it("should throw an error when function is called by other than supplier/producer", async () => {
  //   console.log("*******************************************************************************");
  //   await this.supplyChain.getSupplierRegisteredRawMaterialPackageCount({ from: accounts[4] });
  //   console.log("*******************************************************************************");
  // });

  // it("should display raw material package details based on index", async () => {
  //   console.log("*******************************************************************************");
  //   const pkgCount = await this.supplyChain.getSupplierRegisteredRawMaterialPackageCount({ from: accounts[1] });
  //   const pkgCountBN = new BigNumber(pkgCount);
  //   for (let index = 0; index < pkgCountBN.toNumber(); index++) {
  //     let materialObjAddr = await this.supplyChain.getSupplierRegisteredRawMaterialIDByIndex(index, { from: accounts[1] });
  //     console.log("materialObj address for - " + index + " -  index-----", materialObjAddr);
  //   }
  //   console.log("*******************************************************************************");
  // });
});
