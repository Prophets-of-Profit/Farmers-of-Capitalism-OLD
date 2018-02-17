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
    iRectangle mapTarget; ///Where the map actually gets rendered; any part outside of location gets clipped
    int scrollValue; ///The total mouse wheel displacement
    iVector lastClicked; ///Where the mouse was last clicked
    immutable selectedColor = Color(255, 255, 255, 100); ///The overlay color for the selected hex
    Coordinate selectedHex; ///The hex that is currently selected

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
     * Gets the sidelength of a hex
     * TODO: get this value dynamically
     */
    @property int sideLength() {
        if (this.location.w * hexBase.x > this.location.h * hexBase.y) {
            return cast(int) (this.location.h / (this.world.size + 1) / 3);
        } else {
            return cast(int) (this.location.w / this.world.size / hexBase.x / 2);
        }
    }

    /**
     * Makes a minimap given the container and the world to draw
     */
    this(Display container, iRectangle location, GameWorld world) {
        super(container);
        this._location = location;
        this.mapTarget = new iRectangle(location.x, location.y, location.w, location.h);
        this.world = world;
        this.container.renderer.drawBlendMode = SDL_BLENDMODE_BLEND;
        this.updateTextures();
    }

    /**
     * Updates how the map looks
     * TODO: could be made MUCH more efficient
     */
    void updateTextures() {
        Surface m = new Surface(this.location.w, this.location.h, SDL_PIXELFORMAT_RGBA32);
        foreach (coord; this.world.tiles.keys) {
            iPolygon!6 hex = coord.asHex(this.mapTarget.center, this.sideLength);
            iRectangle size = hex.bound;
            m.blit(images[this.world.tiles[coord].representation], null, size);
            Surface colorSurface = new Surface(this.location.w, this.location.h, SDL_PIXELFORMAT_RGBA32);
            colorSurface.fillPolygon!6(hex, this.getHexColor(coord));
            m.blit(colorSurface, null, this.location);
        }
        this.map = new Texture(m, this.container.renderer);
    }

    /**
     * Handles events on the minimap
     * Certain events will handle the minimap zooming while other events will select hexes
     */
    void handleEvent(SDL_Event event) {
        iVector mouseLocation = this.container.mouse.location;
        if (this.container.mouse.allButtons[SDL_BUTTON_LEFT].isPressed()) {
            if (this.lastClicked is null) {
                this.lastClicked = mouseLocation;
            }
            iVector newTopLeft = this.mapTarget.topLeft + mouseLocation - this.lastClicked;
            this.mapTarget.x = newTopLeft.x;
            this.mapTarget.y = newTopLeft.y;
            this.lastClicked = mouseLocation;
        } else {
            this.lastClicked = null;
        }
        if (event.type == SDL_MOUSEBUTTONUP) {
            foreach (coord; this.world.tiles.keys) {
                if (coord.asHex(this.mapTarget.center, this.sideLength).contains(mouseLocation)) {
                    this.selectedHex = coord;
                }
            }
        }
    }

    /**
     * Handles drawing the minimap
     */
    override void draw() {
        this.container.renderer.copy(this.map, this.mapTarget);
        if (this.selectedHex !is null) {
            this.container.renderer.fillPolygon!6(this.selectedHex.asHex(this.mapTarget.center, this.sideLength), this.selectedColor);
        }
    }

    /**
     * Returns the overlay color of a hexagon at a given coordinate
     */
    Color getHexColor(Coordinate coord) {
        return Color(cast(ubyte) ((abs(coord.q) * 64) % 255), cast(ubyte) ((abs(coord.q) * 64) % 255), cast(ubyte) ((abs(coord.q) * 64) % 255), 75);
    }

}
