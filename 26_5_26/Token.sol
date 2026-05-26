// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;

interface IToken {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    error ZeroAddress(); // keccak256(ZeroAddress) => primeros 4bytes
}

abstract contract Token is IToken {
    string public name;
    string public symbol;
    uint8 public decimals = 18; // ether => wei
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;


    function _transfer(address sender, address receiver, uint256 amount) internal { 
        require(receiver != sender, "No se puede transferir a ti mismo");
        require(balanceOf[sender] >= amount, "Saldo insuficiente");
        unchecked {
            balanceOf[sender] -= amount; // 5-6 => revierte
            balanceOf[receiver] += amount;
        }
        emit Transfer(sender, receiver, amount);
    }


    function transferFrom(address sender, address receiver, uint256 amount) external returns(bool) { 
        require(allowance[sender][msg.sender] >= amount, "Not enaugh Allowance");
        allowance[sender][msg.sender] -= amount;
        _transfer(sender, receiver, amount);
        return true;
    }

    // 0xa9059cbb = 0xa9059cbb
    function transfer(address receiver, uint256 amount) external returns(bool) { // 0,50
        require(amount != 0, "ZeroAmount");
        if (receiver == address(0)) revert ZeroAddress(); // custom errors
        
        assert(receiver == address(0)); // lugares donde nunca tenga que llegar el codigo => revert
        require(receiver == address(0)); // checkeo de variable de entrada => revert

        _transfer(msg.sender, receiver, amount);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool success) {
        if (_spender == address(0)) revert ZeroAddress();
        allowance[msg.sender][_spender] = _value;
        return true;
    }

}