# ERC721-A: Gas Inspection

ERC721-A saves gas on minting with 3 optimizations:
1. Removes token metadata storage redundancy on the OZ IERC721Enumerable implementation.
2. Updates owner balance once during batch mints.
3. Updates owner data once during batch mints.

The 3rd gas optimization is more of a deferment of gas fees from minting to transfers. This optimization is achieved by writing the owner's address in storage once, where subsequent zero addresses in storage following the owner's address are presumed as owned by that owner. This reduces the number of writes of the owner's address from n tokens to 1 write. However, once these tokens are transferred to a new owner, the storage slot must not only be written from a zero to a non-zero address, but subsequent storage slots that are still owned by the original owner must be written to the original owner. So, although this method saves gas for the minter, it transfers the burden of write fees (including zero to non-zero writes) to buyers of these tokens.

# ERC721Enumerable: Pros & Cons

ERC721Enumerable is a gas-heavy optional extension to the ERC721 contract. It contains a series of mappings indexing token ownership, so that token ownership can be looked up by the owner address, where all tokens owned by a particular address are able to be read on-chain. The standard implementation of ERC721 only allows read functions on the owner of a specific token by its id or the total number of tokens owned by an particular address, but not which tokens are owned.

The primary benefit of ERC721Enumerable is that it allows on-chain indexing of token holders by owner. However it accomplishes this at the cost of gas efficiency due to a number a mappings and an array that must be maintained to accomplish this read functionality, which must be updated upon every transfer and mint. Ultimately, this functionality is better indexed off-chain using event logs, which can always be validated on-chain by checking the owner of a token id, which is already built into the ERC721 standard.

# ERC721Wrapper Pattern

ERC721Wrapper is another optional ERC721 extension, which provides functionality for wrapping ERC721 assets into parallel assets that may contain additional functionality not present in the origin asset. One common implementation of the ERC721Wrapper, which is suggested in the OpenZeppelin's implementation contract, is to wrapper an ERC721 token with ERC721Votes to cast an NFT into a governance token that could be used to participate in DAO governance.

Use cases:
- Cast NFT into a governance token
- Disassociate an NFT from royalty obligations
- Bridge an NFT to another blockchain

# NFT Metadata and Marketplaces


