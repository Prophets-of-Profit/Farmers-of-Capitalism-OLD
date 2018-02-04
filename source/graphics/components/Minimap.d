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
    int scrollValue; ///The total mouse wheel displacement
    iVector lastClicked; ///The last place the minimap was clicked.
    iVector center; ///The center of the minimap hex grid

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
        this.scrollValue = this.container.mouse.totalWheelDisplacement.y;
        this.center = this.location.center;
    }

    /**
     * Handles zoom function
     * TODO: fix reference point
     */
    void handleEvent(SDL_Event event) {
        if(!this.location.contains(this.container.mouse.location)) {
            return;
        }
        //Zooming
        immutable previousScroll = this.scrollValue;
        this.scrollValue = this.container.mouse.totalWheelDisplacement.y;
        this.sideLength += this.scrollValue - previousScroll;
        //Dragging
        if(this.container.mouse.allButtons[SDL_BUTTON_LEFT].isPressed()) {
            if(this.lastClicked is null) {
                this.lastClicked = new iVector(this.container.mouse.location.components);
            }
            this.center += new iVector(this.container.mouse.location.components) - lastClicked;
            this.lastClicked = new iVector(this.container.mouse.location.components);
        } else {
            this.lastClicked = null;
        } 
    }

    /**
     * Handles drawing the minimap
     */
    override void draw() {
        this.container.renderer.drawColor = PredefinedColor.GREEN;
        this.container.renderer.clear;
        this.container.renderer.fillRect(this.location, PredefinedColor.DARKGREY);
        foreach(coord; world.tiles.keys) {
            this.container.renderer.fillPolygon!6(new iPolygon!6(getCenterHexagonVertices(                
                new iVector(cast(int) (this.center.x + coord.q * hexBase.x * this.sideLength + coord.r * hexBase.x * this.sideLength / 2),
                cast(int) (this.center.y + coord.r * -1.5 * this.sideLength)),
                this.sideLength
            )), Color(cast(ubyte) ((abs(coord.q) * 255 / 2 + 100) % 255), cast(ubyte) ((abs(coord.r) * 255 / 2 + 100) % 255), cast(ubyte) ((abs(coord.s) * 255 / 2 + 100) % 255)));
        }
    }

}
