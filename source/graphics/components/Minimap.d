module graphics.components.Minimap;

import std.algorithm;
import std.math;
import std.parallelism;
import d2d;
import graphics.Constants;
import logic.world.Coordinate;
import logic.world.GameWorld;
import logic.world.Hex;

/**
 * A component that renders the world in partial detail
 * TODO: make the hexes a buncha buttons so they can handle clicking correctly and have onClick actions
 */
class Minimap : Component {

    GameWorld world; ///The world this minimap should represent
    iRectangle _location; ///Where the component is
    int sideLength = 20; ///The length of the hex sides; used in zooming
    int scrollValue; ///The total mouse wheel displacement
    iVector lastClicked; ///The last place the minimap was clicked.
    iVector center; ///The center of the minimap hex grid
    iVector centerDistance; ///The distance from the zoom focal point to the center
    immutable selectedColor = Color(255, 255, 255, 100); ///The overlay color for the selected hex
    Coordinate selectedHex; ///The hex tile that is selected
    bool isBeingResized; ///Whether the minimap is being resized

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
    this(Display container, iRectangle location, GameWorld world) {
        super(container);
        this._location = location;
        this.world = world;
        this.scrollValue = this.container.mouse.totalWheelDisplacement.y;
        this.center = this.location.center;
        this.container.renderer.drawBlendMode = SDL_BLENDMODE_BLEND;
    }

    /**
     * Handles events on the minimap
     * Certain events will handle the minimap zooming while other events will select hexes
     */
    void handleEvent(SDL_Event event) {
        iVector mouseLocation = new iVector(this.container.mouse.location.components);
        //Adjust minimap size
        if(((mouseLocation - this.location.bottomRight).magnitude <= 25 
        && this.container.mouse.allButtons[SDL_BUTTON_LEFT].isPressed()) 
        || this.isBeingResized) {
            this.location = new iRectangle(this.location.x, this.location.y, mouseLocation.x - this.location.x, mouseLocation.y - this.location.y);
            this.isBeingResized = this.container.mouse.allButtons[SDL_BUTTON_LEFT].isPressed();
        }
        //The following code only executes if the mouse is within the minimap rectangle
        if (!this.location.contains(mouseLocation)) {
            return;
        }
        //Zooming
        immutable previousScroll = this.scrollValue;
        this.scrollValue = this.container.mouse.totalWheelDisplacement.y;
        if (this.scrollValue != previousScroll) {
            if (this.centerDistance is null) {
                this.centerDistance = this.center - mouseLocation;
            }
            this.scrollValue = this.container.mouse.totalWheelDisplacement.y;
            immutable oldSideLength = this.sideLength;
            this.center -= this.centerDistance;
            //TODO: Occasionally the focal point will move very slightly; this is likely due to minor rounding errors
            this.sideLength = clamp(this.sideLength + (this.scrollValue - previousScroll), minimapHexSize.x, minimapHexSize.y);
            if (this.centerDistance != new iVector(0,0)) {
                this.centerDistance.magnitude = this.centerDistance.magnitude * this.sideLength / oldSideLength;
            }
            this.center = mouseLocation + this.centerDistance;
        } else {
            this.centerDistance = null;
        }
        //Dragging
        if (this.container.mouse.allButtons[SDL_BUTTON_LEFT].isPressed()) {
            if (this.lastClicked is null) {
                this.lastClicked = mouseLocation;
            }
            this.center += mouseLocation - lastClicked;
            this.lastClicked = mouseLocation;
            //Highlight when clicked inside a hex
            Coordinate coordinate;
            foreach(coord; world.tiles.keys) {
                iPolygon!6 polygon = coord.asHex(this.center, this.sideLength);
                if(polygon.contains(mouseLocation)){
                    coordinate = coord;
                } 
            }
            //TODO: see above todo about making all hexes buttons
            this.selectedHex = coordinate;
        } else {
            this.lastClicked = null;
        } 
    }

    /**
     * Handles drawing the minimap
     */
    override void draw() {
        this.container.renderer.clear;
        this.container.renderer.fillRect(this.location, PredefinedColor.DARKGREY);
        foreach(coord; world.tiles.keys) {
            //Draw all the hexes
            iPolygon!6 polygon = coord.asHex(this.center, this.sideLength);
            iRectangle bounds = polygon.bound;
            this.container.renderer.copy(textures[this.world.tiles[coord].representation], bounds);
            this.container.renderer.fillPolygon!6(coord.asHex(this.center, this.sideLength), this.getHexColor(coord));
        }
        //Highlight the selected hex
        if(this.selectedHex !is null) {
            this.container.renderer.fillPolygon!6(this.selectedHex.asHex(this.center, this.sideLength), this.selectedColor);
        }
    }

    /**
     * Returns the overlay color of a hexagon at a given coordinate
     */
    Color getHexColor(Coordinate coord) {
        return Color(cast(ubyte) ((abs(coord.q) * 64) % 255), cast(ubyte) ((abs(coord.q) * 64) % 255), cast(ubyte) ((abs(coord.q) * 64) % 255), 50);
    }

}
