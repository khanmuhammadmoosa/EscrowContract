pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

import "./BountyEscrowContract.sol";


contract BountyMainContract {
    
    event BountyPlaced(address bountyOwner, bytes32 bountyHash);
    
    address payable _owner;
    uint _fixedSecurityDeposit = 0.1 ether;
    BountyEscrowContract _bountyEscrowContract;
    
    modifier onlyOwner {
        require(msg.sender == _owner);
        _;
    }
    
    modifier isBountyOwner() {
        BountyOwners memory _bountyOwnerStored = _bountyOwnerDetails[msg.sender];
        
        require(_bountyOwnerStored.valid,"Bounty owner does not exist");
        _;
    }
    
    
    address[] _arbitrators;
    bytes32[] _bounties;
    
    mapping (address => mapping(bytes32=> Bounty)) _bountiesByOwnerAddress;
    mapping (address => BountyOwners) _bountyOwnerDetails;
    mapping (bytes32 => Bounty) _bountiesDetailsById;
    mapping (bytes32 => address) public escrowAddressWithRespectToBountyHash;
    
    struct BountyOwners {
        string name;
        string detailsUrl;
        uint upvote;
        uint downvote;
        bool valid;
    }
    
    struct Bounty{
        string name;
        string detailsUrl;
        bool isAvailed;
        address isAvailedBy;
        uint price;
    }
    
    constructor() public {
        _owner = msg.sender;
    }
    
    
    function addBountyOwner(string calldata _name, string calldata _detailsUrl) external {
        BountyOwners memory _bountyOwner;
        _bountyOwner.name = _name;
        _bountyOwner.detailsUrl = _detailsUrl;
        _bountyOwner.upvote = 0;
        _bountyOwner.downvote = 0;
        _bountyOwner.valid = true;
        
        _bountyOwnerDetails[msg.sender] = _bountyOwner;
        
    }
    
    
    function addBounty(string calldata _name, string calldata _detailsUrl) external payable isBountyOwner returns (bytes32){
        
        require(msg.value == _fixedSecurityDeposit,"Security Deposit must be made first");
        
        bytes32 _bountyId = keccak256(abi.encodePacked(_name,_detailsUrl));
      
        Bounty storage currentBounties = _bountiesByOwnerAddress[msg.sender][_bountyId];
        
        currentBounties.name = _name;
        currentBounties.detailsUrl = _detailsUrl;
        
        _bountiesDetailsById[_bountyId] = currentBounties;
        
        _bounties.push(_bountyId);
        return _bountyId;
        
    }
    
    function getAllBounties () public view returns (bytes32 [] memory) {
        return _bounties;
    }
    
    function getBountyById (bytes32 _bountyId) external view returns (string memory name, string memory detailsUrl){
        Bounty memory _bounty = _bountiesDetailsById[_bountyId];
        return (_bounty.name, _bounty.detailsUrl);
    }
    
    
    function addArbitrator(address _arbitratorAddress) external onlyOwner {
        _arbitrators.push(_arbitratorAddress);
    }
    
    function availBounty(bytes32 _bountyId) external payable returns(bool){
       Bounty storage _bountyToAvail = _bountiesDetailsById[_bountyId];
       require(_bountyToAvail.isAvailed == false,"Bounty already availed or doesn't exist");
       require(_fixedSecurityDeposit == msg.value);
       
       uint _arbitratorFee = 0.01 ether;
       
       _bountyEscrowContract = (new BountyEscrowContract).value(msg.value)(address(0),msg.sender,_bountyId,_fixedSecurityDeposit * 2,address(0),_arbitratorFee);
       escrowAddressWithRespectToBountyHash[_bountyId] = msg.sender;
       
        //To be continued
    }
    
    function getBountyValue() external view returns(uint){
        return address(this).balance;
    }
    
}