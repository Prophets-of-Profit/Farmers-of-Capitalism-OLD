module graphics.components.InvPanel;

import std.range;
import d2d;
import graphics.Constants;
import logic.item.Inventory;

/**
 * A component which displays an inventory to the screen
 */
class InvPanel : Component {

    private iRectangle _location; ///The location and bounds of the inventory panel
    Inventory inventory; ///The inventory this component displays
    immutable Color bgColor = Color(100, 100, 100); ///The background color of the inventory panel

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
     * Gets how much space goes between each box
     */
    @property int padding() {
        return cast(int) (this.location.dimensions.magnitude / 100);
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
        return 5;
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
     */
    override void draw() {
        this.container.renderer.fillRect(this.location, this.bgColor);
        this.container.renderer.drawRect(this.location, PredefinedColor.BLACK);
        foreach(i; iota(0, this.inventory.maxItems < 0? this.inventory.length + 1 : this.inventory.maxItems)) {
            immutable currentColumn = cast(int) i % this.columns;
            immutable currentRow = cast(int) i / this.columns;
            iRectangle bgBox = new iRectangle(
                this.location.x + currentColumn * this.itemDimension + this.padding / 2,
                this.location.y + currentRow * this.itemDimension + this.padding / 2,
                this.itemDimension - this.padding,
                this.itemDimension - this.padding
            );
            if (i >= this.inventory.length) { 
                this.container.renderer.fillRect(bgBox, PredefinedColor.WHITE);
            } else {
                this.container.renderer.copy(textures[this.inventory[i].representation], bgBox);
            }
            this.container.renderer.drawRect(bgBox, PredefinedColor.BLACK);
        }
    }

}