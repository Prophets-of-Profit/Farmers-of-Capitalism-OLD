module graphics.components.Minimap;

import std.math;
import std.parallelism;
import d2d;
import graphics.Constants;
import logic.world.GameWorld;
import logic.world.Hex;

/**
 * A component that renders the world in partial detail
 */
class Minimap(uint worldSize) : Component {

    GameWorld!worldSize world; ///The world this minimap should represent
    iRectangle _location; ///Where the component is
    int sideLength = 20; ///The length of the hex sides; used in zooming

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
        this.container.renderer.drawColor = PredefinedColor.GREEN;
        this.container.renderer.clear;
        this.container.renderer.fillRect(this.location, PredefinedColor.DARKGREY);
        iVector center = this.location.center;
        foreach(coord; world.tiles.keys) {
            this.container.renderer.fillPolygon!6(new iPolygon!6(getCenterHexagonVertices(                
                new iVector(cast(int) (center.x - this.sideLength / 2 + coord.q * hexBase.x * this.sideLength + coord.r * hexBase.x * this.sideLength / 2),
                cast(int) (center.y - this.sideLength / 2 + coord.r * -1.5 * this.sideLength)),
                20
            )), Color(cast(ubyte) ((abs(coord.q) * 255 / 2 + 100) % 255), cast(ubyte) ((abs(coord.r) * 255 / 2 + 100) % 255), cast(ubyte) ((abs(coord.s) * 255 / 2 + 100) % 255)));
        }
    }

}
