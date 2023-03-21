// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "./ERC721A.sol";
import './base64.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract AsciiPricks is ERC721A, Ownable {
    using Strings for uint256;

    error SaleIsPaused();
    error MaxSupplyReached();
    error MaxPerWalletReached();
    error InsufficientPayment();
    error NoDicFound();

    mapping(uint256 => uint256) private tokenSeed; //TokenID to TokenSeed
    uint256 public MAX_SUPPLY = 8004;
    uint256 public constant COST_PER_MINT = 0 ether;
    bool public saleIsActive = true;
    uint8 public MAX_PER_WALLET = 10;

    struct Color {
        string value;
        string name;
    }

    struct Trait {
        string content;
        string name;
        Color color;
    }

    constructor() ERC721A("ASCII Pricks", "PRICK") {
    }

    function mint(uint32 qty) external payable {
        if (!saleIsActive) revert SaleIsPaused();
        if (_totalMinted() + qty > MAX_SUPPLY) revert MaxSupplyReached();
        if (_numberMinted(msg.sender) + qty > MAX_PER_WALLET) revert MaxPerWalletReached();
        if (msg.value < qty * COST_PER_MINT) revert InsufficientPayment();

        for (uint256 i = 0; i < qty; i++) {
            tokenSeed[_totalMinted() + i] = uint256(
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

    function getSeed(uint256 tokenId) public view returns (uint256) {
        if (!_exists(tokenId)) revert NoDicFound();
        return tokenSeed[tokenId];
    }

    /*
    XX    Balls        90% normal / 10% other
    YY    Fur          75% without / 25% with
    ZZ    length       Linear scale from 0 to 127 - Max len 12
    AA    Head         Split in 3 get one of 3
    BB    Squiggles    Like length or Head
    */  
    function tokenURI(uint256 tokenId) public override view returns (string memory) {
        uint256 seed = tokenSeed[tokenId];
        Trait memory balls = setBalls(uint8(seed >> 32));           //up to 255
        Trait memory fur = setFur(uint8(seed << 224 >> 248));       //up to 255
        Trait memory length = setLength(uint8(seed << 240 >> 249)); //up to 127
        Trait memory head = setHead(uint8(seed << 248 >> 248));     //up to 255
        // Trait memory squiggles = setSquiggles();

        string memory rawSvg = string(
            abi.encodePacked(
                '<svg width="320" height="320" viewBox="0 0 320 320" xmlns="http://www.w3.org/2000/svg">',
                '<rect width="100%" height="100%" fill="#0C090A"/>',
                '<text x="50%" y="50%" font-family="Courier,monospace" font-weight="700" font-size="20" text-anchor="middle" letter-spacing="1">\n',
                balls.content,
                fur.content,
                length.content,
                head.content,
                '</text>',
                '</svg>'
            )
        );

        string memory encodedSvg = Base64.encode(bytes(rawSvg));
        string memory description = 'Prick';

        if (bytes(fur.color.name).length == 0) {
            return string(
                abi.encodePacked(
                    'data:application/json;base64,',
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{',
                                '"name":"PRICKS #', tokenId.toString(), '",',
                                '"description":"', description, '",',
                                '"image": "', 'data:image/svg+xml;base64,', encodedSvg, '",',
                                '"attributes": [{"trait_type": "Head", "value": "', head.name,' (',head.color.name,')', '"},',
                                '{"trait_type": "Length", "value": "', length.name,' (',length.color.name,')', '"},',
                                '{"trait_type": "Fur", "value": "', fur.name,'"},',
                                '{"trait_type": "Balls", "value": "', balls.name,' (',balls.color.name,')', '"},',
                                ']',
                                '}')
                        )
                    )
                )
            );
        } else {
            return string(
                abi.encodePacked(
                    'data:application/json;base64,',
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{',
                                '"name":"PRICKS #', tokenId.toString(), '",',
                                '"description":"', description, '",',
                                '"image": "', 'data:image/svg+xml;base64,', encodedSvg, '",',
                                '"attributes": [{"trait_type": "Head", "value": "', head.name,' (',head.color.name,')', '"},',
                                '{"trait_type": "Length", "value": "', length.name,' (',length.color.name,')', '"},',
                                '{"trait_type": "Fur", "value": "', fur.name,' (',fur.color.name,')', '"},',
                                '{"trait_type": "Balls", "value": "', balls.name,' (',balls.color.name,')', '"},',
                                ']',
                                '}')
                        )
                    )
                )
            );
        }
    }

    function setBalls(uint8 seed) public pure returns (Trait memory) {
        Color memory color = setColor(uint8(seed >> 1));
        string memory content;
        string memory name;
        if (seed < 299) {
            content = "8";
            name = "Regular Joe";
        } else {
            content = "d";
            name = "That Lucky Ball";
        }

        return Trait(string(abi.encodePacked('<tspan fill="', color.value, '">', content, '</tspan>\n')), name, color);
    }

    function setFur(uint8 seed) public pure returns (Trait memory) {
        Color memory color;
        string memory content;
        string memory name;
        uint256 x;
        if (seed > 32 && seed < 223) {
            content = "";
            name = "No Fur";
            color = Color("#000000", "");
        } else {
            color = setColor(uint8(seed >> 1));
            content = "#";
            name = "Comfy Fur";
            return Trait(string(abi.encodePacked('<tspan dx="-0.6em" fill="', color.value, '">', content, '</tspan>\n')), name, color);
        }

        return Trait(string(abi.encodePacked('<tspan dx="-0.6em" fill="', color.value, '">', content, '</tspan>\n')), name, color);
    }

    function setLength(uint8 seed) public pure returns (Trait memory) {
        Color memory color = setColor(seed);
        string memory content = "";
        for (uint8 i = 0; i < seed;) {
            if (i % 10 == 0) {
                content = string(abi.encodePacked(content, "="));
            }

            unchecked {
                ++i;
            }
        }

        return Trait(string(abi.encodePacked('<tspan dx="-0.6em" fill="', color.value, '">', content, '</tspan>\n')), "How big is your love", color);
    }

    function setHead(uint8 seed) public pure returns (Trait memory) {
        Color memory color = setColor(uint8(seed >> 1));
        string memory content;
        string memory name;
        if (seed < 85) {
            content = "D";
            name = "Rounded";
        } else if (seed < 170) {
            content = "()";
            name = "Splashed";
        } else {
            content = ">";
            name = "Arrow";
        }

        return Trait(string(abi.encodePacked('<tspan dx="-0.6em" fill="', color.value, '">', content, '</tspan>\n')), name, color);
    }

    function setSquiggles(uint8 seed) private pure returns (Trait memory) {

    }

    function setColor(uint8 seed) public pure returns (Color memory) {
        if (seed < 6) {
            return Color("#08f7fe", "Geo Glow Blue");
        }
        if (seed < 12) {
            return Color("#09fbd3", "Geo Glow Green");
        }
        if (seed < 18) {
            return Color("#fe53bb", "Geo Glow Pink");
        }
        if (seed < 24) {
            return Color("#f5d300", "Geo Glow Yellow");
        }

        if (seed < 30) {
            return Color("#ffacfc", "Neon Light Pink");
        }
        if (seed < 36) {
            return Color("#f148fb", "Neon Bubblegum Pink");
        }
        if (seed < 42) {
            return Color("#7122fa", "Neon Blue");
        }
        if (seed < 48) {
            return Color("#560a86", "Neon Purple");
        }

        if (seed < 54) {
            return Color("#ffe3f1", "Retro Light Pink");
        }
        if (seed < 60) {
            return Color("#fe1c80", "Retro Pink");
        }
        if (seed < 66) {
            return Color("#ff5f01", "Retro Orange");
        }
        if (seed < 72) {
            return Color("#ce0000", "Retro Red");
        }

        if (seed < 78) {
            return Color("#fcf340", "Bokeh Yellow");
        }
        if (seed < 84) {
            return Color("#7fff00", "Bokeh Green");
        }
        if (seed < 90) {
            return Color("#fb33db", "Bokeh Pink");
        }
        if (seed < 96) {
            return Color("#0310ea", "Bokeh Blue");
        }

        if (seed < 102) {
            return Color("#fcf340", "Venetian Green");
        }
        if (seed < 108) {
            return Color("#7fff00", "Venetian Blue");
        }
        if (seed < 114) {
            return Color("#fb33db", "Venetian Light Pink");
        }
        if (seed < 120) {
            return Color("#0310ea", "Venetian Pink");
        }

        return Color('#f7ef8a','King Gold');
    }
}