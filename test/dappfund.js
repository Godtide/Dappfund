const Dappfund = artifacts.require("Dappfund");
let catchRevert = require("./exceptionsHelpers.js").catchRevert



contract('Dappfund', function(accounts) {

  const deployAccount = accounts[0]
  const firstAccount = accounts[1]
  const secondAccount = accounts[2]
  const thirdAccount = accounts[3]



  let instance

  const product1 = {
      title: "title 1",
      description: "product 1 description",
      projectPitchURL: "URL 1"
  }

  const product2 = {
    title: "title 2",
    description: "product 2 description",
    projectPitchURL: "URL 2"
 }

 const product3 = {
      title: "title 3",
      description: "product 3 description",
      projectPitchURL: "URL 3"
  }

  beforeEach(async () => {
    instance = await Dappfund.new()
})

describe("Setup", async() => {

    it("platformOwner should be set to the deploying address", async() => {
        const owner = await instance.platformOwner()
        assert.equal(owner, deployAccount, "the deploying address should be the owner")
    })
})


describe("Functions", () => {
 describe("registerInvestor()", async() =>{

  it(" bool register should to be false for registration to occur", async() => {
    const Registered = await instance.register()
    assert.equal(Registered, false, "the account shouldn't have been registered")
    })

    it("registerInvestor should emit an event with the provided investor details", async() => {
      const tx = await instance.registerInvestor(firstAccount, {from: deployAccount} )
      //const eventData = tx.logs[0].args.

      assert.equal(tx.logs[0].args.investor, firstAccount, "the registered investor's account should match")
      })
})


describe("registerCreator()", async() =>{
  it(" bool register should to be false for registration to occur", async() => {
    const Registered = await instance.register()
    assert.equal(Registered, false, "the account shouldn't have been registered")
    })

  it("registerCreator should emit an event with the provided registered details", async() => {
      const tx = await instance.registerCreator(secondAccount, {from: deployAccount} )
      //const eventData = tx.logs[0].args
      //assert.equal(tx.receipt.status, true, "the action happened")
      assert.equal(tx.logs[0].args.creator, secondAccount, "the registered creator's account should match")
  })
})


describe("createProduct()", async() =>{
  xit("only a creator should be able to create Product", async() => {
      await instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
      await catchRevert(instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: firstAccount}))
  })

  xit("creating a product should emit an event with the provided product details", async() => {
      const tx = instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
      const eventData = tx.logs[0].args

      assert.equal(eventData.creator, secondAccount, "msg.sender must equal creator's account")
      assert.equal(eventData.tokenId.toNumber(), 1, "the products tokenId must be equal to 1")
       })
})

describe("getProduct()", async() =>{
  const isBlacklisted = false
  xit("providing the correct product Id should return the correct product details", async() => {
      await instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
      const eventDetails = await instance.getProduct(1)

      assert.equal(eventDetails['0'], product1.title, "the product's title should match")
      assert.equal(eventDetails['1'], product1.description, "the product's description should match")
      assert.equal(eventDetails['2'], product1.projectPitchURL, "the product's URL should match")
      assert.equal(eventDetails['3'], 0, "the product balance should be 0")
      assert.equal(eventDetails['4'], isBlacklisted, "the product should not be blacklisted")
      assert.equal(eventDetails['5'], false, "the product shouldn't be blacklisted")

  })
})


describe("fundProject()", async() =>{
   xit("only an Investor should be able to fund Product", async() => {
    await instance.registerInvestor(firstAccount, {from: deployAccount} )
    await instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
    await instance.fundProject(1, secondAccount, {from: firstAccount} )
    await catchRevert(instance.fundProject(1, secondAccount, {from: deployedAccount}))
})

  xit("only an registered creator is  able to receive funds", async() => {
    await instance.registerCreator(secondAccount, {from: firstAccount} )
    await instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
    await instance.fundProject(1, secondAccount, {from: firstAccount} )
    await catchRevert(instance.fundProject(1, deployAccount, {from: firstAccount}))
  })

 xit("only created products with Id can receive funds", async() => {
     await instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
     await instance.fundProject(1, secondAccount, {from: firstAccount} )
     await catchRevert(instance.fundProject(2, secondAccount, {from: firstAccount}))
 })

   xit("products should only be able to be funded when enough value is sent with the transaction", async() => {
      const msgValue = 1
      await instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
      await catchRevert(instance.fundProject(1, secondAccount, {from: firstAccount, value: msgValue - 1}))
  })
  xit("a LogFundProject() event with the correct details should be emitted when products are funded", async() => {
      const balanceOf = 1
      const msgValue = 1
      await instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
      const tx = await instance.fundProject(1, secondAccount, {from: firstAccount, value: msgValue})                
      const eventData = tx.logs[1].args

      assert.equal(eventData['3'], balanceOf, "the event should have the correct balance")
      assert.equal(eventData.msg.value, msgValue, "the event should have the correct number of funding granted")
   })
  })



describe("withdraw()", async() =>{
  xit("only an registered creator should be able to withdraw funds", async() => {
   await instance.registerCreator(secondAccount, {from: firstAccount} )
   await instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
   await instance.fundProject(1, secondAccount, {from: firstAccount} )
   await instance.withdraw( {from: secondAccount} )
   await catchRevert(instance.withdraw({from: firstAccount}))
})
  
xit("products should only be able to be funded when enough value is sent with the transaction", async() => {
  const msgValue = 1
  await instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
  await instance.fundProject(1, secondAccount, {from: firstAccount} )
  await catchRevert(instance.withdraw({from: secondAccount, value: msgValue - 1}))
})

xit("a LogWithdraw() event with the correct details should be emitted when tickets are purchased", async() => {
  const msgValue = 1
  await instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
  await instance.fundProject(1, secondAccount, {from: firstAccount} )
  const tx = await instance.withdraw({from: firstAccount, value: msgValue})                
  const eventData = tx.logs[0].args

  assert.equal(eventData.creatorAddr, secondAccount, "the event should have the correct sender account")
  assert.equal(eventData.amount, msgValue, "the event should have the correct number of funding granted")
   })
 })


describe("transferOwnership()", async() =>{
  xit("only a registered creator should be able to transfer tokens", async() => {
   await instance.registerCreator(secondAccount, {from: firstAccount} )
   await instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
   await instance.fundProject(1, secondAccount, {from: firstAccount} )
   await instance.transferOwnership(thirdAccount, 1, {from: secondAccount})
   await catchRevert(instance.transferOwnership({from: firstAccount}))
})
  //x to skip test until payable
xit("products should only be able to be funded when enough value is sent with the transaction", async() => {
  const msgValue = 1
  await instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
  await instance.fundProject(1, secondAccount, {from: firstAccount} )
  await catchRevert(instance.withdraw({from: secondAccount, value: msgValue - 1}))
})

xit("The creator should own the token transferred", async() => {
  await instance.registerCreator(secondAccount, {from: firstAccount} )
  await instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
  await instance.fundProject(1, secondAccount, {from: firstAccount} )
  await instance.transferOwnership(thirdAccount, 1, {from: secondAccount})
  await catchRevert(instance.transferOwnership(thirdAccount,2, {from: firstAccount}))
})

xit("a LogTransferOwnership() event with the correct details should be emitted when tokens are transferred", async() => {
  await instance.createProduct(product1.title, product1.description, product1.projectPitchURL, {from: secondAccount} )
  await instance.fundProject(1, secondAccount, {from: firstAccount} )
  await instance.transferOwnership(thirdAccount, 1, {from: secondAccount})
  const tx = await instance.transferOwnership(firstAccount, 1, {from: secondAccount})                
  const eventData = tx.logs[0].args

  assert.equal(eventData.creatorAddr, secondAccount, "the sender must equal creator's account")
  assert.equal(eventData.acct, firstAccount, "the event should have the correct account to receive tokens")
  assert.equal(eventData,tokenId, 1, "the event should have the correct tokenId")
       })
     })
    })
  })

