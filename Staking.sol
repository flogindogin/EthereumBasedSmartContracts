pragma solidity >=0.7.0 <0.9.0;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";



contract PPP is ERC20 { //This function mints a test PPP token.
   constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol){
       _mint(msg.sender, 1000000 * 10 ** 18);

   }
}


interface Lenders{      //Interact allows to communicate with other fucntions in different files.
    function getLenderArrayIndex() external returns(uint); //use this to merge with functions in lenders contract
}



contract StakingRewards {
    struct Investment {
        address payable investor;
        uint256 amount;
        uint256 lastPayout;
        uint256 payout;
    }

    mapping(address => Investment) public investments;
    address payable[] public investors;

    function invest(address payable _investor, uint256 _amount) public {
        investments[_investor].investor = _investor;
        investments[_investor].amount = _amount;
        investments[_investor].lastPayout = block.timestamp;
        investors.push(_investor);
    }

    function calculatePayout(uint256 _amount) internal view returns (uint256) {
        return _amount/1000;
    }

/*
    function getUserBalance(address _owner) external view returns (uint) {
        return address(_owner).balance;
    }*/
    function payout() public {
        for (uint256 i = 0; i < investors.length; i++) {
            address payable investor = investors[i];
            Investment storage investment = investments[investor];
            //uint256 duration = block.timestamp - investment.lastPayout;
            uint256 payoutAmount = calculatePayout(investment.amount);
            investor.transfer(payoutAmount);
            investment.lastPayout = block.timestamp;
            investment.payout = payoutAmount;
        }
    }
}