const DappFund = artifacts.require("DappFund");

module.exports = async (deployer, network, accounts) => {
  const dappfund = await DappFund.deployed();

  // set ENS name for daapfund service
  await deployer.ens.setAddress(
    "addr.dappfund", dappfund, { from: accounts[0] }
  );

  // set ENS name for a few participants
  await deployer.ens.setAddress(
    "alice.name", accounts[0], { from: accounts[0] }
  );
  await deployer.ens.setAddress(
    "bob.name", accounts[1], { from: accounts[0] }
  );
  await deployer.ens.setAddress(
    "calhoun.name", accounts[2], { from: accounts[0] }
  );

};
