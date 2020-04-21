import React from 'react'
import { drizzleReactHooks } from "@drizzle/react-plugin"
import Swal from 'sweetalert2'

const { useDrizzle, useDrizzleState } = drizzleReactHooks;

function ProductCreate() {

    const { drizzle } = useDrizzle();
    const state = useDrizzleState(state => state);
    
    const stateApp = {};

    const handleChange = (e, x) => {
        stateApp[e.target.id] = e.target.value;
      //  const {name, value} = e.target;
    }

    const handleSubmit = (e) => {
        e.preventDefault();
    }

            
    const registerCreator = async () => {   
        const creator = await drizzle.contracts.Dappfund.methods.registerCreator(
            //registration will be payable in the future
            stateApp['address']
            ).send({from: state.accounts[0]})
         if(creator.status) {
             Swal.fire({
                 title: "Yeah!",
                 text: ' You are a creator!',
                 type: "success"
             });
         } else {
             Swal.fire({
                 title: "Opps!",
                 text: 'Error completing registration!',
                 type: "error"
             });
         }
     }

    const createProduct = async () => {

        // If Drizzle is initialized (and therefore web3, accounts and contracts), continue.
        if (state.drizzleStatus.initialized) {
            console.log(state.drizzleStatus.initialized)
          // const pro = await drizzle.contracts.Dappfund.methods._getProductId().call()
            const transaction = await drizzle.contracts.Dappfund.methods.createProduct(
                stateApp['title'],
                stateApp['description'],
                stateApp['projectPitchURL'])
             .send({from: state.accounts[0]})
        console.log(transaction)
            if(transaction.status) {
                Swal.fire({
                    title: "Yeah!",
                    text: 'Product created on the blockchain!',
                    type: "success"
                }).then(function() {
                    window.location = "/";
                });
            } else {
                Swal.fire({
                    title: "Opps!",
                    text: 'Error creating your product on blockchain!',
                    type: "error"
                });
            }
        }
    }


    const withdraw = async () => {   
        const draw = await drizzle.contracts.Dappfund.methods.withdraw().send({from: state.accounts[0], 
            value: drizzle.web3.utils.toWei(stateApp['amount'], 'ether').toBN  })
        
        if(draw.status) {
            Swal.fire({
                title: "Yeah!",
                text: 'Withdrawal Successful!',
                type: "success"
            });
        } else {
            Swal.fire({
                title: "Opps!",
                text: 'Error Withdrawing your funds!',
                type: "error"
            });
        }
    }

    const transferOwnerShip  = async () => {   
        const transfer = await drizzle.contracts.Dappfund.methods.transferOwnerShip(
        stateApp['addressass'],
        stateApp['tokenId']
        ).send({from: state.accounts[0] //: will be payable in the future
        })
    
    if(transfer.status) {
        Swal.fire({
            title: "Yeah!",
            text: 'Transfer Successful!',
            type: "success"
        });
    } else {
        Swal.fire({
            title: "Opps!",
            text: 'Error Transfering ownershp!',
            type: "error"
        });
    }
}
     return (

            <div className="container">
       <form onSubmit={handleSubmit} className="white">
          <div className="input-field">
             <label htmlFor="address">Address</label>
             <input type="text" id='address' onChange={handleChange}
             placeholder={"Your address goes here"} />
          </div>
          <div className="input-field-btn">
             <button value="Submit" onClick={registerCreator}>Register as creator</button>
          </div>
       </form>

                <form onSubmit={handleSubmit} className="white">
                    <div className="input-field">
                        <label htmlFor="title">Title</label>
                        <input type="text" id="title" onChange={handleChange} 
                         placeholder={"Project's title"}
                        />
                    </div>
                    <div className="input-field">
                        <label htmlFor="description">Description</label>
                        <input type="text" id="description" onChange={handleChange} 
                         placeholder={"Brief Description"} />
                    </div>
                    <div className="input-field">
                        <label htmlFor="projectPitchURL">projectPitchURL</label>
                        <input type="text" id="projectPitchURL" onChange={handleChange}
                         placeholder={"Website"}/>
                    </div>
                    <div className="input-field-btn">
                        <button value="Submit" onClick={createProduct}>Create Product</button>
                    </div>
                </form>

                        <form onSubmit={handleSubmit}>
                            <div className="input-field">
                                <label htmlFor="amount">Amount</label>
                                <input type="number" id="amount" onChange={handleChange} 
                                 placeholder={"Amount to withdraw"}/>
                            </div> 
                            <div className="input-field-btn">
                                <button value="Submit" onClick={withdraw}>Withdraw Funds</button>
                            </div>
                        </form>

                        <form onSubmit={handleSubmit}>
                            <div className="input-field">
                                <label htmlFor="address">Address</label>
                                <input type="text" id="addressass" onChange={handleChange} 
                                placeholder={"Your registered creator's address"}/>
                            </div>

                            <div className="input-field">
                                <label htmlFor="tokenId">tokenId</label>
                                <input type="number" id="tokenId" onChange={handleChange}
                                placeholder={"tokenId"} />
                            </div>
                           
                            <div className="input-field-btn">
                                <button value="Submit" onClick={transferOwnerShip}>Transfer Ownership Rights</button>
                            </div>
                        </form>
                    </div>
 
      )
     }

export default ProductCreate