// SPDX-License-Identifier: MIT
pragma solidity >0.8.0;


import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/*
te mando eth y vos me mandas tokens. (1 a 1)=> buy

WETH

Deployado en:
https://basescan.org/token/0x2B0d49a65808f302821f33355491FD2E3B12a3f2#code
*/

contract ICO is Ownable {

    IERC20 public kipu;

    constructor(address _kipu) Ownable(msg.sender) {
        kipu = IERC20(_kipu);
    }

    function buy() payable external {
        kipu.transfer(msg.sender, msg.value);
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

}