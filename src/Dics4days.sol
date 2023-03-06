// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Secret is ERC721A, Ownable {
    error SaleIsPaused();
    error MaxSupplyReached();
    error MaxPerWalletReached();
    error InsufficientPayment();
    error NoDicFound();

    mapping(uint256 => bytes32) private tokenSeed;
    uint256 public MAX_SUPPLY = 8004;
    uint256 public constant COST_PER_MINT = 0 ether;
    bool public saleIsActive = true;
    uint8 public MAX_PER_WALLET = 10;

    constructor() ERC721A("Secret Project", "SECRET") {
    }

    function mint(uint32 qty) external payable {
        if (!saleIsActive) revert SaleIsPaused();
        if (_totalMinted() + qty > MAX_SUPPLY) revert MaxSupplyReached();
        if (_numberMinted(msg.sender) + qty > MAX_PER_WALLET) revert MaxPerWalletReached();
        if (msg.value < qty * COST_PER_MINT) revert InsufficientPayment();

        for (uint256 i = 0; i < qty; i++) {
            tokenSeed[_totalMinted() + i] = bytes32(
                keccak256(abi.encodePacked(block.timestamp, msg.sender, _totalMinted() + i)) << 108 >> 216
            );
        }

        _mint(msg.sender, qty);
    }

    function flipSaleState() external onlyOwner {
        saleIsActive = !saleIsActive;
    }

    function withdraw() external payable onlyOwner {
        (bool os,)= payable(owner()).call{value: address(this).balance}("");
        require(os);
    }

    function getSeed(uint256 tokenId) public view returns (bytes32) {
        if (!_exists(tokenId)) revert NoDicFound();
        return tokenSeed[tokenId];
    }

    function tokenURI(uint256 tokenId) public override view returns (string memory) {
        return "";
    }
}