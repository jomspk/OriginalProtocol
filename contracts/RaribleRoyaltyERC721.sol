//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./rarible/impl/RoyaltiesV2Impl.sol";
import "./rarible/royalties/contracts/LibPart.sol";
import "./rarible/royalties/contracts/LibRoyaltiesV2.sol";

import "hardhat/console.sol";
import "./libraries/Base64.sol";

contract RoyaltyNFT is ERC721, Ownable, RoyaltiesV2Impl {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdTracker;

    struct JamAttribute {
        uint jamIndex;
        string name;
        string imageURI;
    }

    mapping(uint256 => JamAttribute) public nftHolderAttributes;
    mapping(address => uint256) public nftHolders;

    event JamNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("RoyaltyNFT", "ROY") {
        console.log("THIS IS ROYALTY CONTRACT");
        _tokenIdTracker.increment();
    }

    // 複数のNFTを保有できるようにする
    function mintJamNFT(address _to, uint _jamIndex, string memory _title, string memory _imageURI) external {
        uint256 newItemId = _tokenIdTracker.current();

        _safeMint(_to, newItemId);
        nftHolderAttributes[newItemId] = JamAttribute({
            jamIndex: _jamIndex,
            name: _title,
            imageURI: _imageURI
        });
        console.log("Minted NFT w/ tokenID %s", newItemId);
        nftHolders[_to] = newItemId;
        _tokenIdTracker.increment();
        emit JamNFTMinted(_to, newItemId);
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        JamAttribute memory jamAttribute = nftHolderAttributes[_tokenId];
        string memory json = Base64.encode(
            abi.encodePacked(
        '{"name": "',
        jamAttribute.name,
        ' -- NFT #: ',
        Strings.toString(_tokenId),
        '", "description": "This is an JAM NFT", "image": "',
        jamAttribute.imageURI,'"}'
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        return output;
    }

    // function _baseURI() internal view virtual override returns (string memory) {
    //     return "https://exampledomain/metadata/";
    // }

    function setRoyalties(uint _tokenId, address payable _royaltiesReceipientAddress, uint96 _percentageBasisPoints) public onlyOwner {
        // ()は配列サイズ
        LibPart.Part[] memory _royalties = new LibPart.Part[](1);
        _royalties[0].value = _percentageBasisPoints;
        _royalties[0].account = _royaltiesReceipientAddress;
        _saveRoyalties(_tokenId, _royalties);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
        if(interfaceId == LibRoyaltiesV2._INTERFACE_ID_ROYALTIES) {
            return true;
        }
        return super.supportsInterface(interfaceId);
    }
 }