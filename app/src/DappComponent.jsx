import React from "react";

import { Switch, Route, BrowserRouter as Router} from 'react-router-dom';



import Investors from './components/dashboard/investor.component';
import Navbar from "./components/layouts/navbar.component";
import Footer from "./components/layouts/footer.component";
import ProductDetails from "./components/pages/productDetails.component";
import ProductCreate from "./components/pages/creator.component";

const DappComponent = () => {
  return (
    <Router>
      <div className="App">
        <Navbar />
        <Switch>
           <Route exact path='/' component={Investors}/>
          <Route path='product/:pid' render={(props) => <ProductDetails {...props}/>} />
          <Route path='/create' component={ProductCreate}/>
        </Switch>
        <hr/>
       <Footer />
      </div>
    </Router>
  )
}

export default DappComponent;
