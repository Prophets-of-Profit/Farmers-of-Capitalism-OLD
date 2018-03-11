module graphics.components.InvPanel;

import std.range;
import d2d;
import graphics.Constants;
import logic.item.Inventory;

/**
 * A component which displays an inventory to the screen
 */
class InvPanel : Button {

    Inventory inventory; ///The inventory this component displays
    immutable Color bgColor = Color(100, 100, 100); ///The background color of the inventory panel
    iVector selectedItem; ///The location of the user's last selected item
    immutable Color selectedItemColor = Color(150, 150, 255, 100);

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
        return this.location.w / this.columns; 
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
        super(container, location);
        this.inventory = inventory;
        this.selectedItem = new iVector(-1);
    }

    /**
     * Handles inventory slider (if applicable) and clicking on items in the inventory as well as hovering over items
     */
    override void handleEvent(SDL_Event event) {
        super.handleEvent(event);
        if (!this.isHovered) {
            return;
        }
        //TODO: mouse hover
        //TODO: scroll bar
    }

    /**
     * When the invpanel, is clicked, this looks for where it was clicked and sets the selected item
     */
    override void action() {
        foreach (r; 0..this.rows) {
            foreach (c; 0..this.columns) {
                if (this.locationOf(r, c).contains(this.container.mouse.location)) {
                    this.selectedItem.x = c;
                    this.selectedItem.y = r;
                    return;
                }
            }
        }
        this.selectedItem = -1;
    }

    /**
     * Returns the location of a box in the given colulmn and row
     */
    iRectangle locationOf(int row, int column) {
        return new iRectangle(
            this.location.x + column * this.itemDimension + this.padding / 2,
            this.location.y + row * this.itemDimension + this.padding / 2,
            this.itemDimension - this.padding,
            this.itemDimension - this.padding
        );
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
            iRectangle box = this.locationOf(currentRow, currentColumn);
            this.container.renderer.fillRect(box, PredefinedColor.WHITE);
            if (i < this.inventory.length) {
                this.container.renderer.copy(textures[this.inventory[i].representation], box);
            }
            if (currentColumn == this.selectedItem.x && currentRow == this.selectedItem.y) {
                this.container.renderer.fillRect(box, this.selectedItemColor);
            }
            this.container.renderer.drawRect(box, PredefinedColor.BLACK);
        }
    }

}