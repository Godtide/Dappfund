import React, { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { drizzleReactHooks } from "@drizzle/react-plugin"
import Swal from 'sweetalert2'

const { useDrizzle } = drizzleReactHooks;

export default function Investors() {
    
    const { drizzle } = useDrizzle();
    const state = useDrizzle(state => state);

    const [products, setProducts] = useState([]);


    //  Better still to get product
     const checkProduct = async () => {   
       const newProd = await drizzle.contracts.Dappfund.methods.productsId(
            //registration will be payable in the future
            stateApp['int'] ).call();
            setProducts(newProd)

        }

    async function getProduct() {
        const newProduct = await drizzle.contracts.Dappfund.methods.getProduct(0).call();
        setProducts({
            pid: newProduct[0],
            title: newProduct[1],
            description: newProduct[2],
            projectPitchURL: newProduct[3],
            balances: newProduct[4],
            isBlacklisted: newProduct[5].toString(),
            activity: newProduct[6]
        })
 
     console.log(products);
    }
    
    useEffect( () => {
        getProduct()
      }, []);

      const stateApp = {};

      const handleChange = (e, x) =>  {
            stateApp[e.target.id] = e.target.value;
        }   

    const handleSubmit = (e) => {
          e.preventDefault();
      }
      
    const registerInvestor = async () => {   
        const investor = await drizzle.contracts.Dappfund.methods.registerInvestor(
            //registration will be payable in the future
            stateApp['address']
            ).send({from: state.accounts})


    if(investor.status) {
        Swal.fire({
            title: "Yeah!",
            text: 'Hello Investor!',
            type: "success"
        });
    } else {
        Swal.fire({
            title: "Opps!",
            text: 'Error completing your registration!',
            type: "error"
        });
    }
}

    const fund = async () => {   
        const draw = await drizzle.contracts.Dappfund.methods.fundProject(
            stateApp['pid'],
            stateApp['address'],
            ).send({from: state.accounts,
             value: drizzle.web3.utils.toWei(stateApp['amount'], 'ether')})
        
        if(draw.status) {
            Swal.fire({
                title: "Yeah!",
                text: ' Fund sent!',
                type: "success"
            });
        } else {
            Swal.fire({
                title: "Opps!",
                text: 'Error sending funds!',
                type: "error"
            });
        }
    }
    return products ? (
        <div className="dashboard container">
            <div className="row">
                <div className="col s12 m12">
                    <div className="product-list section">
                        {products.map(product => (
                           <div key={product.pid} className="card project-summary">
                                <div key={product.pid} className="card-content grey-text text-darken-3">
                                    <span className="card-title"><Link to={`/product/${product.pid}`} >Title: {product.title}</Link></span>
                                    <p>Description: {product.description}</p>
                                    <p>projectPitchURL: {product.projectPitchURL}</p>
                                     <p>balances: {product.balances}</p>
                                    <p>isBlacklisted: {product.isBlacklisted}</p>
                                    <p>activity: {product.activity}</p> </div>
                            </div>
                        ))}
                    </div>
                </div>
            </div>

            <form onSubmit={handleSubmit} className="white">
          <div className="input-field">
             <label htmlFor="address">Address</label>
             <input type="number" id="int" onChange={handleChange}
             placeholder={"Index no of product"} />
          </div>
          <div className="input-field-btn">
             <button value="Submit" onClick={checkProduct} 
             className="white">product details</button>
          </div>
       </form>

            <form onSubmit={handleSubmit} className="white">
          <div className="input-field">
             <label htmlFor="address">Address</label>
             <input type="text" id="address" onChange={handleChange}
             placeholder={"Your address goes here"} />
          </div>
          <div className="input-field-btn">
             <button value="Submit" onClick={registerInvestor} 
             className="white">Register as Investor</button>
          </div>
       </form>



       <form onSubmit={handleSubmit} className="white">
             <div className="input-field">
             <label htmlFor="pid">Product Id</label>
                  <input type="number" id="pid" onChange={handleChange} 
                   placeholder={"Product Number"}/>
             </div>
             <div className="input-field">
             <label htmlFor="address">Address</label>
                  <input type="text" id="address" onChange={handleChange}
                   placeholder={"Fund Creator's address"} />
             </div>
             <div className="input-field">
             <label htmlFor="amount">Amount</label>
                  <input type="number" id="amount" onChange={handleChange}
                   placeholder={"Amount"} />
             </div>
             <div className="input-field-btn">
                  <button value="Submit" onClick={fund} 
                className="white">Fund Project</button>
             </div>
       </form>
           </div>

    ) : (
        <div>Loading...</div>
    );
}