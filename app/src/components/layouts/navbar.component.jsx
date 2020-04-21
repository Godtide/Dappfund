import React from 'react'
import { NavLink } from 'react-router-dom'
import idea from '../../assets/idea.svg'

const Navbar = () => {
    return (
        <nav className="navbar drizzle-navbar navbar-expand-lg navbar-light">
            <a className="navbar-brand" href="/"><img src={idea} alt="DappFund" style={{height: '50px'}} /></a>
                <button className="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span className="navbar-toggler-icon"></span>
                </button>

                <div className="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul className="navbar-nav mr-auto">
                    <li className="nav-item active">
                            <NavLink className="nav-link" to="/">Invest</NavLink>
                        </li>
                        <li className="nav-item">
                            <NavLink className="nav-link" to="/create">create Product</NavLink>
                        </li>
                    </ul>
                </div>
            </nav>
    )
}

export default Navbar;





