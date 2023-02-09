// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract XiDNFT is ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    address public walletAddress;
    address public tokenAddress;
    address public crossmintAddress;
    Counters.Counter private tokenIds;

    uint256[3] public roundPrice;
    uint256[3] public roundSupply;
    uint256 private currentSupply;
    uint256 public currentRound;
    string private baseURI;

    constructor(
        address _walletAddress,
        address _tokenAddress,
        address _crossmintAddress,
        uint256[3] memory _roundPrice,
        uint256[3] memory _roundSupply,
        string memory _uri
    ) ERC721("XIDNFT", "XID") Ownable() {
        walletAddress = _walletAddress;
        tokenAddress = _tokenAddress;
        crossmintAddress = _crossmintAddress;
        for (uint256 index = 0; index < 3; index++) {
            roundPrice[index] = _roundPrice[index];
            roundSupply[index] = _roundSupply[index];
        }
        currentRound = 1;
        currentSupply = roundSupply[0];
        baseURI = _uri;
    }

    function buy() public {
        _mint(msg.sender);
    }

    function crossmintBuy(address to) public {
        require(msg.sender == crossmintAddress, "Only crossmint");

        _mint(to);
    }

    function _mint(address to) internal {
        require(tokenIds.current() < currentSupply, "Supply exceed");

        IERC20(tokenAddress).transferFrom(
            msg.sender,
            walletAddress,
            roundPrice[currentRound - 1]
        );

        tokenIds.increment();
        uint256 _tokenId = tokenIds.current();
        _safeMint(to, _tokenId);

        if (_tokenId == currentSupply) {
            _migrateNextRound();
        }
    }

    function _migrateNextRound() internal {
        if (currentRound < 2) {
            currentRound += 1;
            currentSupply += roundSupply[currentRound - 1];
        }
    }

    function setWalletAddress(address _walletAddress) external onlyOwner {
        walletAddress = _walletAddress;
    }

    function setTokenAddress(address _tokenAddress) external onlyOwner {
        tokenAddress = _tokenAddress;
    }

    function setCrossmintAddress(address _crossmintAddress) external onlyOwner {
        crossmintAddress = _crossmintAddress;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
}
