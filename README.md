# DappfUND 

This project is a simple Dapp that allows underrepresented founders to receive funding for their ideas using ethereum Blockchain.


> Simple dapp project using **Drizzlehooks**
> by **Tide Ayoade** 

## Prerequisites 
> To engage with **Dappfund** you will need the following:

* NodeJS ([https://nodejs.org/en/](https://nodejs.org/en/))
	> npm install nodejs
* Ganache([https://www.trufflesuite.com/ganache](https://www.trufflesuite.com/ganache))
	>npm install ganache-cli -g
* Truffle([https://www.trufflesuite.com/truffle] (https://www.trufflesuite.com/truffle))
	> npm install truffle
* Metamask (Chrome Extension) 🦊
	> Metamask is a chrome extension that helps you interact with web pages that want access to a (your) Ethereum wallet.

## Configuring Truffle
The project folder will contain a `truffle-config.js` file which is the configuration file, located at the root of the project directory. 
```javascript
module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    }
  }
};
 
## Deployment
>  Assuming you have set up all of the above correctly, with a test-net in the back running on port 8545, we can continue and deploy our main contract.
>  
Use truffle to migrate the main contract `Dappfund.sol`. This can be done by running the following commands in the root directory of the project:

> $ truffle migrate

Then we change into the client directory by executing `cd app` and install the neccessary modules by executing the following command:
> $ npm install
>
Having successfully installed everything within the client directory, we execute `npm start` to boot up the front-end locally.

##  Unit Tests // to be completed
To test with truffle you can execute the following command:
> $ truffle test

## DAPP Interface

> The user interface was developed using Truffle drizzle with its new feature Drizzle Hooks, which allow us through functional components make a more understandable code management of state all through the project.

> A final consideration this project interacts with the blockchain on multiple pages using `react-router-dom`.

>FORK
>IMPROVE
>MAKE A PR


