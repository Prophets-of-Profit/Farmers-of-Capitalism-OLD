module graphics.views.TempMapTestScreen;

import d2d;
import graphics.components.Minimap;
import graphics.Constants;
import logic.world.GameWorld;

/**
 * Temporary
 * TODO: delete
 */
class TempMapTestScreen : Screen {

    this(Display display) {
        super(display);
        this.components ~= new Minimap!(30)(display, new iRectangle(0, 0, 1600,
                900), new GameWorld!30());
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
