// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC4626,ERC20,IERC20} from "@openzeppelin/token/ERC20/extensions/ERC4626.sol";
//import {Farmer} from "./Database.sol";

interface IStake { 
    function Register(string memory _name, address _addr, uint256 _timelock) external payable;
}

contract Stake is IStake,ERC20,ERC4626 {

    struct Farmer {
        string name;
        address addr;
        uint256 shares;
        uint256 currentNumber;
        uint256 timelock;
    }

    mapping(address => Farmer) public farmer;

    event New_Master_Farmer(address indexed who,uint256 _shares);

    constructor(IERC20 _asset_) ERC20("MFToken","MFT") ERC4626(_asset_) {}

    function decimals() public override(ERC4626,ERC20) view returns(uint8) {
        return 18;
    }

    function Register(string memory _name, address _addr, uint256 _timelock) external payable {
        uint256 length;
        uint256 balance = balanceOf(msg.sender);
        assembly{
            length := extcodesize(_addr)
        }

        require(_addr != address(0) && length == 0, "Not eligible for smart contracts and zero address");
        require(balance > 1e18,"First deposit the ammount of stake desired");
        require((block.number + _timelock) - block.number > 12, "Below minimum lock schedule");

        farmer[msg.sender] = Farmer({
            name:_name,
            addr:_addr,
            shares:balance,
            currentNumber:block.number,
            timelock:_timelock
        });

        emit New_Master_Farmer(msg.sender,balance);
    }

}
