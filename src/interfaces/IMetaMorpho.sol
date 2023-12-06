// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

interface IMetaMorpho {
    
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
    

    function reallocate(MarketAllocation[] calldata allocations) external;
}