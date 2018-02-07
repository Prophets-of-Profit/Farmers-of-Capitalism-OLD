module logic.world.GameWorld;

import logic.world.World;

/**
 * A world used specifically in the game
 * Contains game logic like procedural gen, buildings, etc.
 */
class GameWorld : World {

    /**
     * The constructor for a world
     * TODO: worldgen
     */
    this(ulong size) {
        super(size);
    }

}