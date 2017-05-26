import app;
import World;
import TilePiece;
import std.stdio;

class HexTile{

    private int[] coords;           ///Location of the tile stored as [ringNumber, positionInRing]
    private double temperature;     ///Part of tile's climate
    private double humidity;        ///Part of tile's climate (if this is a water tile, determines water salinity)
    private double soil;            ///Part of tile's climate
    public bool isWater;            ///Determines if the tile is a water tile
    private int direction;          ///Direction of wind or water flow
    public TilePiece[] improvement; ///Improvement or building or plant(s) that are on this tile

    this(int[] coords){
        this.coords = coords;
    }

    /**
     * Returns all tiles of distance 1 from this tile
     */
    public int[][] getAdjacentTiles(){
        int[][] adjacentCandidates = null;
        if(coords[0] == 0){
            return [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5]];
        }else if(this.isCorner()){
            adjacentCandidates = [[this.coords[0], this.coords[1] - 1],
                    [this.coords[0], this.coords[1] + 1],
                    [this.coords[0] - 1, (this.coords[0] - 1) * this.findCornerNumber()],
                    [this.coords[0] + 1, (this.coords[0] + 1) * this.findCornerNumber() - 1],
                    [this.coords[0] + 1, (this.coords[0] + 1) * this.findCornerNumber()],
                    [this.coords[0] + 1, (this.coords[0] + 1) * this.findCornerNumber() + 1]];
        }else{
            adjacentCandidates = [[this.coords[0], this.coords[1] - 1],
                    [this.coords[0], this.coords[1] + 1],
                    [this.coords[0] + 1, this.coords[1] + findCornerNumber() + 1],
                    [this.coords[0] + 1, this.coords[1] + findCornerNumber()],
                    [this.coords[0] - 1, this.coords[1] - findCornerNumber() - 1],
                    [this.coords[0] - 1, this.coords[1] - findCornerNumber() + 1]];
        }
        int[][] adjacentTiles = null;
        foreach(int[] coord; adjacentCandidates){
            if(mainWorld.getTileAt(coord) !is null){
                adjacentTiles ~= coord;
            }
        }
        return adjacentTiles;
    }

    public bool isCorner(){
        return this.coords[0] == 0 || this.coords[1] % this.coords[0] == 0;
    }

    public int findCornerNumber(){
        return (this.coords[0] == 0)? 0 : this.coords[1] / this.coords[0];
    }

}

unittest{
    writeln("Adjacencies of (3, 6)");
    writeln(mainWorld.getTileAt([3, 6]).getAdjacentTiles());
}