// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import { ISPythia } from "./interfaces/ISPythia.sol";
import { IMetaMorpho } from "./interfaces/IMetaMorpho.sol";
import "./lib/RiskyMath.sol";
using RiskyMath for uint256;

contract MorphoAllocator {
    ISPythia immutable SPYTHIA;
    address immutable TRUSTED_RELAYER;
    address immutable MORPHO_VAULT;

    
    constructor(ISPythia spythia, address relayer, address morphoVault) {
        SPYTHIA = spythia;
        TRUSTED_RELAYER = relayer;
        MORPHO_VAULT = morphoVault;
    }

    function checkAndReallocate(
        IMetaMorpho.MarketAllocation[] memory allocations,
        ISPythia.RiskData[] memory riskDatas,
        ISPythia.Signature[] memory signatures
    )
        public
    {
        require(allocations.length == riskDatas.length, "Invalid number of risk data");
        require(riskDatas.length == signatures.length, "Invalid number of signatures");

        for (uint i = 0; i < allocations.length; i++) {
            IMetaMorpho.MarketAllocation memory allocation = allocations[i];
            ISPythia.RiskData memory riskData = riskDatas[i];
            ISPythia.Signature memory signature = signatures[i];
            
            // first verify if the signature comes from the trusted relayer
            address signer = SPYTHIA.getSigner(riskData, signature.v, signature.r, signature.s);
            // invalid signature
            require(signer == TRUSTED_RELAYER, "invalid signer");

            // TODO check if risk parameters are OK
        }

        // call reallocate
        IMetaMorpho(MORPHO_VAULT).reallocate(allocations);
    }
}
