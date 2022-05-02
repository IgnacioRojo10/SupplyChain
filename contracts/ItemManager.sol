// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.1;
 import "./Ownable.sol";
 import "./Item.sol";
contract ItemManager is Ownable{

    enum SupplyChainState{Created, Paid, Delivered}

    struct S__Item {
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state; 
    }

    mapping(uint => S__Item) public items;
    uint itemIndex;

    event SupplyChainStep(uint _itemIndex, uint _step, address _itemAddress);

    function createItem(string memory _identifier, uint _itemPrice) public onlyOwner{
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(item)); //Why do we add uint in the second variable? if we already stated in the event that it is uint?
        itemIndex++; 
    }

    function triggerPayment(uint _itemIndex) public payable {
        require(items[_itemIndex]._itemPrice == msg.value, "Not enough money");
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in the chain");
        items[_itemIndex]._state = SupplyChainState.Paid;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }

    function triggerDelivery(uint _itemIndex) public onlyOwner{
        require(items[_itemIndex]._state == SupplyChainState.Paid, "Item is further in the chain");
        items[_itemIndex]._state = SupplyChainState.Delivered;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }


}