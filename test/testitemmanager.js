const ItemManager = artifacts.require("./ItemManager.sol");

contract("ItemManager", accounts => {
    it("....", function() {
        const itemManagerInstance = await ItemManager.deployed();
        const itemName = "test1";
        const itemPrice = 500;

        const result = await itemManagerInstance.createItem(itemName, itemPrice, {from: accounts[0]});
        assert.equal(result.logs[0].args._itemIndex, 0, "Its not the first item");

        const item = await itemManagerInstance.item(0);
        assert.equal(item._identifier, itemName, "The identifier is different");
    }) //it should do this..
}); 