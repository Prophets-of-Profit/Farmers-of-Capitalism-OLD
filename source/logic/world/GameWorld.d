module logic.world.GameWorld;

import logic.world.World;

/**
 * A world used specifically in the game
 * Contains game logic like procedural gen, buildings, etc.
 */
class GameWorld(uint size) : World!size {

    /**
     * The constructor for a world
     * TODO: worldgen
     */
    this() {
        super();
    }

}