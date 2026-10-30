// unit
// integrations
// forked
// staging <- run tests on mainnet or tetsnet

// fuzzing
// stateful fuzz
// stateless fuzz
// formal verification

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Test} from "forge-std/Test.sol";
import {FundSubscription} from "../../script/Interactions.s.sol";
import {LinkToken} from "../mocks/LinkToken.sol";

contract InteractionsTest is Test {
    FundSubscription fundSubscription;
    LinkToken linkToken;

    address account = makeAddr("account");
    address coordinator = makeAddr("coordinator");

    function setUp() public {
        fundSubscription = new FundSubscription();
        linkToken = new LinkToken();
        linkToken.mint(account, 10 ether);
    }

    function testLinkTokenTransferAndCall() public {
        vm.prank(account);

        bool success = linkToken.transferAndCall(coordinator, 3 ether, abi.encode(uint256(1)));

        assertTrue(success);
        assertEq(linkToken.balanceOf(coordinator), 3 ether);
        assertEq(linkToken.balanceOf(account), 7 ether);
    }
}
