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
        this.components ~= new Minimap!2(display, new iRectangle(0, 0, 640,
                360), new GameWorld!2());
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