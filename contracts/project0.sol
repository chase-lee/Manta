// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./dependency/utils/Counters.sol";
import "./dependency/utils/Strings.sol";
import "./dependency/utils/Address.sol";
import "./dependency/utils/Context.sol";
import "./dependency/utils/math/SafeMath.sol";

import "./dependency/access/Ownable.sol";
import "./dependency/token/ERC721/ERC721.sol";

contract project0 is ERC721, Ownable{
    using SafeMath for uint256;
    using Strings for uint256;
    using Address for address;
    using Counters for Counters.Counter;
    
    uint256 public price;
    uint256 public maxSupply;
    uint256 public maxMint = 3;
    string public provenanceHash = "";
    uint256 public startingIndex;
    
    event Minted(uint256 indexed id);
    
    constructor(string memory name, string memory symbol, uint256 maxSupply) ERC721(name, symbol){

    }
    
    function setProvenanceHash(string memory _provenanceHash) public onlyOwner {
        require(bytes(provenance).length == 0, "Provenance already set!");
        provenanceHash = _provenanceHash;
    }
    
    //Set Base URI
    function setBaseURI(string memory _baseURI) external onlyOwner {
        _setBaseURI(_baseURI);
    }
    
    function _baseURI() internal view virtual returns (string memory) {
        return baseURI();
    }
    
    function withdraw() public payable onlyOwner {
        require(address(this).balance > 0);
        require(payable(msg.sender).send(address(this).balance));
    }
    
    function pause(bool val) public onlyOwner {
        if (val == true) {
            _pause();
            return;
        }
        _unpause();
    }
    
    function mintNFT(uint numMint) public payable {
        uint256 supply = totalSupply();
        require(!_paused, "Sale isn't live");
        require(numMint <= maxMint, "Can only mint 3 tokens at a time");
        require(add(supply, numMint) <= maxSupply, "Transaction exceeds remaining supply");
        require(mul(price, numMint) <= msg.value, "Not enough ether for transaction");
        
        for(uint i = 0; i < numMint; i++) {
            uint mintIndex = totalSupply();
            if (supply < maxSupply) {
                _safeMint(msg.sender, mintIndex);
                emit Minted(mintIndex);
            }
        }
    }
    
    
    
    
}