pragma solidity >=0.4.21 <0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Mintable.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Burnable.sol";

contract Dappfund is ERC721Full, Ownable  {

/*
 * The Dappfund contract keeps track of the viable products developers build that are investible 
 * At the bottom of the contract you will find auxiliar functions upgraded and updated to work
 * properly with current comiler versions
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
    uint ProductsId;
    uint CreatorsId;
    uint16 InvestorsId;
    bool private stopped = false;

    enum Fund {fullyFunded, partiallyFunded, notFunded}
    // funding as received by creators
    enum Success {excellent, good, fair, bad}
    // Success rate after fullyfunded
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
        Success rate;
        State register;
        Active activity;
    }
  mapping(uint => Creator) CreatorId; // creator's identification

    struct Investor {
        //investor details
      address InvestorAddr;
        uint16 projectsDeployed;
        mapping(address => uint16) balances;
        uint valueInv;
        Active activity;
        State register;
    }
  mapping(uint => Investor) investorId; // investor's identifcation


    /*_____________________________
     * 2. Modifiers
     *_____________________________
     */

    modifier isPlatformOwner {
        require(msg.sender == platformOwner, 'Platform owner not verified');
        _;
    }

    modifier onlyInvestor(uint16 _id) {
        require(nvestorsId[_id].register == 1, "Not registered as an investor");
        _;
    }
    
    modifier onlyCreator(uinti6 _id) {
        require(creatorsId[_id].register == 0, "Not registered as an Inventor");
        _;
    }

    modifier whenAlive(uint16 _id) {
        require(investorId[_id].activity  || creatorsId[_id].activity == 0, "account not active;
        _;
    }
    /*_____________________________
     * 3. Event Logs
     *_____________________________
     */
      event LogForCreateProduct(address indexed msg.sender, uint16_tokenID);
      event LogForUnfreeze(bool stopped);
      event LogForFreeze(bool stopped);
      event LogForRegisterCreator(address indexed _creator);
      event LogForRegisterInvestor(address indexed _investor);
      event LogForFundProject(uint balance, uint amount, address indexed creatorAddr);
      event LogForTransferOwnership(address msg.sender, uint16 _tokenId, address _acct);
      event LogForWithdraw(msg.sender, msg.value);
     /*_____________________________
     * 4. Function definition
     *_____________________________
     */


    constructor() ERC721Full("Product", "PT") public {
          /* Set tide to the creator of this contract */
        platformOwner = msg.sender;
      // for circuit breaker pattern
       
    }
}
     /**
      * Circuit breaker pattern
      */
      function freeze() 
      public
      onlyPlatformOwner() 
      {
       stopped = true;  
       emit LogForFreeze(stopped);  
      }

      /**
      * Circuit breaker pattern
      */
      function unfreeze() 
      public
      onlyPlatformOwner() 
      {
       stopped = false;    
       emit LogForUnFreeze(stopped);
      }
     

     /***/


    function registerInvestor(address indexed _investor) {
        //The function allows an address to operate as an investor on the platform
        _id =0 ;
         investorAddr[id] = _Investor;
         InvestorsId[_id].register == 1;
        _id++;
         emit LogForRegisterInvestor( _investor);
    }

    function registerCreator(address indexed _creator) {
        //Registers an addr. as a creator 
        _id = 0;
        creatorsId[_id] = _Creator
        creatorsId[_id].register == 0; 
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
        string memory projectPitchURL,
        )
    public
    pure
    onlyCreator(_id)
    whenAlive
    {
        _id = 1;/*initializes the array index of the product in array productsId
        * _id is initialized to 1 to match the tokenID
        */
        productsId[_id].address = msg.sender;
        productsId[_id].id = _id; // synonmyous to TokenID OR IP;
        productsId[_id].title = _title;//string title;
        productsId[_id].description = _description;//string description;
        productsId[_id].projectPitchUrl = _ProjectPitchURL;
        products[_id][msg.sender].balances =0;
        // productIn is also equal to _id or index 
        uint256 _tokenId = _getProductId();
        _mint(msg.sender, _tokendId); 
        _id++;// INCREMENTS the id such that the next product is 2
        emit LogForCreateProduct(msg.sender,_tokenID);
    }


    function getProduct(uint16 _id)
        public
        view
        returns (
            uinti6 id,
            string memory title,
            string memory description,
            string memory location,
            string memory organization,
            uint fundingRequired;
            uint balances;
            bool isBlacklisted,
            Active activity
            )
    {
            products[_id].id;
            products[_id].title,
            products[_id].description,
            products[_id].isBlacklisted,
            products[_id].balances;
            products[_id].fundingRequired;
            products[_id].isBlacklisted
            productsId[_id].activity
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

      function fundProject(uint16 id, address indexed CreatorAddr)// checkout Pull payment
      public 
      payable
      pure
      onlyInvestor(_id) // how to set modifier in the react interphase
      whenAlive
       {   
           uint balance = 0;
           balance = investorsId[_id][msg.sender].balances;
           uint amount = msg.value;
           require(balance >= msg.value));
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

      function withdraw(msg.value;)
      payable
      pure
      onlyCreator[_id]
      {
          uint amount = msg.value;
          balances = productsId[_id][msg.sender].balances;
          require(productsId[_id].address == creatorsId[_id].address; "creator's address does match products");
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

    function Blacklist( _project's id
       )
       private
    isPlatformOwner
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

  function _transferOwnerShip(address _acct, _tokenId) {
      this.approve(_acct, _tokenId);
      this.transfer(msg.sender, _tokenId, _acct);
  }
  emit LogForTransferOwnership(msg.sender, _tokenId, _acct)
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
