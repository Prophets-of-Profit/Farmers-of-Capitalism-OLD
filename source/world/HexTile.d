import app;
import World;
import TilePiece;

class HexTile{

    public immutable int[] coords;  ///Location of the tile stored as [ringNumber, positionInRing]
    private double temperature;     ///Part of tile's climate
    private double humidity;        ///Part of tile's climate (if this is a water tile, determines water salinity)
    private double soil;            ///Part of tile's climate
    public bool isWater;            ///Determines if the tile is a water tile
    private int direction;          ///Direction of wind or water flow
    public TilePiece[] improvement; ///Improvement(s) or building(s) or plant(s) that are on this tile

    /**
     * The constructor for a hextile
     * Takes in its coordinates and stores it in itself for later use
     * Each hextile MUST have coordinates
     * Params:
     *      coords = the coordinates of the new hextile
     */
    this(immutable int[] coords){
        this.coords = coords;
    }

    /**
     * Returns all tiles of distance 1 from this tile
     * Because the tiles are hexes, the process involves finding whether the tiles are straight off from one of the center hex's sides
     *  and then performing different actions based on whether the tile is a) the center, b) straight off the side of the center hex, or
     *  c) just any tile
     * The method will make sure that the adjacent tiles actually exist in the map so that tiles such as map edges don't give adjacent tiles that dont' exist
     */
    public int[][] getAdjacentTiles(){
        int[][] adjacentCandidates = null;
        int cornerNum = (this.coords[0] == 0)? 0 : this.coords[1] / this.coords[0];
        if(coords[0] == 0){
            return [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5]];
        }else if(this.coords[1] % this.coords[0] == 0){
            adjacentCandidates = [[this.coords[0], this.coords[1] - 1],
                    [this.coords[0], this.coords[1] + 1],
                    [this.coords[0] - 1, (this.coords[0] - 1) * cornerNum],
                    [this.coords[0] + 1, (this.coords[0] + 1) * cornerNum - 1],
                    [this.coords[0] + 1, (this.coords[0] + 1) * cornerNum],
                    [this.coords[0] + 1, (this.coords[0] + 1) * cornerNum + 1]];
        }else{
            adjacentCandidates = [[this.coords[0], this.coords[1] - 1],
                    [this.coords[0], this.coords[1] + 1],
                    [this.coords[0] + 1, this.coords[1] + cornerNum + 1],
                    [this.coords[0] + 1, this.coords[1] + cornerNum],
                    [this.coords[0] - 1, this.coords[1] - cornerNum - 1],
                    [this.coords[0] - 1, this.coords[1] - cornerNum + 1]];
        }
        int[][] adjacentTiles = null;
        foreach(int[] coord; adjacentCandidates){
            if(mainWorld.getTileAt(coord) !is null){
                adjacentTiles ~= coord;
            }
        }
        return adjacentTiles;
    }

}

unittest{
    import std.stdio;
    import std.conv;
    import std.random;
    int ringNumsToTest = 5;
    mainWorld = new World(ringNumsToTest);
    writeln("Adjacencies of (0, 0) : ", mainWorld.getTileAt([0, 0]).getAdjacentTiles());
    int testRunNum = 4;
    for(int i = 0; i < testRunNum; i++){
        int ringNum = uniform(0, ringNumsToTest);
        int pos = uniform(0, getSizeOfRing(ringNum));
        writeln("Adjacencies of (", ringNum, ", ", pos, ") : ", mainWorld.getTileAt([ringNum, pos]).getAdjacentTiles());
    }
}