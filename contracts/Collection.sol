// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

contract Collection is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private collectionId;

    struct CollectionStruct {
        uint256 collectionId;
        address owner;
        string uri;
        uint256 categoryId;
    }
    mapping(uint256 => CollectionStruct) private collections;

    constructor() ERC721("Metaverse", "METT") {}

    function createCollection(string memory collectionURI, uint256 categoryId)
        public
    {
        collectionId.increment();
        uint256 newCollectionId = collectionId.current();
        collections[newCollectionId] = CollectionStruct(
            newCollectionId,
            msg.sender,
            collectionURI,
            categoryId
        );
    }

    function fetchAllCollection(uint256 perPage, uint256 pageNo)
        public
        view
        returns (CollectionStruct[] memory)
    {
        uint256 collectionCount = collectionId.current();
        CollectionStruct[] memory dumCollections = new CollectionStruct[](
            perPage
        );
        for (
            uint256 i = ((pageNo - 1) * perPage) + 1;
            i <= collectionCount && i <= (pageNo * perPage);
            i++
        ) {
            CollectionStruct storage collection = collections[i];
            dumCollections[i - 1] = collection;
        }

        return dumCollections;
    }

    function fetchMyCollection(uint256 perPage, uint256 pageNo)
        public
        view
        returns (CollectionStruct[] memory)
    {
        uint256 collectionCount = collectionId.current();
        CollectionStruct[] memory dumCollections = new CollectionStruct[](
            perPage
        );
        uint256 count = 1;
        uint256 collectionIndex = 0;
        for (
            uint256 i = 0;
            i < collectionCount && collectionIndex < perPage;
            i++
        ) {
            CollectionStruct storage collection = collections[i];
            if (collection.owner == msg.sender) {
                count++;
                if (count > ((pageNo - 1) * perPage)) {
                    dumCollections[collectionIndex] = collection;
                    collectionIndex++;
                }
            }
        }
        return dumCollections;
    }

    function fetchCategoryCollection(
        uint256 categoryId,
        uint256 perPage,
        uint256 pageNo
    ) public view returns (CollectionStruct[] memory) {
        uint256 collectionCount = collectionId.current();
        CollectionStruct[] memory dumCollections = new CollectionStruct[](
            perPage
        );
        uint256 count = 1;
        uint256 collectionIndex = 0;
        for (
            uint256 i = 0;
            i < collectionCount && collectionIndex < perPage;
            i++
        ) {
            CollectionStruct storage collection = collections[i];
            if (collection.categoryId == categoryId) {
                count++;
                if (count > ((pageNo - 1) * perPage)) {
                    dumCollections[collectionIndex] = collection;
                    collectionIndex++;
                }
            }
        }
        return dumCollections;
    }
}
