// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {PriceConverter} from "contracts/PriceConverter.sol";

error NotOwner();

contract FundMe { 
    // function for sending transaction to contract whose value is less than 1 gwei
    // function tinyTip() public  payable {
    //     require(msg.value < 1e9, "tip can not be greater than 1 gwei");
    // }

    // The line using PriceConverter for uint256; in Solidity means that you are attaching the functions of the PriceConverter library to the uint256 data type, enabling you to call the library's functions as if they were methods on uint256 values.
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    
    mapping (address => uint256) public contributionCountMapping;

    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable {
        // require(getConversionRate(msg.value) >= MINIMUM_USD, "didn't send enough ether");
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough ether");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
        contributionCountMapping[msg.sender] ++ ;
    }

    function withdraw() public onlyOwner {
        // make all the amount funded by addresses as 0 
        require(msg.sender == i_owner, "Can't withdraw funds with other address than the i_owner");
        for(uint256 funderIndex; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0);

        // withdraw the funds

        // transfer
        // msg.sender is of type address where when we want to transfer money then we have to deal with payable addresses, therefore we have to convert 
        // it into payable address
        // payable(msg.sender).transfer(address(this).balance);
        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // call
        // (bool callSuccess, bytes memory dataReturned )=payable(msg.sender).call{value: address(this).balance}("");
         (bool callSuccess, )=payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");

    }

    modifier onlyOwner(){
        // require(msg.sender == i_owner, "Sender is not the i_owner");

        // custom errors
        if(msg.sender != i_owner){ revert NotOwner();}
        _;
    }

    receive() external payable {
        fund();
     }

     fallback() external payable { 
        fund();
     }


    
}