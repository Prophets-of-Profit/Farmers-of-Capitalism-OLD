module logic.item.plant.Plant;

import logic.item.Inventory;
import logic.item.Item;

/**
 * A plant class that encompasses the behaviour of ALL plants
 */
class Plant : Item {

    package double _completion; ///How grown the plant is

    /**
     * Necessary constructor for all items
     */
    this(Inventory container) {
        super(container);
    }

    /**
     * Gets how complete or mature the plant is
     */
    override @property double completion() {
        return this._completion;
    }

    //TODO: actually make; until the item methods are made, this won't compile    

}
