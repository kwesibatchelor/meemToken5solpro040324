// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// ERC Token Standard 20 Interface (6 functions)
interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint balance);
    function allowance(address owner, address spender) external view returns (uint remaining);
    function transfer(address recipient, uint amount) external returns (bool success);
    function approve(address spender, uint amount) external returns (bool success);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

// Actual token contract
contract KwesiToken is ERC20Interface {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() {
        symbol = "KT";
        name = "Kwesi Token";
        decimals = 18;
        _totalSupply = 1_000_001_000_000_000_000_000_000; // 1 million + 1 token. with 18 zeros for decimal points 
        balances[WALLET_ADDRESS] = _totalSupply;
        emit Transfer(address(0), WALLET_ADDRESS, _totalSupply);
    }

    // 6 functions begin

    // 1 Returns total supply
    function totalSupply() public view returns (uint) {
        return _totalSupply; // - balances[address(0)];
    }

    // 2 Takes a wallet address and returns the number of tokens in that wallet (from balances mapping)
    function balanceOf(address account) public view returns (uint balance) {
        return balance[account];
    }

    // 3 Controls sending a given amount to a recipient and updates the balances mapping (emits a transfer event)
    function transfer(address recipient, uint amount) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[recipient] = balances[recipient] + amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // 4 Runs an approval of a given amount to a specfic sender
    function approve(address spender, uint amount) public returns (bool success) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // 5 Similar to transfer but between two different wallets 
    function transferFrom(address sender, address recipient, uint amount) public returns (bool success) {
        balances[sender] = balances[sender] - amount;
        allowed[sender][msg.sender] = allowed[sender][msg.sender] - amount;  // prevents double spend
        balances[recipient] = balances[recipient] + amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // 6 Reads from allowance mapping and returns the remaining allowance
    function allowance(address owner, address spender) public view returns (uint remaining) {
        return allowed[owner][spender];
    }
}