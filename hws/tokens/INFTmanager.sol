// SPDX-License-Identifier: GPL-3.0-or-later

// This file is part of the http://github.com/aaronbloomfield/ccc repoistory,
// and is released under the GPL 3.0 license.

pragma solidity ^0.8.16;

import "./IERC721.sol";

interface INFTmanager is IERC721 {

    // This creates a NFT for `_to` with the pased file name `_uri`.  Note
    // that `_uri` is just the filename itself -- the prefix is set via
    // overriding _baseURI()
    function mintWithURI(address _to, string memory _uri) external returns (uint);

    // This also creates a NFT, but assumes `msg.sender` is who the NFT is
    // for; it can just call the previous function.
    function mintWithURI(string memory _uri) external returns (uint);

    // Functions to implement / override:
    // supportsInterface(): for the interfaces specified in the HW writeup
    // _baseURI(): the part of the full path name before the filename itself
    // tokenURI(): get the file name (with _baseURI() before it) for the passed NFT ID

}