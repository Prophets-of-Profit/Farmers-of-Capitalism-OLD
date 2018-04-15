module logic.item.Item;

import graphics.Constants;
import logic.actor.Actor;
import logic.item.Attribute;
import logic.item.Inventory;

/**
 * The Platonic ideal of an item
 * Outlines what an item should be and do
 */
abstract class Item {

    package Inventory container; ///Where the item is currently located

    @property string name(); ///The name of the item; shown to the players
    @property string description(); ///The description of the item; shown to the players
    @property Image representation(); ///How the item looks on the GUI
    @property double completion(); ///How close this item is to being "completed"; what completion entails is up to the item
    @property Quality[] qualities(); ///What qualititave traits the item has; is used in determining item value

    void onStep(Actor actor); ///What happens when the item is stepped on
    void incrementalAction(); ///What this item does every turn
    void mainAction(Actor actor); ///What this item does when interacted with
    void onCreate(Actor actor); ///What this item does when a player creates it
    void onDestroy(Actor actor); ///What happens when a player destroys this item

}
