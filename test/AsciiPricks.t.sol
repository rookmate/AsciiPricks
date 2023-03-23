// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/AsciiPricks.sol";

contract AsciiPricksTest is Test {
    AsciiPricks public dics; 

    function setUp() public {
        dics = new AsciiPricks();
    }

    function testMint() public {
        dics.flipSaleState();
        dics.mint(1);
        uint256 seed = dics.getSeed(0);
        assertTrue(seed != 0);
    }

    function testRevertGetSeed() public {
        vm.expectRevert();
        dics.getSeed(1);
    }

    function testFlipSale() public {
        bool oldSaleStatus = dics.saleIsActive();
        dics.flipSaleState();
        bool newSaleStatus = dics.saleIsActive();
        assertTrue(oldSaleStatus == !newSaleStatus);
    }

    function testTokenURI() public {
        dics.flipSaleState();
        address foo = address(0x42069);
        vm.startPrank(foo);
        dics.mint(1);
        string memory uri = dics.tokenURI(0);
        assertTrue(bytes(uri).length != 0);
    }

    // function testWithdraw() public {
    //     vm.deal(address(dics), 1);
    //     assertTrue(dics.balance() == 1);
    //     dics.withdraw();
    //     assertTrue(dics.balance() == 0);
    // }
}