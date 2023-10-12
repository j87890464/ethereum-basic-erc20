// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./ERC20.sol";

contract WETH is ERC20 {

    event Deposit(address indexed _to, uint256 _value);
    event Withdraw(address indexed _from, uint256 _value);

    constructor() ERC20("Wrapped Ether", "WETH", 18, 0) {

    }

    fallback() external payable {
        deposit();
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0, "Need Ether > 0.");
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _value) public {
        _checkBalanceSufficiency(msg.sender, _value);
        _burn(msg.sender, _value);
        (bool success, ) = msg.sender.call{value: _value}("");
        require(success, "Withdraw fail.");
        emit Withdraw(msg.sender, _value);
    }
}