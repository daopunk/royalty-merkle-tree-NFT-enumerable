// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {TestHelper} from "test/TestHelper.t.sol";
import {ERC721EnumPlayer} from "src/ERC721EnumPlayer.sol";

contract EnumPlayer is TestHelper {
    function testMintAndFindSpecialItems() public {
        vm.startPrank(alice);
        assertEq(erc721EnumPlayer.getTokenId(), 20);
        for (uint256 i = 0; i < 20; i++) {
            erc721EnumPlayer.mint();
        }
        assertEq(erc721EnumPlayer.balanceOf(alice), 20);

        erc721EnumPlayer.getSpecialItems();
        vm.stopPrank();
    }
}
