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
    Texture texture; ///The actual texture to be drawn to the screen
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
        return cast(int) this.inventory.items.length / this.columns + ((this.inventory.items.length % this.columns == 0)? 0 : 1);
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
        this.updateTexture();
        this.container.renderer.copy(this.texture, this.location);
    }

    /**
     * Updates the texture to be drawn
     * For internal use only
     * TODO: Add slider and item drawing and clean up code
     */
    private void updateTexture() {
        import std.stdio;
        Surface inv = new Surface(this.location.w, this.location.h);
        inv.fillRect(null, Color(130, 150, 130));
        for(int i = 0; i < this.rows - 1; i++) {
            for(int j = 0; j < this.columns; j++) {
                inv.blit(images[Image.InvBox], null, 
                        new iRectangle(j * this.itemDimension, i * this.itemDimension, 
                        this.itemDimension, this.itemDimension));
            }
        }
        for(int k = 0; k < this.inventory.items.length % this.columns; k++){
            inv.blit(images[Image.InvBox], null, 
                    new iRectangle(k * this.itemDimension, (this.rows -  1) * this.itemDimension, 
                    this.itemDimension, this.itemDimension));
        }
        this.texture = new Texture(inv, this.container.renderer);
    }

}