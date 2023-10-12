// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        if(_totalSupply > 0) {
            totalSupply = _totalSupply * 10**decimals;
            _balances[msg.sender] = totalSupply;
            emit Transfer(address(0), msg.sender, totalSupply);
        }
    }

    function balanceOf(address _owner) public view override returns (uint256) {
        return _balances[_owner];
    }
   
    function transfer(address _to, uint256 _value) external override returns (bool) {
        _checkBalanceSufficiency(msg.sender, _value);
        _balances[msg.sender] -= _value;
        _balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
       
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external override returns (bool) {
        _checkBalanceSufficiency(_from, _value);
        _checkAllowanceSufficiency(_from, _value);
        _allowances[_from][msg.sender] -= _value;
        _balances[_from] -= _value;
        _balances[_to] += _value;
        emit Transfer(_from, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) external override returns (bool) {
        _allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function allowance(address _owner, address _spender) public view override returns (uint256) {
        return _allowances[_owner][_spender];
    }

    function _checkAllowanceSufficiency(address _from, uint256 _value) internal view {
        require(_allowances[_from][msg.sender] >= _value, "Allowance is insufficient!");
    }

    function _checkBalanceSufficiency(address _from, uint256 _value) internal view {
        require(_balances[_from] >= _value, "Balance is insufficient!");
    }

    function _mint(address _to, uint256 _value) internal {
        totalSupply += _value;
        _balances[_to] += _value;
    }

    function _burn(address _from, uint256 _value) internal {
        totalSupply -= _value;
        _balances[_from] -= _value;
    }
}