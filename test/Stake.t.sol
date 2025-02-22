// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Stake,Token,IERC20 } from "@src/Stake.sol";
import {Test,console} from "forge-std/Test.sol";

contract VaultTest is Test {
    Stake public stake;
    Token public token;
    address internal user = makeAddr("user");

    function setUp() public {
        token = new Token("token","TKN");
        stake = new Stake(IERC20(address(token)));
    }

    function testDeployment() public view {
        assertNotEq(address(token), address(0),"Token Undeployed");
        assertNotEq(address(stake), address(0),"Stake Undeployed");
    }

    function testFailRegistration() public {
        stake.Register("njomo",address(token),13);
    }

    function testRegistration() public {
        startHoax(user);

        token.deposit{value:12e18}();

        token.approve(address(stake),8e18);

        stake.deposit(8e18,user);

        stake.Register("njomo",user,13);

        vm.stopPrank();
    }
}