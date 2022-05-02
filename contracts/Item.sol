// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.1;
import "./ItemManager.sol";
contract Item { //This contract is to store the address of each item, so we just need to send the address to the customer and they can deposit.
    uint public priceInWei;
    uint public pricePaid;
    uint public index;

    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) public {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable {
        require(pricePaid == 0, "Item is paid already");
        require(priceInWei == msg.value, "Only Full payments allowed");
        pricePaid += msg.value;
        (bool success, ) = address(parentContract).call.value(msg.value)(abi.encodeWithSignature("triggerPayment(uint256",index)); //call value function is low level. More dangerous because doesnt give exceptions. Return boolean.
        require(success, "The transaction wasn't successful, canceling");
    }
}