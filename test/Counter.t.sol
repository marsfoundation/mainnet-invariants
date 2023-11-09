// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import { BoundedLpHandler } from "./LpHandler.sol";

import { IERC20 }      from "lib/erc20-helpers/src/interfaces/IERC20.sol";
import { ISavingsDai } from "lib/sdai/src/ISavingsDai.sol";

contract CounterTest is Test {

    BoundedLpHandler lpHandler;

    IERC20      dai  = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    ISavingsDai sDai = ISavingsDai(0x83F20F44975D03b1b09e64809B757c47f942BEeA);

    function setUp() public {
        vm.createSelectFork(getChain('mainnet').rpcUrl, 18_535_000);

        lpHandler = new BoundedLpHandler(50);

        excludeContract(address(dai));
        excludeContract(address(sDai));
    }

    function invariant_1() public {
        assertTrue(true);
    }

    function invariant_call_summary() external view {
        console.log("\nCall Summary\n");
        console.log("boundedLp.addLp         ", lpHandler.numCalls("boundedLp.addLp"));
        console.log("boundedLp.deposit       ", lpHandler.numCalls("boundedLp.deposit"));
        console.log("boundedLp.transfer      ", lpHandler.numCalls("boundedLp.transfer"));
        console.log("------------------");
        console.log(
            "Sum",
            lpHandler.numCalls("boundedLp.addLp") +
            lpHandler.numCalls("boundedLp.deposit") +
            lpHandler.numCalls("boundedLp.transfer")
        );
    }
}
