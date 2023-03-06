// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Dics4days.sol";

contract SecretTest is Test {
    Secret public dics; 

    function setUp() public {
        dics = new Secret();
    }

    function testMint() public {
        dics.mint(2);
    }
}