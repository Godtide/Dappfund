import Web3 from "web3";
import Dappfund from "./contracts/Dappfund.json";

const options = {
  web3: {
    block: false,
    customProvider: new Web3("ws://localhost:8545"),
  },
  contracts: [Dappfund],
  /*events: {
    Dappfund: ["LogForCreateProduct", "LogForUnfreeze", "LogForFreeze",
     "LogForRegisterCreator", "LogForRegisterInvestor", "LogForFundProject",
    "LogForTransferOwnership", "LogForWithdraw"]
  },
  */
polls: {
  accounts: 1500,
},
};

export default options;
