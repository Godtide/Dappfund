const Dappfund = artifacts.require("Dappfund");

module.exports = function(deployer) {
  deployer.deploy(Dappfund);
};
