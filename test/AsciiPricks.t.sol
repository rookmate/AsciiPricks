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

    function testTokenURI() public {
        dics.mint(1);
        uint256 seed = dics.getSeed(0);

        // dics.setBalls(uint8(seed >> 32));
        // dics.setFur(uint8(seed << 224 >> 248));
        // dics.setLength(uint8(seed << 240 >> 249));
        // dics.setHead(uint8(seed << 248 >> 248));

        dics.tokenURI(0);
    }

    // function testWithdraw() public {
    //     vm.deal(address(dics), 1);
    //     assertTrue(dics.balance() == 1);
    //     dics.withdraw();
    //     assertTrue(dics.balance() == 0);
    // }
}