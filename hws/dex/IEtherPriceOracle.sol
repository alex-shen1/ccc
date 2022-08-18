// SPDX-License-Identifier: GPL-3.0-or-later

// This file is part of the http://github.com/aaronbloomfield/ccc repoistory,
// and is released under the GPL 3.0 license.

pragma solidity ^0.8.7;

import "./IERC165.sol";

interface IEtherPriceOracle is IERC165 {

	function getEtherPriceInCents() external view returns (uint);

}
