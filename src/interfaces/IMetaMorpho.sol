// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

interface IMetaMorpho {
    // Assuming MarketAllocation is a struct defined like this:
    // You should replace this with the actual structure of MarketAllocation.
    struct MarketAllocation {
        /// @notice The market to allocate.
        MarketParams marketParams;
        /// @notice The amount of assets to allocate.
        uint256 assets;
    }

    struct MarketParams {
        address loanToken;
        address collateralToken;
        address oracle;
        address irm;
        uint256 lltv;
    }

    // Function declaration
    function reallocate(MarketAllocation[] calldata allocations) external;
}