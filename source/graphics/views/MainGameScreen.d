module graphics.views.MainGameScreen;

import d2d;
import graphics.components.InvPanel;
import graphics.components.Map;
import graphics.Constants;
import logic.item.Inventory;
import logic.item.plant;
import logic.world.GameWorld;

/**
 * The site of the main UI
 */
class MainGameScreen : Screen {

    /**
     * Constructor for the main game screen
     * Organizes the components into locations 
     */
    this(Display display, GameWorld world) { 
        super(display);
        this.components ~= new Map(display, new iRectangle(0, 50, 1300, 700), world);
        this.components ~= new InvPanel(display, new iRectangle(1300, 50, 300, 700), null);
    }

    /**
     * Handles keyboard and mouse events
     */
    void handleEvent(SDL_Event event) {
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
    }
}