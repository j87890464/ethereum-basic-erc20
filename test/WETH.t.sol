// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {WETH} from "../src/WETH.sol";

contract WETHTest is Test {
    WETH public weth;
    address public immutable userA = makeAddr("UserA");
    address public immutable userB = makeAddr("UserB");

    event Deposit(address indexed _to, uint256 _value);
    event Withdraw(address indexed _from, uint256 _value);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function setUp() public {
        weth = new WETH();
    }

    function test_Constructor() public {
        WETH _weth = new WETH();
        assertEq(_weth.name(), "Wrapped Ether");
        assertEq(_weth.symbol(), "WETH");
        assertEq(_weth.decimals(), 18);
        assertEq(_weth.totalSupply(), 0);
    }

    function test_Deposit_CorrectAmountToken() public {
        deal(userA, 100 ether);
        vm.startPrank(userA);
        uint _amount = 1e18;
        weth.deposit{value: 1 ether}();
        assertEq(weth.balanceOf(userA), _amount);
        vm.stopPrank();
    }

    function test_Deposit_CorrectAmountEther() public {
        deal(userA, 100 ether);
        vm.startPrank(userA);
        uint beforeBalance = address(weth).balance;
        weth.deposit{value: 1 ether}();
        uint afterBalance = address(weth).balance;
        assertEq((afterBalance - beforeBalance), 1e18);
        vm.stopPrank();
    }

    function test_Deposit_EmitDepositEvent() public {
        deal(userA, 100 ether);
        vm.startPrank(userA);
        vm.expectEmit();
        emit Deposit(userA, 1e18);
        weth.deposit{value: 1 ether}();
        vm.stopPrank();
    }

    function test_Withdraw_BurnCorrectAmountToken() public {
        deal(address(weth), userA, 1e18, true);
        deal(address(weth), 1e18);
        uint withdrawAmount = 1e18;
        uint beforeTotalSupply = weth.totalSupply();
        vm.startPrank(userA);
        weth.withdraw(withdrawAmount);
        uint afterTotalSupply = weth.totalSupply();
        assertEq((beforeTotalSupply - afterTotalSupply), withdrawAmount);
        vm.stopPrank();
    }

    function test_Withdraw_CorrectAmountEther() public {
        deal(address(weth), userA, 1e18, true);
        deal(address(weth), 1e18);
        uint withdrawAmount = 1e18;
        uint beforeBalance = userA.balance;
        vm.startPrank(userA);
        weth.withdraw(withdrawAmount);
        uint afterBalance = userA.balance;
        assertEq((afterBalance - beforeBalance), withdrawAmount);
        vm.stopPrank();
    }

    function test_Withdraw_EmitWithdrawEvent() public {
        deal(address(weth), userA, 1e18, true);
        deal(address(weth), 1e18);
        uint withdrawAmount = 1e18;
        vm.startPrank(userA);
        vm.expectEmit();
        emit Withdraw(userA, withdrawAmount);
        weth.withdraw(withdrawAmount);
        vm.stopPrank();
    }

    function test_Transfer_CorrectAmountToken() public {
        deal(address(weth), userA, 1e18, true);
        deal(address(weth), 1e18);
        uint transferAmount = 1e18;
        uint userABeforeBalance = weth.balanceOf(userA);
        uint userBBeforeBalance = weth.balanceOf(userB);
        vm.startPrank(userA);
        weth.transfer(userB, transferAmount);
        uint userAAfterBalance = weth.balanceOf(userA);
        uint userBAfterBalance = weth.balanceOf(userB);
        assertEq((userABeforeBalance - userAAfterBalance), transferAmount);
        assertEq((userBAfterBalance - userBBeforeBalance), transferAmount);
        vm.stopPrank();
    }

    function test_Transfer_EmitTransferEvent() public {
        deal(address(weth), userA, 1e18, true);
        deal(address(weth), 1e18);
        uint transferAmount = 1e18;
        vm.startPrank(userA);
        vm.expectEmit();
        emit Transfer(userA, userB, transferAmount);
        weth.transfer(userB, transferAmount);
        vm.stopPrank();
    }

    function test_Approve_CorrectAllowance() public {
        uint approveAmount = 1e18;
        vm.startPrank(userA);
        weth.approve(userB, approveAmount);
        assertEq(weth.allowance(userA, userB), approveAmount);
        vm.stopPrank();
    }

    function test_Approve_EmitApprovalEvent() public {
        uint approveAmount = 1e18;
        vm.startPrank(userA);
        vm.expectEmit();
        emit Approval(userA, userB, approveAmount);
        weth.approve(userB, approveAmount);
        vm.stopPrank();
    }

    function test_TransferFrom() public {
        deal(address(weth), userA, 1e18, true);
        deal(address(weth), 1e18);
        uint transferFromAmount = 1e18;
        vm.prank(userA);
        weth.approve(userB, transferFromAmount);
        vm.startPrank(userB);
        uint userABeforeBalance = weth.balanceOf(userA);
        uint userBBeforeBalance = weth.balanceOf(userB);
        weth.transferFrom(userA, userB, transferFromAmount);
        uint userBAfterBalance = weth.balanceOf(userB);
        uint userAAfterBalance = weth.balanceOf(userA);
        assertEq((userABeforeBalance - userAAfterBalance), transferFromAmount);
        assertEq((userBAfterBalance - userBBeforeBalance), transferFromAmount);
        vm.stopPrank();
    }

    function test_TransferFrom_CorrectUsageAmount() public {
        deal(address(weth), userA, 10e18, true);
        deal(address(weth), 10e18);
        uint approveAmount = 10e18;
        uint transferFromAmount = 1e18;
        uint expectRemain = approveAmount - transferFromAmount;
        vm.prank(userA);
        weth.approve(userB, approveAmount);
        vm.startPrank(userB);
        weth.transferFrom(userA, userB, transferFromAmount);
        assertEq(weth.allowance(userA, userB), expectRemain);
        vm.stopPrank();
    }
}