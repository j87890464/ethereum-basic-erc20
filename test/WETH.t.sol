// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {WETH} from "../src/WETH.sol";

contract WETHTest is Test {
    WETH public weth;
    address public immutable userA = address(0x01);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function setUp() public {
        weth = new WETH();
        vm.deal(userA, 100 ether);
    }

    function test_Constructor() public {
        WETH _weth = new WETH();
        assertEq(_weth.name(), "Wrapped Ether");
        assertEq(_weth.symbol(), "WETH");
        assertEq(_weth.decimals(), 18);
        assertEq(_weth.totalSupply(), 0);
    }

    function test_DepositCorrectTokenAmount() public {
        vm.startPrank(userA);
        weth.deposit{value: 1 ether}();
        assertEq(weth.balanceOf(userA), 1e18);
        vm.stopPrank();
    }
}