module graphics.components.InvPanel;

import d2d;
import graphics.Constants;
import logic.item.Inventory;

immutable int itemsPerRow = 10; ///A constant value of how many items to display per horizontal row

/**
 * A component which displays an inventory to the screen
 */
class InvPanel : Component {

    private iRectangle _location; ///The location and bounds of the inventory panel
    Inventory inventory; ///The inventory this component displays

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
     * Gets the sidelength for how wide/tall each item image should be
     * Is based off of the dimensions of this panel
     */
    @property int itemDimension() {
        return this._location.w / this.columns; 
    }

    /**
     * Gets how many columns of items this panel can display
     */
    @property int columns() {
        return itemsPerRow; //TODO: make this modular and not based on constant
    }

    /**
     * Gets how many rows of items this panel will display
     * Is based off of the number of columns and number of items
     */
    @property int rows() {
        return cast(int) this.inventory.length / this.columns + ((this.inventory.length % this.columns == 0)? 0 : 1);
    }

    /**
     * Returns whether a slider is needed to navigate through all the items in the inventory
     * Is based off of how many rows are needed and the display size of all items
     */
    @property bool needsSlider() {
        return this.rows * itemDimension > this.location.h;
    }

    /**
     * Contructs a new inventory panel contained in the given display
     */
    this(Display container, iRectangle location, Inventory inventory) {
        super(container);
        this.inventory = inventory;
        this._location = location;
    }

    /**
     * Handles inventory slider (if applicable) and clicking on items in the inventory as well as hovering over items
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