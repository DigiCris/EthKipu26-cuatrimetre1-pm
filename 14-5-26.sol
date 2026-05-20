/*
1. Crear un contrato que represente a una criptomoneda para el curso (listo)
2. Este contrato debe permitir:
a. Consultar balances (listo)
b. Transferir saldos entre cuentas (listo)
3. Agregar las validaciones que sean necesarias (listo)
*/

/*
1. Crear un contrato que represente a una criptomoneda para el curso (listo)
2. Este contrato debe permitir:
a. Consultar balances (listo)
b. Transferir saldos entre cuentas (listo)
3. Agregar las validaciones que sean necesarias (listo)
*/

// SPDX-License-Identifier: MIT
pragma solidity >0.8.30;

contract CriptoMoneda {
    mapping (address => uint256) private balance;
    uint256 private totalSupply;

    address public owner;

    error ZeroAddress(); // keccak256(ZeroAddress) => primeros 4bytes
    error OnlyOwner();

    constructor() {
        balance[msg.sender] = 1000;
        totalSupply = 1000; // invariante
        owner = msg.sender;
    }

    function balanceOf(address _addr) view external returns(uint256) {
        return balance[_addr];
    }

    function _transfer(address sender, address receiver, uint256 amount) internal { 
        require(receiver != sender, "No se puede transferir a ti mismo");
        require(balance[sender] >= amount, "Saldo insuficiente");
        unchecked {
            balance[sender] -= amount; // 5-6 => revierte
            balance[receiver] += amount;
        }
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwner();
        _;
    }

    uint8 flag;
    modifier noReentrant() {
        if (flag!=0) revert();
        flag = 1;
        _;
        flag=0;
    }

    function transferFrom(address sender, address receiver, uint256 amount) external onlyOwner noReentrant { 
        _transfer(sender, receiver, amount);
    }

    function transfer(address receiver, uint256 amount) external { // 0,50
        require(amount != 0, "ZeroAmount");
        if (receiver == address(0)) revert ZeroAddress(); // custom errors
        
        assert(receiver == address(0)); // lugares donde nunca tenga que llegar el codigo => revert
        require(receiver == address(0)); // checkeo de variable de entrada => revert

        _transfer(msg.sender, receiver, amount);
    }

}
