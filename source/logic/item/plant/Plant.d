module logic.item.plant.Plant;

import graphics.Constants;
import logic.item.Attribute;
import logic.item.Inventory;
import logic.item.Item;
import logic.Player;

/**
 * A plant class that encompasses the behaviour of ALL plants
 * Plant behaviour and attributes are determined mostly by their traits and also potentially partially from their species
 * TODO:
 */
class Plant : Item {

    package double _completion; ///How grown the plant is

    /**
     * Gets the name of the plant; based on its species
     */
    override @property string name() {
        return "";
    }

    /**
     * Gets the description of the plant; based on its species
     */
    override @property string description() {
        return "";
    }

    /**
     * The plant will always look like whatever species it is
     */
    override @property Image representation() {
        return Image.TempIcon;
    }

    /**
     * Gets how complete or mature the plant is
     */
    override @property double completion() {
        return this._completion;
    }

    /**
     * Gets the qualitative aspects of the plant
     */
    override @property Quality[] qualities() {
        return [];
    }

    /**
     * Necessary constructor for all items
     */
    this(Inventory container) {
        super(container);
    }

    override void onStep(Player actor) {}

    override void incrementalAction() {}

    override void mainAction(Player actor) {}

    override void onCreate(Player actor) {}

    override void onDestroy(Player actor) {}

}
