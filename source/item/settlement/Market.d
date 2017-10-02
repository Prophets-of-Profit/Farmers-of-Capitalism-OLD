module item.settlement.Market;

import std.array;
import std.algorithm;
import std.conv;
import std.math;

import government.Government;
import item.Inventory;
import item.Item;
import world.Range;

class Market {

    Inventory!Item inventory = new Inventory!Item();       ///The items circulating through the Market
    Range!double usefulnessDemand = Range!double(0, 1);    ///The weight for usefulness when calculating demand
    Range!double sizeDemand = Range!double(0, 1);          ///The weight for size when calculating demand
    Range!double colorDemand = Range!double(0, 1);         ///The weight for size when calculating demand
    int[] demandedColor;                                   ///The color the proletariat desires
    int largestSeenSize;                                   ///The biggest thing the market has ever seen :O
    Government controller;                                 ///The government associated with the Market

    /**
     * The constructor for Market
     * Params:
     *      controller = the government to associate the Market with
     */
    this(Government government){
        controller = government;
    }

    /**
     * Gets the monetary value of an item based on the market's supply, demand, and governmental regulations
     * Params:
     *      item = item to get value of
     */
    long getValue(Item item){
        int[] itemColor = item.getColor();
        int itemSize = item.getSize();
        double colorValue = 1 - sqrt(((demandedColor[0] - itemColor[0]).to!float.pow(2) + (demandedColor[1] - itemColor[1]).to!float.pow(2) + (demandedColor[2] - itemColor[2]).to!float.pow(2))/195075/* 3x255^2 */);
        double sizeValue = itemSize.to!double / largestSeenSize;
        largestSeenSize = (itemSize > largestSeenSize)? itemSize : largestSeenSize;
        double objectiveValue = usefulnessDemand * item.getUsefulness() + sizeDemand * sizeValue + colorDemand * colorValue;
        return (objectiveValue * controller.baseItemCost * (1 - getSupply(item))).to!long;
    }

    /**
     * Returns the amount of items similar to the input contained in the market
     * Params:
     *      item = item to get supply of
     */
    double getSupply(Item item){
        return inventory.items.filter!(a => item.isSimilarTo(a)).array.length / inventory.items.length.to!double;
    }

}
