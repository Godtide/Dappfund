import React, { useState, useEffect } from 'react'
import { drizzleReactHooks } from "@drizzle/react-plugin"
//import Swal from 'sweetalert2'
const { useDrizzle, useDrizzleState } = drizzleReactHooks;

export default function ProductDetails(props) {
    
    const { drizzle } = useDrizzle();
    const state = useDrizzleState(state => state);
    const stateApp = {
        prodId: 0,
    };

    const [product, setProduct] = useState()
    const prodId = props.match.params.id - 1
    stateApp['prodId']  = parseInt(props.match.params.id -1);

    async function getProduct() {
        const newProduct = await drizzle.contracts.Dappfund.methods.getProduct(prodId).call();
        setProduct(newProduct);
    }

    useEffect( () => {       
        getProduct()
         }, []);
  /*
    const handleChange = (e,x) =>{
            stateApp[e.target.id] = e.target.value
        }   
    const handleSubmit = (e) => {
        e.preventDefault()
    }
    */
     
    return product? (
        <div className="container section product-details">
            <div className="card z-depth-0">
                <div className="card-content">
                    <span className="card-title">{product.title}</span>
                        <p>Description: {product.description}</p>
                        <p>projectPitchURL: {product.projectPitchURL}</p>
                        <p>balance: {product.balances}</p>
                        <p>fundingRequired: {product.fundingRequired}</p>
                        <p>isBlacklisted: {product.isBlacklisted}</p>
                         <p>activity: {product.activity}</p> 
                 </div>
              </div>


                    </div>
                   ): (
                        <div className="section">
                            <h5 className="section-header info-color white-text text-center py-4">
                                <strong>Loading...</strong>
                            </h5>
                        </div>
                      ); 
       }