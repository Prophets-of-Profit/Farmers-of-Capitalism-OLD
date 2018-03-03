module graphics.components.InvPanel;

import d2d;
import logic.item.Inventory;

/**
 * A component which displays an inventory to the screen
 */
class InvPanel : Component {

    iRectangle _location; ///The location and bounds of the inventory panel
    Texture texture; ///The actual texture to be drawn to the screen
    int rowLength; ///The number of items to display on each row
    Inventory _inventory; ///The inventory this component displays

    /**
     * Returns the location
     */
    override @property iRectangle location() {
        return this._location;
    }

    /**
     * Sets the location
     */
    override @property void location(iRectangle newLocation) {
        this._location = newLocation;
    }

    /**
     * Gets the contained inventory
     */
    @property Inventory inventory() {
        return this._inventory;
    }

    /**
     * Sets the contained inventory
     */
    @property void inventory(Inventory newInventory) {
        this._inventory = newInventory;
    }

    /**
     * Contructs a new inventory panel contained in the given display
     */
    this(Display container, Inventory inventory, int rowLength=5) {
        super(container);
        this._inventory = inventory;
        this.rowLength = rowLength;
    }

    /**
     * Handles the slider of the inventory panel if it is too large
     * TODO:
     */
    void handleEvent(SDL_Event event) {

    }

    /**
     * Displays the inventory to the screen
     * TODO:
     */
    override void draw() {

    }

}