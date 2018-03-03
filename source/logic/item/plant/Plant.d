module logic.item.plant.Plant;

import graphics.Constants;
import logic.item.Inventory;
import logic.item.Item;
import logic.Player;

/**
 * A plant class that encompasses the behaviour of ALL plants
 */
class Plant : Item {

    package double _completion; ///How grown the plant is

    /**
     * The plant will always look like whatever species it is
     * TODO:
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
