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
        dics = new AsciiPricks(_root, wallets, 50);
    }

    function testConstructorMint() public view {
        assert(dics.getSeed(1) != 0);
        assert(dics.ownerOf(1) == address(0x69));
        assert(dics.balanceOf(address(0x69)) == 50);
        assert(dics.getSeed(51) != 0);
        assert(dics.ownerOf(51) == address(0x420));
        assert(dics.balanceOf(address(0x420)) == 50);
        assert(dics.getSeed(101) != 0);
        assert(dics.ownerOf(101) == address(0x1337));
        assert(dics.balanceOf(address(0x1337)) == 50);
        assert(dics.getSeed(151) != 0);
        assert(dics.ownerOf(151) == address(0x8004));
        assert(dics.balanceOf(address(0x8004)) == 50);
    }

    function testSetGetRoot() public {
        assertTrue(dics.getMerkleRoot() == _root);
        address newAddy = address(0xDEAD);
        bytes32 newRoot = keccak256((abi.encodePacked(newAddy)));
        dics.setMerkleRoot(newRoot);
        assertTrue(dics.getMerkleRoot() == newRoot);
    }

    function testMint() public {
        dics.flipSaleState();
        dics.mint(1);
        uint256 seed = dics.getSeed(200);
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
        uint256 seed = dics.getSeed(200);
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
        dics.getSeed(500);
    }

    function testFlipSale() public {
        bool oldSaleStatus = dics.saleIsActive();
        dics.flipSaleState();
        bool newSaleStatus = dics.saleIsActive();
        assertTrue(oldSaleStatus == !newSaleStatus);
    }

    function testTokenURI() public {
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