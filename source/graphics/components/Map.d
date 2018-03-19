module graphics.components.Map;

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
     * Gets the sidelength of a hex
     */
    @property int sideLength() {
        if (this.location.extent.x * hexBase.x > this.location.extent.y * hexBase.y) {
            return cast(int) (this.location.extent.y / (this.world.size + 1) / 3);
        } else {
            return cast(int) (this.location.extent.x / this.world.size / hexBase.x / 2);
        }
    }

    /**
     * Makes a minimap given the container and the world to draw
     */
    this(Display container, iRectangle location, GameWorld world) {
        super(container, location);
        this.mapTarget = new iRectangle(location);
        this.world = world;
        this.container.renderer.drawBlendMode = SDL_BLENDMODE_BLEND;
        this.updateTextures();
    }

    /**
     * Updates how the map looks
     */
    void updateTextures() {
        Surface m = new Surface(this.location.extent.x, this.location.extent.y, SDL_PIXELFORMAT_RGBA32);
        Surface colorSurface = new Surface(this.location.extent.x, this.location.extent.y, SDL_PIXELFORMAT_RGBA32);
        foreach (coord; this.world.tiles.keys) {
            iPolygon!6 hex = coord.asHex(new iVector(this.mapTarget.extent.x / 2, this.mapTarget.extent.y / 2), this.sideLength);
            iRectangle size = hex.bound;
            m.blit(images[this.world.tiles[coord].representation], null, size);
            colorSurface.fill!6(hex, this.getHexColor(coord));
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
        if (this.container.mouse.allButtons[SDL_BUTTON_LEFT].isPressed()) {
            if (this.lastClicked is null) {
                this.lastClicked = mouseLocation;
            }
            this.mapTarget.initialPoint = this.mapTarget.topLeft + mouseLocation - this.lastClicked;
            this.lastClicked = mouseLocation;
        } else {
            this.lastClicked = null;
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
     * Handles drawing the minimap
     */
    override void draw() {
        this.container.renderer.fill(this.location, PredefinedColor.BLUE); ///TODO: replace this with better background
        this.container.renderer.copy(this.map, this.mapTarget);
        if (this.selectedHex !is null) {
            this.container.renderer.fill!6(this.selectedHex.asHex(this.mapTarget.center, this.sideLength), this.selectedColor);
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

}
