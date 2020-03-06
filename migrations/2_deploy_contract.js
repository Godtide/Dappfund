const Dappfund = artifacts.require("Dappfund");

module.exports = async (deployer) => {
  await deployer.deploy(Dappfund);
};
