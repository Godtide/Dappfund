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
    address public tide; // ENS name can be set
    uint ProductsId;
    uint CreatorsId;

    enum Fund {fullyFunded, partiallyFunded, notFunded}
    // funding as received by creators
    enum Success {excellent, good, fair, bad}
    // Success rate after fullyfunded
    enum Active {active, inactive, dormant}
    //state of investor before removal from the platform
    enum State {creator, investor}


    struct Product {
        //product details
        uint id;
        string title;
        string description;
        string ProjectPitchURL;
        uint amountRequired;
        uint amountReceived;
        string organization;
        uint startDate;
        uint endDate;
    }

    mapping(uint => Product) ProductId;
    //products identification
    
    struct Creator { //creators details
    mapping(uint => address) CreatorAddr;
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
     mapping(uint => address) InvestorAddr;
        bool investor;
        uint16 projectsDeployed;
        uint valueInv;
        Active activity;
        State register;
    }
  mapping(uint => Investor) InvestorId; // investor's identifcation

    struct Action {
        //uses ProductId to verify actions, can only be called by admin
       
    }




contract Dappfund is ERC721Full, ERC721Mintable,Ownable,ERC721Burnable  {
    constructor() ERC721Full("Product", "PT") public {
          /* Set tide to the creator of this contract */
        tide = msg.sender;
      // for circuit breaker pattern
       bool private stopped = false;
    }
}

    /*_____________________________
     * 2. Modifiers
     *_____________________________
     */

    modifier isPlatformOwner {
        require(msg.sender == platformOwner, 'Platform owner not verified');
        _;
    }

    modifier onlyInvestor(uint16 _id) {
        require(InvestorsId[_id].register == 1, "Not registered as an investor");
        _;
    }
    
    modifier onlyCreator(uinti6 _id) {
        require(CreatorsId[_id].register == 0, "Not registered as an Inventor");
        _;
    }

    modifier whenAlive(uint16 _id) {
        require(productsId[_id].activity  || creatorsId[_id].activity == 0, "account not active;
        _;
    }
    /*_____________________________
     * 3. Event Logs
     *_____________________________
     */

     /*_____________________________
     * 4. Function definition
     *_____________________________
     */



     /**
      * Circuit breaker pattern
      */
      function freeze() 
      public
      onlyOwner() 
      {
       stopped = true;    
      }

      /**
      * Circuit breaker pattern
      */
      function unfreeze() 
      public
      onlyOwner() 
      {
       stopped = false;    
      }

     /***/


    Function registerInvestor(address indexed _Investor) {
        //The function allows an address to operate as an investor on the platform
        State register == 1;
        InvestorsId++;
    }

    function registerCreator(address indexed _Creator) {
        //Registers an addr. as a creator 
        State register == 0; 
        CreatorsId++;
    }


    function getProduct(uint productsId)
        public
        view
        returns (
            uint id,
            string memory title,
            string memory description,
            string memory location,
            string memory organization,
            uint startDate,
            uint endDate)
    {}

    function createProduct(
        string memory title,
        string memory description,
        string memory location,
        string memory organization,
        uint startDate,
        uint endDate)
    public
    whenRunning
    whenAlive
    {
        
    }

    function getActionIdsByOpportunity(uint opportunityId)
        public
        view
        returns (string memory )
    {
            }
        }
    }

    function getAction(
        string memory actionId)
    public
    view
    whenRunning
    whenAlive
        returns (
          )
    {
       
            }
        }
    }

    function createAction(
       )
    public
    whenRunning
    whenAlive
    {
    }