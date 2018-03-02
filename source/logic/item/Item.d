module logic.item.Item;

import graphics.Constants;
import logic.item.Inventory;
import logic.Player;

/**
 * The Platonic ideal of an item
 * Outlines what an item should be and do
 */
abstract class Item {

    Inventory container; ///Where the item is currently located

    @property Image representation(); ///How the item looks on the GUI
    @property double completion(); ///How close this item is to being "completed"; what completion entails is up to the item
    @property int movementCostChange(); ///What additive change in movement cost this item has when placed

    /**
     * All items need to have an inventory
     */
    this(Inventory container) {
        this.container = container;
    }

    void onStep(Player actor); ///What happens when the item is stepped on
    void incrementalAction(); ///What this item does every turn
    void mainAction(Player actor); ///What this item does when interacted with
    void onCreate(Player actor); ///What this item does when a player creates it
    void onDestroy(Player actor); ///What happens when a player destroys this item

}
