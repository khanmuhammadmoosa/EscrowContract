pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;


contract BountyMainContract {
    
    address payable _owner;
    
    modifier onlyOwner {
        require(msg.sender == _owner);
        _;
    }
    
    modifier isBountyOwner(string memory _name, string memory detailsUrl) {
        BountyOwners memory _bountyOwnerStored = _bountyOwnerDetails[msg.sender];
        
        require(keccak256(abi.encodePacked(_bountyOwnerStored.name)) == keccak256(abi.encodePacked(_name)),"Name not correct");
        _;
    }
    
    
    address[] _arbitrators;
    bytes32[] _bounties;
    
    mapping (address => mapping(bytes32=> Bounty)) _bountiesByOwnerAddress;
    mapping (address => BountyOwners) _bountyOwnerDetails;
    mapping (bytes32 => Bounty) _bountiesDetailsById;
    
    struct BountyOwners {
        string name;
        string detailsUrl;
        uint upvote;
        uint downvote;
        
    }
    
    struct Bounty{
        string name;
        string detailsUrl;
        bool isAvailed;
        address isAvailedBy;
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
        
        _bountyOwnerDetails[msg.sender] = _bountyOwner;
        
    }
    
    
    function addBounty(string calldata _name, string calldata _detailsUrl) external returns (bytes32){
        bytes32 _bountyId = keccak256(abi.encodePacked(_name,_detailsUrl));
        
      
        Bounty storage currentBounties = _bountiesByOwnerAddress[msg.sender][_bountyId];
        
        currentBounties.name = _name;
        currentBounties.detailsUrl = _detailsUrl;
        
        //
        
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
        //To be continued
    }
    
}