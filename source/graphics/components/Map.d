module graphics.components.Map;

import std.algorithm;
import std.array;
import std.math;
import std.parallelism;
import core.thread;
import d2d;
import graphics.Constants;
import logic.world.Coordinate;
import logic.world.GameWorld;
import logic.world.Hex;

/**
 * A component that renders the world in partial detail
 * TODO: correctly size hexes so there are no gaps in between them
 */
class Map : Button {

    GameWorld world; ///The world this minimap should represent
    Texture map; ///The actual map that gets scaled and shown
    iRectangle mapTarget; ///Where the map actually gets rendered; any part outside of location gets clipped
    int scrollValue; ///The total mouse wheel displacement
    iVector lastClicked; ///Where the mouse was last clicked
    immutable selectedColor = Color(255, 255, 255, 100); ///The overlay color for the selected hex
    Coordinate selectedHex; ///The hex that is currently selected

    /**
     * Gets the minimum sidelength of a hex
     */
    @property int minimumSideLength() {
        if (this.location.extent.x * hexBase.x > this.location.extent.y * hexBase.y) {
            return cast(int) (this.location.extent.y / (this.world.size + 1) / 3);
        } else {
            return cast(int) (this.location.extent.x / this.world.size / hexBase.x / 2);
        }
    }

    /**
     * Gets the sidelength of a single hex in the map
     */
    @property int sideLength() {
        //TODO: May be prone to rounding errors
        return cast(int) (this.mapTarget.extent.x / hexBase.x / (2 * this.world.size + 1));
    }

    /**
     * Scales the mapTarget based on side length
     */
    @property void sideLength(int newSL) {
        int newSideLength = clamp(newSL, this.minimumSideLength, minimapHexSize.y);
        double heightFactor = 1 + cast(double) this.world.size * 3 / 2;
        iVector center = new iVector(this.mapTarget.center);
        this.mapTarget = new iRectangle(
            cast(int) (center.x - newSideLength * (this.world.size + 0.5) * hexBase.x), 
            cast(int) (center.y - heightFactor * newSideLength),
            cast(int) (newSideLength * (2 * this.world.size + 1) * hexBase.x),
            cast(int) (2 * heightFactor * newSideLength)
        );
        //Correct for rounding in integer division
        this.mapTarget.initialPoint += center - this.mapTarget.center;
    }

    /**
     * Makes a minimap given the container and the world to draw
     */
    this(Display container, iRectangle location, GameWorld world) {
        super(container, location);
        this.world = world;
        this.container.renderer.drawBlendMode = SDL_BLENDMODE_BLEND;
        double heightFactor = 1 + cast(double) this.world.size * 3 / 2;
        iVector center = new iVector(this.location.center);
        this.mapTarget = new iRectangle(
            cast(int) (center.x - this.minimumSideLength * (this.world.size + 0.5) * hexBase.x), 
            cast(int) (center.y - heightFactor * this.minimumSideLength),
            cast(int) (this.minimumSideLength * (2 * this.world.size + 1) * hexBase.x),
            cast(int) (2 * heightFactor * this.minimumSideLength)
        );
        this.updateTextures();
    }

    /**
     * Updates how the map looks
     */
    void updateTextures() {
        Surface m = new Surface(this.mapTarget.extent.x, this.mapTarget.extent.y, SDL_PIXELFORMAT_RGBA32);
        Surface colorSurface = new Surface(this.location.extent.x, this.location.extent.y, SDL_PIXELFORMAT_RGBA32);
        foreach (coord; this.world.tiles.keys) {
            iPolygon!6 hex = coord.asHex(new iVector(this.mapTarget.extent.x / 2, this.mapTarget.extent.y / 2), this.sideLength);
            iRectangle size = hex.bound;
            m.blit(images[this.world.tiles[coord].representation], null, size);
            //colorSurface.fill!6(hex, this.getHexColor(coord));
        }
        m.blit(colorSurface, null, 0, 0);
        this.map = new Texture(m, this.container.renderer);
    }

    /**
     * Handles events on the minimap
     * Certain events will handle the minimap zooming while other events will select hexes
     */
    override void handleEvent(SDL_Event event) {
        super.handleEvent(event);
        iVector mouseLocation = this.container.mouse.location;
        if (!this.location.contains(mouseLocation)) {
            return;
        }
        //Dragging
        if (this.container.mouse.allButtons[SDL_BUTTON_LEFT].isPressed()) {
            if (this.lastClicked is null) {
                this.lastClicked = mouseLocation;
            }
            this.mapTarget.initialPoint = this.mapTarget.topLeft + mouseLocation - this.lastClicked;
            this.lastClicked = mouseLocation;
        } else {
            this.lastClicked = null;
        }
        //Zooming
        immutable previousScroll = this.scrollValue;
        this.scrollValue = this.container.mouse.totalWheelDisplacement.y;
        if (this.scrollValue != previousScroll) {
            this.scrollValue = this.container.mouse.totalWheelDisplacement.y;
            this.zoom(this.sideLength + this.scrollValue - previousScroll, mouseLocation);
        }
    }

    /**
     * What the map does when clicked
     */
    override void action() {
        foreach (coord; this.world.tiles.keys) {
            if (coord.asHex(this.mapTarget.center, this.sideLength).contains(this.container.mouse.location)) {
                this.selectedHex = coord;
            }
        }
    }

    /**
     * Fills a hex with a color
     */
    void fillHex(Coordinate coords, Color color) {
       this.container.renderer.fill!6(coords.asHex(this.mapTarget.center, this.sideLength), color); 
    }

    /**
     * Handles drawing the minimap
     */
    override void draw() {
        this.container.renderer.fill(this.location, PredefinedColor.BLUE); ///TODO: replace this with better background
        this.container.renderer.copy(this.map, this.mapTarget);
        if (this.selectedHex !is null) {
            this.fillHex(this.selectedHex, this.selectedColor);
            uint[Coordinate] distances = this.world.getDistances(this.selectedHex);
            Coordinate[] reachableTiles = distances.keys.filter!(a => distances[a] <= 4).array;
            foreach(tile; reachableTiles) {
                this.fillHex(tile, 
                    Color(
                        cast(ubyte) (max(255 - distances[tile] * 40, 0)),
                        0,
                        0,
                        150
                    )
                );
            }
            Coordinate end;
            foreach (coord; this.world.tiles.keys) {
                if (coord.asHex(this.mapTarget.center, this.sideLength).contains(this.container.mouse.location)) {
                    end = coord;
                }
            }
            if(end !is null) {
                Coordinate[] path = this.world.getShortestPath(this.selectedHex, end, distances);
                foreach(coord; path) {
                    this.fillHex(coord, Color(0, 0, 200, 150));
                }
            }
        }
    }

    /**
     * Returns the overlay color of a hexagon at a given coordinate
     */
    Color getHexColor(Coordinate coord) {
        return Color(cast(ubyte) ((abs(coord.q) * 64) % 255), cast(ubyte) ((abs(coord.q) * 64) % 255), cast(ubyte) ((abs(coord.q) * 64) % 255), 75);
        // return Color(cast(ubyte) (150 * (1 - this.world.tiles[coord].weather[ClimateFactor.TEMPERATURE] * 
        //             this.world.tiles[coord].weather[ClimateFactor.HUMIDITY])), 150,
        //             cast(ubyte) (150 * (1 - this.world.tiles[coord].weather[ClimateFactor.TEMPERATURE])));
    }

    /**
     * Scales the size of the map in such a way that the focus remains where it is absolutely
     */
    void zoom(int newSL, iVector focus) {
        int newSideLength = clamp(newSL, this.minimumSideLength, minimapHexSize.y);
        double heightFactor = 1 + cast(double) this.world.size * 3 / 2;
        double focusProportionX = cast(double) (focus.x - this.mapTarget.initialPoint.x) / this.mapTarget.extent.x;
        double focusProportionY = cast(double) (focus.y - this.mapTarget.initialPoint.y) / this.mapTarget.extent.y;
        double newWidth = newSideLength * (2 * this.world.size + 1) * hexBase.x;
        double newHeight = 2 * heightFactor * newSideLength;
        this.mapTarget = new iRectangle(
            cast(int) (focus.x - focusProportionX * newWidth), 
            cast(int) (focus.y - focusProportionY * newHeight),
            cast(int) (newWidth),
            cast(int) (newHeight)
        );
        //Correct for rounding in integer division
        this.mapTarget.initialPoint += focus - new iVector(
            this.mapTarget.initialPoint.x + cast(int) (focusProportionX * this.mapTarget.extent.x),
            this.mapTarget.initialPoint.y + cast(int) (focusProportionY * this.mapTarget.extent.y)
        );
    }

}
