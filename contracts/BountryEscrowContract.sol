pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract BountyEscrowContract {
    
    modifier isBountyOwner(){
        require(_bountyOwner == msg.sender);
        _;
    }
    
    modifier isBountyTaker(){
        require(_bountyAvailedBy == msg.sender);
        _;
    }
    
    modifier isArbitrator(){
        require(_owner == msg.sender);
        _;
    }
    
    event EscrowStatus(string status);
    
    address payable _bountyOwner;
    address payable _bountyAvailedBy;
    bytes32 _bountyHash;
    uint _totalSecurityDeposit;
    address _owner;
    uint _bountyPrice;
    uint _arbitratorFees;
    bool _hasBountyOwnerSubmittedPrice = false;
    uint _securityDeposit = 0.1 ether;
    bool _locked = false;
    
    constructor(address payable bountyOwner, address payable bountyAvailedBy, bytes32 bountyHash, uint bountyPrice, address arbitrator, uint arbitratorFees) public payable {
        _bountyOwner = bountyOwner;
        _bountyAvailedBy = bountyAvailedBy;
        _bountyHash = bountyHash;
        _totalSecurityDeposit = msg.value;
        _owner = arbitrator;
        _bountyPrice = bountyPrice;
        _arbitratorFees = arbitratorFees;
    }
    
    
    function raiseDispute() external payable {
        
    }
    
    function verifyBountyCompletionByOwner() external isBountyOwner payable returns(bool) {
        require(_bountyPrice == msg.value);
         _hasBountyOwnerSubmittedPrice = true;
         
         return _hasBountyOwnerSubmittedPrice;
    }
    
    
    function completeEscrow() external isBountyTaker payable{
        
        require(_hasBountyOwnerSubmittedPrice);
        
        lock();
        msg.sender.transfer(_bountyPrice);
        msg.sender.transfer(_securityDeposit);
        _bountyOwner.transfer(_securityDeposit);
        unlock();
        
        
        
        
    }
    

    
    function checkAmountStoredInEscrow() external view returns (uint){
        return address(this).balance;
    }
    
    
    function lock() internal {
        
        if(!_locked){
            _locked = true;
        }else{
            revert("Transaction is locked, reenterency not possible");
        }
        
    }
    
    function unlock() internal  {
        
        _locked = true;
        
    }
    
    
}
