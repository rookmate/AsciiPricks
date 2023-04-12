// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/AsciiPricks.sol";

contract AsciiPricksTest is Test {
    AsciiPricks public dics;
    bytes32 public _root = keccak256((abi.encodePacked(address(0x42069))));

    function setUp() public {
        address[] memory wallets = new address[](4);
        wallets[0] = address(0x69);
        wallets[1] = address(0x420);
        wallets[2] = address(0x1337);
        wallets[3] = address(0x8004);
        dics = new AsciiPricks(_root, wallets);
    }

    function testSetGetRoot() public {
        assertTrue(dics.getMerkleRoot() == _root);
        address newAddy = address(0xDEAD);
        bytes32 newRoot = keccak256((abi.encodePacked(newAddy)));
        dics.setMerkleRoot(newRoot);
        assertTrue(dics.getMerkleRoot() == newRoot);
    }

    function testFounderMint() public {
        // founder mint
        address foo = address(0x420);
        vm.startPrank(foo);
        dics.founderMint(foo);
        uint256 seed = dics.getSeed(49);
        assertTrue(seed != 0);
        // founder double mint
        vm.expectRevert();
        dics.founderMint(foo);
        vm.stopPrank();
        // Non founder mint
        address bar = address(0x42069);
        vm.startPrank(bar);
        vm.expectRevert();
        dics.founderMint(bar);
    }

    function testMint() public {
        dics.flipSaleState();
        dics.mint(1);
        uint256 seed = dics.getSeed(0);
        assertTrue(seed != 0);
    }

    function testMintZero() public {
        dics.flipSaleState();
        vm.expectRevert();
        dics.mint(0);
        vm.expectRevert();
        bytes32[] memory proof = new bytes32[](0);
        dics.alMint(proof, 0);
    }

    function testALMint() public {
        dics.flipSaleState();
        address foo = address(0x42069);
        vm.startPrank(foo);
        bytes32[] memory proof = new bytes32[](0);
        dics.alMint(proof, 1);
        uint256 seed = dics.getSeed(0);
        assertTrue(seed != 0);
    }

    function testInvalidProofMint() public {
        dics.flipSaleState();
        address foo = address(0xDEAD);
        vm.startPrank(foo);
        bytes32[] memory proof = new bytes32[](0);
        vm.expectRevert();
        dics.alMint(proof, 1);
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

    function testOvermint() public {
        dics.flipSaleState();
        address foo = address(0x42069);
        vm.startPrank(foo);
        vm.expectRevert();
        dics.mint(20);
    }

    function testSaleIsPaused() public {
        vm.expectRevert();
        dics.mint(1);
    }

    // function testWithdraw() public {
    //     vm.deal(address(dics), 1);
    //     assertTrue(dics.balance() == 1);
    //     dics.withdraw();
    //     assertTrue(dics.balance() == 0);
    // }
}