module logic.item.Item;

import logic.world.Coordinate;

/**
 * The Platonic ideal of an item
 * Outlines what an item should be and do
 */
interface Item {

    @property Coordinate location(); ///Where the item is
    @property bool isPlaced(); ///Whether the item is placed or not
    @property double completion(); ///How close this item is to being "completed"; what completion entails is up to the item
    @property int movementCostChange(); ///What additive change in movement cost this item has

    void onStep(); ///What happens when the item is stepped on TODO: take character in as a parameter
    void incrementalAction(); ///What this item does every turn
    void mainAction(); ///What this item does when interacted with TODO: take character in as a parameter
    void onDestroy(); ///What happens when a player destroys this item

}
