const SupplyChain = artifacts.require("SupplyChain");

module.exports = function (deployer, network, accounts) {
  deployer.deploy(SupplyChain).then(async (inst) => {
    const result = await inst.registerAdmin(accounts[1], 'USER_ADMIN', 'India', 8, 'Active');
    console.log(result.logs);
  })
};
