// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.6.0
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Kipu is ERC20 {
    constructor() ERC20("Kipu", "kp") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}