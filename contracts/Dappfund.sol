pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Mintable.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract Dappfund is ERC721Full, ERC721Mintable, Ownable  {

/*
 * The Dappfund contract keeps track of the viable products developers build on ethereum that are investible 
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
    uint ProductId;
    uint16 CreatorId;
    uint16 InvestorId;
    bool private stopped = false;
    bool register = false;

    enum Fund {fullyFunded, partiallyFunded, notFunded}
    // funding as received by creators
    enum Active {active, inactive, dormant}
    //state of investor before removal from the platform
    enum State {creator, investor}


    struct Product {
        //product details
        address creator;
        uint id ;// TokenID OR IP or index position of product in ProductsId;
        string title;
        string description;
        string ProjectPitchURL;
        uint fundingRequired;
        mapping(address => uint) balances;
        string organization;
        bool isBlacklisted;
     }

    mapping(uint => Product) ProductId;
    //products identification
    
    struct Creator { //creators details
       address CreatorAddr;
        mapping(address => uint)balances;
        bool register;
        Active activity;
        State state;
    }
  mapping(uint => Creator) CreatorId; // creator's identification

    struct Investor {
        //investor details
      address InvestorAddr;
        uint16 projectsDeployed;
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
        require(state == 1, "Not registered as an investor");
        _;
    }
    
    modifier onlyCreator() {
        require(state == 0, "Not registered as an Inventor");
        _;
    }

    modifier whenAlive() {
        require(investorId[_id].activity  || creatorsId[_id].activity == 2, "account not active");
        _;
    }
    /*_____________________________
     * 3. Event Logs
     *_____________________________
     */
      event LogForCreateProduct(address indexed creatorAddr, uint16 _tokenID);
      event LogForUnfreeze(bool stopped);
      event LogForFreeze(bool stopped);
      event LogForRegisterCreator(address indexed _creator);
      event LogForRegisterInvestor(address indexed _investor);
      event LogForFundProject(uint balance, uint amount, address indexed creatorAddr);
      event LogForTransferOwnership(address creatorAddr, uint16 _tokenId, address _acct);
      event LogForWithdraw(address indexed creatorAddr, uint amount);
     /*_____________________________
     * 4. Function definition
     *_____________________________
     */


    constructor ()
    ERC721Full("Product", "PT")
     public {
          /* Set tide to the creator of this contract */
        platformOwner = msg.sender;
      // for circuit breaker pattern
       
    }

     /**
      * Circuit breaker pattern
      */
      function freeze() 
      public
      isPlatformOwner() 
      {
       stopped = true;  
       emit LogForFreeze(stopped);  
      }

      /**
      * Circuit breaker pattern
      */
      function unfreeze() 
      public
      isPlatformOwner() 
      {
       stopped = false;    
       emit LogForUnFreeze(stopped);
      }
     

     /***/


    function registerInvestor(address _investor) 
    public
    isPlatformOwner()
    {
        //The function allows an address to operate as an investor on the platform
        _id = 0 ;
         investorsId[_id].InvestorAddr = _Investor;
         InvestorsId[_id].register == 1;
         state == 1;
        _id++;
         emit LogForRegisterInvestor( _investor);
    }

    function registerCreator(address _creator)
    private
    isPlatformOwner
     {
        //Registers an addr. as a creator 
        _id = 0;
        creatorsId[_id] = _Creator;
        creatorsId[_id].register == 0; 
        state == 0;
        _id++;
        emit LogForRegisterCreator( _creator);
    }
    
    
       /* @dev function creat product allows any registered creator 
       *to add their product to the platform
       *create Product call the _minter function from ERC721, every product is a non-fungible token
       * The TokenId can be sold as IP
       * at any price desirable by the owner
        */

    function createProduct( 
        string memory _title,
        string memory description,
        string memory projectPitchURL
        )
    public
    pure
    onlyCreator()
    whenAlive
    {
        _id = 1;/*initializes the array index of the product in array productsId
        * _id is initialized to 1 to match the tokenID
        */
        productsId[_id].creator = msg.sender;
        productsId[_id].id = _id; // synonmyous to TokenID OR IP;
        productsId[_id].title = _title;//string title;
        productsId[_id].description = _description;//string description;
        productsId[_id].projectPitchUrl = _ProjectPitchURL;
        products[_id][msg.sender].balances =0;
        // productIn is also equal to _id or index 
        uint16 _tokenId = _getProductId();
        _mint(msg.sender, _tokendId); 
        _id++;// INCREMENTS the id such that the next product is 2
        emit LogForCreateProduct(msg.sender,_tokenID);
    }


    function getProduct(uint16 _id)
        public
        view
        returns (
            uint16 id,
            string memory title,
            string memory description,
            string memory location,
            string memory organization,
            uint fundingRequired,
            uint balances,
            bool isBlacklisted,
            Active activity
            )
    {
            products[_id].id;
            products[_id].title;
            products[_id].description;
            products[_id].isBlacklisted;
            products[_id].balances;
            products[_id].fundingRequired;
            products[_id].isBlacklisted;
            productsId[_id].activity;
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

      function fundProject(uint16 id, address CreatorAddr)// checkout Pull payment
      public 
      payable
      onlyInvestor() // how to set modifier in the react interphase
      whenAlive
       {   
           uint balance = 0;
           balance = investorsId[_id][msg.sender].balances;
           uint amount = msg.value;
           require(balance >= msg.value);
           //checkout pull payment
           balance -= amount;
           productId[_id][creatorAddr].balances += amount;
           emit LogForFundProject(balance, amount, creatorAddr);

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
          balances = productsId[_id][msg.sender].balances;
          require(productsId[_id].creator == creatorsId[_id].creatorAddr, "creator's address does match products");
          require(balances >= amount);
           balances -= amount;
           msg.sender.transfer(amount);
           emit LogForWithdraw(msg.sender, msg.value);

      }

      

      //
      /*@dev
      *This Function BLACLKIST can only be called by platOwner or admin
      *This blacklist scams or inactive project using Project's Id
      *emits an event
      */

    function Blacklist( uint _id)
       private
    isPlatformOwner()
    {   productsId[_id].isBlacklisted == true;
        productsId[_id].activity == 2;
    }



  /**
   * @dev calculates the next token ID based on totalSupply
   * @return uint256 for the next token ID
   */
  function _getProductId() private view returns (uint256) {
    return totalSupply().add(1); 
  }

  /*@dev transfer ownwership of IP
  * CALLS super.transfer
  *calls super.approve
  */

  function transferOwnerShip(address _acct, uint16 _tokenId)
  public
  onlyCreator
   {
      this.approve(_acct, _tokenId);
      this.transfer(msg.sender, _tokenId, _acct);
      this._transferOwnership(_acct);

    emit LogForTransferOwnership(msg.sender, _tokenId, _acct);
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