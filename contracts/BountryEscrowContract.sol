pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract BountyEscrowContract {
    
    event EscrowStatus(string status);
    
    address _bountyOwner;
    address _bountyAvailedBy;
    bytes32 _bountyHash;
    uint _totalSecurityDeposit;
    address _owner;
    uint _arbitratorFees;
    uint _amountLocked;
    
    constructor(address bountyOwner, address bountyAvailedBy, bytes32 bountyHash, uint totalSecurityDeposit, address arbitrator, uint arbitratorFees) public payable {
        _bountyOwner = bountyOwner;
        _bountyAvailedBy = bountyAvailedBy;
        _bountyHash = bountyHash;
        _totalSecurityDeposit = totalSecurityDeposit;
        _owner = arbitrator;
        _arbitratorFees = arbitratorFees;
        _amountLocked = msg.value;
    }
    
    
    function completeEscrow() external payable{
        
    }
    
    //sends all security deposit to the users
    function resetEscrow() external payable{
        
    }
    
    //sends all security deposit to owner of main contract on failure of proposed task
    function failEscrow() external payable {
        
    }
    
    
    
    
}