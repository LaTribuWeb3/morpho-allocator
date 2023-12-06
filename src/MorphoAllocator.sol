// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import { SPythia } from "./SPythia.sol";
import { IMetaMorpho } from "./interfaces/IMetaMorpho.sol";
import "./RiskyMath.sol";
using RiskyMath for uint256;

contract MorphoAllocator {
    SPythia immutable SPYTHIA;
    address immutable TRUSTED_RELAYER;
    address immutable MORPHO_VAULT;

    
    constructor(SPythia spythia, address relayer, address morphoVault) {
        SPYTHIA = spythia;
        TRUSTED_RELAYER = relayer;
        MORPHO_VAULT = morphoVault;
    }

    function checkAndReallocate(
        IMetaMorpho.MarketAllocation memory allocation,
        SPythia.RiskData memory riskData,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        public
    {
        // first verify if the signature comes from the trusted relayer
        address signer = SPYTHIA.getSigner(
            riskData,
            v,
            r,
            s
        );

        // invalid signature
        require(signer == TRUSTED_RELAYER, "invalid signer");

        // TODO check if risk parameters are OK ??

        // call reallocate
        IMetaMorpho.MarketAllocation[] memory allocations = new IMetaMorpho.MarketAllocation[](1);
        allocations[0] = allocation;

        IMetaMorpho(MORPHO_VAULT).reallocate(allocations);
    }
}
