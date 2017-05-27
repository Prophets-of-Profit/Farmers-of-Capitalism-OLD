/**
 * An abstract class defining what objects that belong to a tile must do
 * This is a contract ensuring that all objects tiles have certain functionalities
 */
abstract class TilePiece{

    public double completion;       ///How close the tilepiece is towards being complete: once it won't function until it has reached completion
    public immutable int[] coords;  ///The location of which hex the tile piece exists in in terms of [ringNum, pos]

    /**
     *  A constructor for any TilePiece
     *  A TilePiece MUST have coordinates and MUST exist on a hex
     */
    this(immutable int[] coords){
        this.coords = coords;
    }

    public abstract void getSteppedOn();        ///What the tile piece should do when stepped on
    public abstract void doIncrementalAction(); ///What the tile piece should do every turn
    public abstract void doMainAction();        ///What the tile piece should do when the player interacts with it
    public abstract void getDestroyed();        ///What/how the tile piece gets destroyed and what it will do when destroyed

}