import Player;

/**
 * An abstract class defining what objects that belong to a tile must do
 * This is a contract ensuring that all objects tiles have certain functionalities
 */
abstract class TilePiece{

    public double completion;       ///How close the tilepiece is towards being complete: once it won't function until it has reached completion
    public immutable int[] coords;  ///The location of which hex the tile piece exists in in terms of [ringNum, pos]
    private Player creator = null;

    /**
     *  A constructor for any TilePiece
     *  A TilePiece MUST have coordinates and MUST exist on a hex
     * Params:
     *      coords = the coordinates of where the TilePiece is located
     */
    this(immutable int[] coords){
        this.coords = coords;
        getCreated();
    }

    /**
     * A constructor for a TilePiece that has a creator
     * Params:
     *      coords = the coordinates of where the TilePiece is located
     *      creator = the player who is making the TilePiece
     */
    this(immutable int[] coords, Player creator){
        this.creator = creator;
        this(coords);
    }

    public abstract void getCreated();                      ///What the tile piece should do when created (should also account for a null creator)
    public abstract void getSteppedOn(Player stepper);      ///What the tile piece should do when stepped on
    public abstract void doIncrementalAction();             ///What the tile piece should do every turn
    public abstract void doMainAction(Player player);       ///What the tile piece should do when the player interacts with it
    public abstract void getDestroyed(Player destroyer);    ///What/how the tile piece gets destroyed and what it will do when destroyed
    public abstract Player getOwner();                      ///Gets the current owner of the tilePiece based on which tile it is on

}