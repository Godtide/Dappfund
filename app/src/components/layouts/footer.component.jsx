import React from 'react'
import idea from '../../assets/idea.svg'

const Footer = () => {
    return (
        <footer className="page-footer">
            <div className="container">
                <div className="row">
                    <div className="col l6 s12">
                        <h5 className="white-text"><img src={idea} alt="idea" style={{ width: "10%"}} /></h5>
                        <p className="white">Dappfund, Truffle University.</p>
                    </div>
                    <div className="col l4 offset-l2 s12">
                        <h5 className="white-text">Links</h5>
                        <ul>
                            <li><a className="amber-text text-lighten-3" href="https://github.com/godtide/dappfund">Github</a></li>
                           <li> <blockquote className="twitter-tweet">
                           <a href="https://twitter.com/web3deve/status/1197458414374412289?ref_src=twsrc%5Etfw">twitter</a></blockquote> 
                            <script async src="https://platform.twitter.com/widgets.js" charSet="utf-8"></script>
                    </li>
                           </ul>
                          </div>
                </div>
            </div>
            <div className="footer-copyright">
                <div className="container">
                © {(new Date().getFullYear())} Developed by Tide Ayoade
                </div>
            </div>
        </footer>
    )
}

export default Footer;
