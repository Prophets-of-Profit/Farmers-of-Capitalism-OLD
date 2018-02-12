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
    Texture map; ///The actual map that gets scaled and shown
    iRectangle _location; ///Where the component is
    int sideLength = 20; ///The length of the hex sides; used in zooming
    int scrollValue; ///The total mouse wheel displacement
    iVector center; ///The center of the minimap hex grid
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
        this.center = this.location.center;
        this.container.renderer.drawBlendMode = SDL_BLENDMODE_BLEND;
        this.updateTextures();
    }

    /**
     * Updates how the map looks
     */
    void updateTextures() {
        Surface m = new Surface(this.location.w, this.location.h, SDL_PIXELFORMAT_RGBA32);
        foreach (coord; this.world.tiles.keys) {
            m.blit(images[this.world.tiles[coord].representation], null, coord.asHex(this.center, this.sideLength).bound);
        }
        this.map = new Texture(m, this.container.renderer);
    }

    /**
     * Handles events on the minimap
     * Certain events will handle the minimap zooming while other events will select hexes
     */
    void handleEvent(SDL_Event event) {
        
    }

    /**
     * Handles drawing the minimap
     */
    override void draw() {
        this.container.renderer.copy(this.map, this.location);
    }

    /**
     * Returns the overlay color of a hexagon at a given coordinate
     */
    Color getHexColor(Coordinate coord) {
        return Color(cast(ubyte) ((abs(coord.q) * 64) % 255), cast(ubyte) ((abs(coord.q) * 64) % 255), cast(ubyte) ((abs(coord.q) * 64) % 255), 50);
    }

}
