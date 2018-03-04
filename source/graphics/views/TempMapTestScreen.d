module graphics.views.TempMapTestScreen;

import d2d;
import graphics.components.InvPanel;
import graphics.components.Minimap;
import graphics.Constants;
import logic.item.Inventory;
import logic.world.GameWorld;

/**
 * Temporary
 * TODO: delete
 */
class TempMapTestScreen : Screen {

    bool inventoryActive; ///Whether or not the inventory should be drawn
    InvPanel inventory; ///The inventory panel contained

    this(Display display) {
        super(display);
        this.components ~= new Minimap(display, new iRectangle(0, 0, 1600,
                900), new GameWorld(20));
        this.inventory = new InvPanel(display, new iRectangle(100, 100, 500, 400), 
                new Inventory(false, null, [null, null, null, null, null, null, null, null, null, null, null, null]));
    }

    /**
     * Handles keyboard and mouse events
     */
    void handleEvent(SDL_Event event) {
        if(event.type == SDL_KEYDOWN) {
            if(event.key.keysym.sym == SDLK_TAB) {
                this.inventoryActive = this.inventoryActive ^ true;
            }
        }
    }

    /**
     * Action taken every frame
     */
    override void onFrame() {
    }

    /**
     * Draw instructions for the window
     */
    override void draw() {
        if(this.inventoryActive) {
            this.inventory.draw();
        }
    }

}
