pragma solidity >=0.4.21 <0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721Mintable.sol";
import "/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "/openzeppelin-solidity/contracts/token/ERC721/ERC721Burnable.sol";

/*
 * The Dappfund contract keeps track of the viable products developers build that are investible and let them get
 and their actions after investments (i.e. grant, scholarship, trip, etc).
 *
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

    enum Fund {fullyFunded, partiallyFunded, notFunded}
    // funding as received by creators
    enum Success {excellent, good, fair, bad}
    // Success rate after fullyfunded
    enum Active {active, inactive, dormant}
    //state of investor before removal from the platform
    enum State {creator, investor}


    struct Product {
        //product details
        address creator
        uint id ;// TokenID OR IP or index position of product in ProductsId;
        string title;
        string description;
        string ProjectPitchURL;
        uint fundingRequired;
        mapping(address => uint) balances;
        string organization;
        bool isBlacklisted;
        )

    }

    mapping(uint => Product) ProductId;
    //products identification
    
    struct Creator { //creators details
       address CreatorAddr;
        uint16 projectsDeployed;
        uint valueReceived;
        Success rate;
        Funding raised;
        State register;
        Active activity;
    }
  mapping(uint => Creator) CreatorId; // creator's identification

    struct Investor {
        //investor details
      address InvestorAddr;
        uint16 projectsDeployed;
        mapping(address => uint16) balances
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
      event LogForCreateProduct(msg.sender,_tokenID);
      event LogForRegisterCreator( _creator);
      event LogForRegisterInvestor( _investor)





     /*_____________________________
     * 4. Function definition
     *_____________________________
     */

    contract Dappfund is ERC721Full, ERC721Mintable,Ownable,ERC721Burnable  {


    constructor() ERC721Full("Product", "PT") public {
          /* Set tide to the creator of this contract */
        tide = msg.sender;
      // for circuit breaker pattern
       bool private stopped = false;
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
      }

      /**
      * Circuit breaker pattern
      */
      function unfreeze() 
      public
      onlyPlatformOwner() 
      {
       stopped = false;    
      }

     /***/


    Function registerInvestor(address indexed _investor) {
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
            )
    {
            products[_id].id;
            products[_id].title,
            products[_id].description,
            products[_id].isBlacklisted,
            products[_id].balances;
            products[_id].fundingRequired;
            products[_id].isBlacklisted
    }


    //check out pull payment method using balance
    /* @ dev
    *function FundProject
    *Allows an investor(using Id) to fund the project they are interested in using the projectId,
    *The function receives ether
    * Removes amount from investorbalance into the Project's balance
    *It can only be called by a registered investor
    *It only be called when the investor or project is active
    *emit an event
    */

      function fundProject(uint16 id, address indexed CreatorAddr)
      public 
      payable
      onlyInvestor()
      whenAlive
       { 
           uint amount = msg.value;

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
    {
        isBlacklisted == true;
    }



  /**
   * @dev calculates the next token ID based on totalSupply
   * @return uint256 for the next token ID
   */
  function _getProductId() private view returns (uint256) {
    return totalSupply().add(1); 
  }



        }
    }
