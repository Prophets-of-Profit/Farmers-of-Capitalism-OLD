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
     * Handles zoom function
     * TODO: fix reference point
     */
    void handleEvent(SDL_Event event) {
        if (!this.location.contains(this.container.mouse.location)) {
            return;
        }
        iVector mouseLocation = new iVector(this.container.mouse.location.components);
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
            //Occasionally the focal point will move very slightly; this is likely due to minor rounding errors
            //TODO: fix
            this.sideLength = clamp(this.sideLength + (this.scrollValue - previousScroll), minimapHexSize.x, minimapHexSize.y);
            if(this.centerDistance != new iVector(0,0)) this.centerDistance.magnitude = this.centerDistance.magnitude * this.sideLength / oldSideLength;
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
                iPolygon!6 polygon = new iPolygon!6(getCenterHexagonVertices(                
                    cast(iVector) new dVector(
                        (this.center.x + coord.q * hexBase.x * this.sideLength + coord.r * hexBase.x * this.sideLength / 2),
                        (this.center.y + coord.r * -1.5 * this.sideLength)
                    ),
                    this.sideLength));
                if(polygon.contains(mouseLocation)) coordinate = coord; 
            }
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
        /**
         * A method that returns a coordinate as a hexagon polygon
         */
        iPolygon!6 hexVertices(Coordinate coord) {
            return new iPolygon!6(
                getCenterHexagonVertices(                
                    cast(iVector) new dVector(
                        (this.center.x + coord.q * hexBase.x * this.sideLength + coord.r * hexBase.x * this.sideLength / 2),
                        (this.center.y + coord.r * -1.5 * this.sideLength)
                    ),
                    this.sideLength
                )
            );
        }
        foreach(coord; world.tiles.keys) {
            //Draw all the hexes
            iPolygon!6 polygon = hexVertices(coord);
            iRectangle bounds = polygon.bound;
            this.container.renderer.copy(new Texture(images[world.tiles[coord].image], this.container.renderer), bounds);
            this.container.renderer.fillPolygon!6(polygon, this.getHexColor(coord));
        }
        //Highlight the selected hex
        if(this.selectedHex !is null) {
            this.container.renderer.fillPolygon!6(hexVertices(this.selectedHex), this.selectedColor);
        }
    }

    /**
     * Returns the color of a hexagon at a given coordinate
     */
    Color getHexColor(Coordinate coord) {
        return Color(cast(ubyte) ((abs(coord.q) * 64) % 255), cast(ubyte) ((abs(coord.q) * 64) % 255), cast(ubyte) ((abs(coord.q) * 64) % 255), 50);
    }

}
