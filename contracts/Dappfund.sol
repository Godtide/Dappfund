pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Mintable.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract Dappfund is ERC721Full, Ownable  {

/*
 * The DappFund contract keeps track of the viable products developers build on ethereum that are investible 
 * At the bottom of the contract you will find auxiliar functions upgraded and updated to work
 * properly with current compiler versions
 *
 * The original functions were published by
 * @author Tide Ayoade <ayoadebabatide@gmail.com>
*/


    /*_____________________________
     * 1. Variable Definitions
     *_____________________________
     */

    // Platform account address
    address public platformOwner; // ENS name can be set
    uint pid;
    uint16 cid;
    uint16 iid;
    bool private stopped = false;
    bool public register = false;

    //enum Fund {fullyFunded, partiallyFunded, notFunded}
    // funding as received by creators
    enum Active {Active, Inactive, Dormant}
    //state of investor before removal from the platform
    enum State {  Creator, Investor}


    struct Product {
        //product details
        address creator;
        uint pid ;// TokenID OR IP or index position of product in ProductsId;
        string title;
        string description;
        string projectPitchURL;
        //uint fundingRequired;
        mapping(address => uint) balances;
        Active activity;
        string organization;
        bool isBlacklisted;
     }

    mapping(uint => Product) productId;
    //products identification
    
    struct Creator { //creators details
       address creatorAddr;
        mapping(address => uint)balances;
        bool register;
        Active activity;
        State state;
    }
  mapping(uint => Creator) creatorId; // creator's identification

    struct Investor {
        //investor details
      address investorAddr;
        mapping(address => uint16) balances;
        uint valueInv;
        Active activity;
        bool register;
        State state;
    }
  mapping(uint => Investor) investorId; // investor's identifcation


    /*_____________________________
     * 2. Modifiers
     *_____________________________
     */

    modifier isPlatformOwner() {
        require(msg.sender == platformOwner, 'Platform owner not verified');
        _;
    }

    modifier onlyInvestor() {
        require(investorId[iid].state == State.Investor, "Not registered as an investor");
        _;
    }
    
    
    modifier onlyCreator() {
        require(creatorId[cid].state == State.Creator, "Not registered as an Inventor");
        _;
    }

    modifier whenAlive() {
        require(creatorId[cid].activity == Active.Active, "account not active");
        _;
    }
    /*_____________________________
     * 3. Event Logs
     *_____________________________
     */

      event LogForFreeze(bool stopped); 
      event LogForUnfreeze(bool stopped);
      event LogForRegisterInvestor(address indexed _investor);
      event LogForRegisterCreator(address indexed _creator);
      event LogForCreateProduct(address indexed creatorAddr, uint _tokenID);
      event LogForFundProject(uint balances, uint amount);
      event LogForTransferOwnership(address indexed creatorAddr, address indexed _acct, uint _tokenId);
      event LogForWithdraw(address indexed creatorAddr, uint amount);
     /*_____________________________
     * 4. Function definition
     *_____________________________
     */


    constructor () 
    ERC721Full("Product", "PT")
    public
      {
          /* Set tide to the creator of this contract */
        platformOwner = msg.sender;
      // for circuit breaker pattern
       
    }

     /**
      * Circuit breaker pattern
      */
      function freeze() 
      private
      isPlatformOwner() 
      {
       stopped = true;  
       emit LogForFreeze(stopped);  
      }

      /**
      * Circuit breaker pattern
      */
      function unfreeze() 
      private
      isPlatformOwner() 
      {
       stopped = false;    
       emit LogForUnfreeze(stopped);
      }
     

     /***/


    function registerInvestor(address _investor) 
    public
    {
        //The function allows an address to operate as an investor on the platform
        iid = 0 ;
        //require(register ==false); to prevent reg as a investor and creator
         investorId[iid].investorAddr = _investor;
         investorId[iid].register = true;
         investorId[iid].state = State.Investor;
        iid++;
       // register == true;
         emit LogForRegisterInvestor(msg.sender);
    }

    function registerCreator(address _creator)
    public
     {
        //Registers an addr. as a creator 
       // require(register == false);
        cid = 0;
        creatorId[cid].creatorAddr = _creator;
        creatorId[cid].register = true; 
        creatorId[cid].state = State.Creator;
        cid++;
       // register == true; global variable to prevent repeated reg
        emit LogForRegisterCreator(msg.sender);
    }
    
    
       /* @dev function creat product allows any registered creator 
       *to add their product to the platform
       *create Product call the _minter function from ERC721, every product is a non-fungible token
       * The TokenId can be sold as IP
       * at any price desirable by the owner
        */
        

    function getProduct(uint _pid)
        public
        view
       returns (
            uint pid,
            string memory title,
            string memory description,
            string memory projectPitchURL,
            uint balances,
            bool isBlacklisted,
            Active activity )
    {
            productId[_pid].pid;
            productId[_pid].title;
            productId[_pid].description;
            productId[_pid].projectPitchURL;
            productId[_pid].balances;
          //  productId[_pid].fundingRequired;
            productId[_pid].isBlacklisted;
            productId[_pid].activity;
    }

    function createProduct( 
        string memory _title,
        string memory _description,
        string memory _projectPitchURL)
    public
    onlyCreator()
    whenAlive
    {
        pid = 0; 
        productId[pid].creator = msg.sender;
        productId[pid].pid = pid; // synonmyous to TokenID OR IP;
        productId[pid].title = _title;//string title;
        productId[pid].description = _description;//string description;
        productId[pid].projectPitchURL = _projectPitchURL;
        productId[pid].balances[msg.sender] = 0;
        uint _tokenId = _getProductId();
        _mint(msg.sender, _tokenId); 
        pid++;
        emit LogForCreateProduct(msg.sender,_tokenId);
    }



    //check out pull payment method using balance
    /* @ dev
    *function FundProject
    *Allows an investor(using Id) to fund the project they are interested in using the projectId,
    *The function receives ether
    * Removes amount from investorbalance into the Project's balance
    *requires investorbalance >= msg.value;
    *It can only be called by a registered investor
    *It only be called when the investor or project is active
    *emit an event
    */

      function fundProject(uint16 _pid, address _creatorAddr)// checkout Pull payment
      public 
      payable
      onlyInvestor() 
       {   
           uint balanceOf;
           balanceOf = investorId[iid].balances[msg.sender];
           uint amount = msg.value;
           require(balanceOf >= msg.value);
           //checkout pull payment
           balanceOf -= amount;
           productId[_pid].balances[_creatorAddr] += amount;
           emit LogForFundProject(balanceOf, msg.value);

      }

      /*@ dev
      *function withdraw, called by only a creator;
      *payable function
      *require msg.sender is the created the product
      *requires that msg.value <= balances
      */

      function withdraw()
      public
      payable
      onlyCreator()
      {
          uint amount = msg.value;
          uint balanceOf = productId[pid].balances[msg.sender];
          require(productId[pid].creator == creatorId[cid].creatorAddr, "creator's address does match products");
          require(balanceOf >= amount);
           balanceOf -= amount;
           msg.sender.transfer(amount);
           emit LogForWithdraw(msg.sender, msg.value);

      }

      

      //
      /*@dev
      *This Function BLACLKIST can only be called by platOwner or admin
      *This blacklist scams or inactive project using Project's Id
      *emits an event
      */

    function Blacklist( uint _pid)
       private
    isPlatformOwner()
    {   productId[_pid].isBlacklisted == true;
        productId[_pid].activity == Active.Dormant;
        
         }


  /**
   * @dev calculates the next token ID based on totalSupply
   * @return uint256 for the next token ID
   */
  function _getProductId() 
  public 
  view 
  returns (uint256) {
    return totalSupply().add(1); 
  }

  /*@dev transfer ownwership of IP
  * CALLS super.transfer
  *calls super.approve
  */
  

  function transferOwnerShip(address _acct, uint _tokenId)
  //tokenId is made synonmyous to the _productsID(_pid)
  public
  //should be payable in the future
  onlyCreator
   {
      super.approve(_acct, _tokenId);
      super.transferFrom(msg.sender, _acct, _tokenId);
      super.transferOwnership(_acct);

    emit LogForTransferOwnership(msg.sender, _acct, _tokenId);
  }

     /* external payable revert function\
     *exception handler
      *reverts when a function not available is called
      *payable
      */
      function ()
      external
      payable
      {}

    }
