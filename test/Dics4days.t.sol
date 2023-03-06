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
        dics.mint(1);
        dics.getSeed(0);
    }

    function testRevertGetSeed() public {
        dics.mint(1);
        dics.getSeed(0);
        vm.expectRevert();
        dics.getSeed(1);
    }

    function testFlipSale() public {
        bool oldSaleStatus = dics.saleIsActive();
        dics.flipSaleState();
        bool newSaleStatus = dics.saleIsActive();
        assertTrue(oldSaleStatus == !newSaleStatus);
    }
}