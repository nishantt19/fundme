// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
  function getPrice() internal view returns(uint256){
       AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
       (,int256 price, , , )= priceFeed.latestRoundData();
       return uint256(price* 1e10);
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256){
        // first we will get the ethereum price in usd which we can get from the getPrice function
        uint256 ethPrice = getPrice();
        // then we will convert our eth amount into usd by multiplying the ethamount with ethprice and then divide it 
        // by 18 decimal places as both ethprice and ethamount have 18 which will give us 36 and we only want 18
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

//    1. Implement a function `contributionCount` to monitor how many times a user calls the `fund` function to send money to the contract.
    // function contributionCount(address user) internal view returns (uint256){
    //     return contributionCountMapping[user];
    // }

    // 1. Create a function `convertUsdToEth(uint256 usdAmount, uint256 ethPrice) public returns(uint256)`, that converts a given amount of USD to its equivalent value in ETH.
    // function convertUsdToEth(uint256 usdAmount, uint256 ethPrice) internal pure returns (uint256){
    //     uint256 ethAmountConverted = (usdAmount * 1e18) / ethPrice;
    //     return ethAmountConverted;
    // }
}