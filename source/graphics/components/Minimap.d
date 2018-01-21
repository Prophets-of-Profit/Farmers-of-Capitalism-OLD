module graphics.components.Minimap;

import d2d;
import logic.world.GameWorld;

/**
 * A component that renders the world in partial detail
 */
class Minimap(uint worldSize) : Component {

    GameWorld!worldSize world; ///The world this minimap should represent
    iRectangle _location; ///Where the component is

    /**
     * Sets the minimap's location
     */
    override @property void location(iRectangle newLoc) {
        this._location = newLoc;
    }

    /**
     * Gets the minimap's location
     */
    override @property iRectangle location() {
        return this._location;
    }

    /**
     * Makes a minimap given the container and the world to draw
     */
    this(Display container, iRectangle location, GameWorld!worldSize world) {
        super(container);
        this._location = location;
        this.world = world;
    }

    /**
     * Minimaps don't do anything with events
     */
    void handleEvent(SDL_Event event) {
    }

    /**
     * Handles drawing the minimap
     */
    override void draw() {
        //TODO:
        this.container.window.renderer.fillRect(this.location, PredefinedColor.GREEN);
    }

}
