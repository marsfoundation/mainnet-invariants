// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "forge-std/Test.sol";

import { IERC20 }      from "lib/erc20-helpers/src/interfaces/IERC20.sol";
import { ISavingsDai } from "lib/sdai/src/ISavingsDai.sol";

contract UnboundedLpHandler is Test {

    address public currentLp;

    uint256 public numLps;
    uint256 public maxLps;

    address[] public lps;

    mapping(address => bool) public isLp;

    mapping(bytes32 => uint256) public numCalls;

    IERC20      dai  = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    ISavingsDai sDai = ISavingsDai(0x83F20F44975D03b1b09e64809B757c47f942BEeA);

    uint256 public sumBalance;

    modifier useRandomLp(uint256 lpIndex) {
        currentLp = lps[bound(lpIndex, 0, lps.length - 1)];

        vm.startPrank(currentLp);
        _;
        vm.stopPrank();
    }

    constructor(uint256 maxLps_) {
        lps.push(address(1));
        numLps = 1;
        isLp[address(1)] = true;

        maxLps = maxLps_;
    }

    function addLp(address lp) public virtual {
        // numCalls["unboundedLp.addLp"]++;

        // // If the max has been reached, don't add LP.
        // if (numLps == maxLps) {
        //     numCalls["unboundedLp.addLp.maxReached"]++;
        //     return;
        // }

        // // If the LP address is a duplicate, don't add LP.
        // if (isLp[lp]) {
        //     numCalls["unboundedLp.addLp.duplicateLp"]++;
        //     return;
        // }

        // lps.push(lp);
        // numLps++;

        // isLp[lp] = true;  // Prevent duplicate LP addresses in array
    }

    function deposit(uint256 assets, uint256 lpIndex) useRandomLp(lpIndex) public virtual {
        // numCalls["unboundedLp.deposit"]++;

        // deal(address(dai), currentLp, assets);

        // dai.approve(address(sDai), assets);

        // uint256 shares = sDai.deposit(assets, currentLp);

        // sumBalance += shares;
    }

    function transfer(uint256 assets, address receiver, uint256 lpIndex, uint256 receiverLpIndex) useRandomLp(lpIndex) public virtual {
        // numCalls["unboundedLp.transfer"]++;

        // // If the max has been reached, or the address is a duplicate, use an existing LP.
        // // Else, add a new LP.
        // if (numLps == maxLps || isLp[receiver]) {
        //     receiver = lps[bound(receiverLpIndex, 0, lps.length - 1)];
        // } else {
        //     lps.push(receiver);
        //     isLp[receiver] = true;
        //     numLps++;
        // }

        // sDai.transfer(receiver, assets);
    }

}

contract BoundedLpHandler is UnboundedLpHandler {

    constructor(uint256 maxLps_) UnboundedLpHandler(maxLps_) { }

    function addLp(address lp) public override {
        // numCalls["boundedLp.addLp"]++;

        // if (lp == address(0)) {
        //     numCalls["boundedLp.addLp.zeroAddress"]++;
        //     return;
        // }

        // super.addLp(lp);
    }

    function deposit(uint256 assets, uint256 lpIndex) public override {
        numCalls["boundedLp.deposit"]++;

        uint256 totalSupply = sDai.totalSupply();

        uint256 minDeposit = totalSupply == 0 ? 1 : sDai.totalAssets() / totalSupply + 1;

        assets = bound(assets, minDeposit, 1e36);

        super.deposit(assets, lpIndex);
    }

    function transfer(uint256 assets, address receiver, uint256 lpIndex, uint256 receiverLpIndex) public override {
        // numCalls["boundedLp.transfer"]++;

        // // If receiver is address(0), use an existing LP address.
        // if (receiver == address(0)) {
        //     receiver = lps[bound(receiverLpIndex, 0, lps.length - 1)];
        // }

        // // Calculate current LP that will be used in unbounded transfer.
        // address currentLp = lps[bound(lpIndex, 0, lps.length - 1)];

        // assets = bound(assets, 0, sDai.balanceOf(currentLp));

        // super.transfer(assets, receiver, lpIndex, receiverLpIndex);
    }

}
