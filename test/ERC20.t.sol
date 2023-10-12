// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {ERC20} from "../src/ERC20.sol";

contract ERC20Test is Test {
    ERC20 public erc20;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    function setUp() public {
        erc20 = new ERC20("Test", "Test", 18, 100);
    }

    function test_Constructor() public {
        vm.expectEmit();
        ERC20 _erc20 = new ERC20("Test", "Test", 18, 100);
        emit Transfer(address(0), address(this), 100e18);
        assertEq(_erc20.name(), "Test");
        assertEq(_erc20.symbol(), "Test");
        assertEq(_erc20.decimals(), 18);
        assertEq(_erc20.totalSupply(), 100e18);
        assertEq(_erc20.balanceOf(address(this)), 100e18);
    }
}