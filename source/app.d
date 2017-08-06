/**
 * "I feel like I have accomplished very much spending ~3 hours on a single line of easy code"
 *      -Saurabh Totey
 *
 * "You've beat me at my own game!"
 * "Don't fool yourself; you were never even a Player(Coordinate coords);"
 *      -Elia Gorkhovsky
 *
 * "Some crappy quote about being a tool"
 *      -Kadin Tucker
 *
 * A proprietary software written by Saurabh Totey, Elia Gorokhovsky, and Kadin Tucker.
 *
 *    $$$$$$$$\                                                                       $$$$$$\         $$$$$$\                   $$\  $$\             $$\$$\
 *    $$  _____|                                                                     $$  __$$\       $$  __$$\                  \__| $$ |            $$ \__|
 *    $$ |  $$$$$$\  $$$$$$\ $$$$$$\$$$$\  $$$$$$\  $$$$$$\  $$$$$$$\        $$$$$$\ $$ /  \__|      $$ /  \__|$$$$$$\  $$$$$$\ $$\$$$$$$\   $$$$$$\ $$ $$\ $$$$$$$\$$$$$$\$$$$\
 *    $$$$$\\____$$\$$  __$$\$$  _$$  _$$\$$  __$$\$$  __$$\$$  _____|      $$  __$$\$$$$\           $$ |      \____$$\$$  __$$\$$ \_$$  _|  \____$$\$$ $$ $$  _____$$  _$$  _$$\
 *    $$  __$$$$$$$ $$ |  \__$$ / $$ / $$ $$$$$$$$ $$ |  \__\$$$$$$\        $$ /  $$ $$  _|          $$ |      $$$$$$$ $$ /  $$ $$ | $$ |    $$$$$$$ $$ $$ \$$$$$$\ $$ / $$ / $$ |
 *    $$ | $$  __$$ $$ |     $$ | $$ | $$ $$   ____$$ |      \____$$\       $$ |  $$ $$ |            $$ |  $$\$$  __$$ $$ |  $$ $$ | $$ |$$\$$  __$$ $$ $$ |\____$$\$$ | $$ | $$ |
 *    $$ | \$$$$$$$ $$ |     $$ | $$ | $$ \$$$$$$$\$$ |     $$$$$$$  |      \$$$$$$  $$ |            \$$$$$$  \$$$$$$$ $$$$$$$  $$ | \$$$$  \$$$$$$$ $$ $$ $$$$$$$  $$ | $$ | $$ |
 *    \__|  \_______\__|     \__| \__| \__|\_______\__|     \_______/        \______/\__|             \______/ \_______$$  ____/\__|  \____/ \_______\__\__\_______/\__| \__| \__|
 *                                                                                                                     $$ |
 *                                                                                                                     $$ |
 *                                                                                                                     \__|
 * Above text was made with http://patorjk.com/
 */
module app;

import world.World;
import character.Player;

/**
 * The entire game class
 * Stores all game data in one object that can be serialized and deserialized
 * Allows for game saves
 * TODO make this serializable
 */
class Main{

    public World mainWorld;         ///The world on which the game is played.
    public Player[] players;        ///The players of the game. Length of array is how many players.

    /**
     * Makes the main object of a game
     * Only makes the object and the world and then evenly spaces and places players
     * Game logic is handled outside of object
     * Params:
     *      numPlayers = the number of players for the game to have
     *      worldSize = how many rings the world should have
     */
    this(int numPlayers, int worldSize){
        mainWorld = new World(worldSize);
        players = new Player[numPlayers];
        for(int i = 0; i < numPlayers; i++){
            Coordinate startLocation = Coordinate(worldSize, i * getSizeOfRing(worldSize) / numPlayers);
            players[i] = new Player(startLocation);
            mainWorld.getTileAt(startLocation).owner = players[i];
        }
    }

}

Main game; ///The main object stored in a static variable "game"

/**
 * The entry point for this game
 * First sets the game object as either an already existing game object (deserializes existing game) or makes a new game object
 * After game object is set, it is the game engine which handles game logic and calculations
 * Initializes graphics, but doesn't/can't handle or do graphics calculations/logic
 * Graphics hooks into the game object and draws it based off of what the game is and is completely separate from this method's handling of the game logic
 */
void main(){
    //TODO write engine
}
