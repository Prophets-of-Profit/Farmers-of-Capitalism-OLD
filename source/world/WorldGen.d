module world.WorldGen;

import std.stdio;
import std.random;
import World;
void generateTiles(World world){
    int worldSize = world.getNumTiles();
    int[][] generated;
    int[] maxElevationLocation;
    double maxElevation = -1.0;
    generated ~= world.getRandomTile();
    HexTile startingTile = world.getTileAt(generated[0]);
    HexTile currentTile = startingTile;
    while(generated.length < worldSize){                                        ///Initialize elevation
        if(!generated.canFind(currentTile.coords)){
            int[][] adjacencies = currentTile.getAdjacentTiles();
            double totalElevationOfAdjacent = 0;
            foreach(int[] adj; adjacencies){
                if(generated.canFind(adj)){
                    totalElevationOfAdjacent += world.getTileAt(adj).elevation;
                }
            }
            double avgElevation = totalElevationOfAdjacent / adjancencies.length;
            currentTile.elevation = avgElevation + uniform(-1.0, 1.0);           ///Can vary up to one from avg. surrounding elevation
            if(currentTile.elevation > maxElevation){
                maxElevation = currentTile.elevation
                maxElevationLocation = currentTile.coords.dup();
            }
            generated ~= currentTile.coords;
        }
        currentTile = adjacencies[uniform(0, adjacencies.length)];
    }

    int[][] generated;
    generated ~= world.getRandomTile();
    HexTile startingTile = world.getTileAt(generated[0]);
    HexTile currentTile = startingTile;
    while(generated.length < worldSize){                                        ///Repeat; initializing temperature
        if(!generated.canFind(currentTile.coords)){
            int[][] adjacencies = currentTile.getAdjacentTiles();
            double totalTempOfAdjacent = 0;                                /// If there are no surrounding tiles, set temperature
            foreach(int[] adj; adjacencies){
                if(generated.canFind(adj)){
                    totalTempOfAdjacent += world.getTileAt(adj).baseTemperature;
                }
            }
            double avgTemp = totalTempOfAdjacent / adjancencies.length;
            currentTile.baseTemperature = avgTemp + uniform(-1.0, 1.0);           ///Can vary up to one from avg. surrounding temperature
            currentTile.baseTemperature += currentTile.elevation / -5.0
            generated ~= currentTile.coords;
        }
        currentTile = adjacencies[uniform(0, adjacencies.length)];
    }

    int[][] generated;
    generated ~= world.getRandomTile();
    HexTile startingTile = world.getTileAt(generated[0]);
    HexTile currentTile = startingTile;
    while(generated.length < worldSize){                                        ///Repeat; initializing humidity
        if(!generated.canFind(currentTile.coords)){
            int[][] adjacencies = currentTile.getAdjacentTiles();
            double totalHumidOfAdjacent = 0;                                /// If there are no surrounding tiles, set temperature
            foreach(int[] adj; adjacencies){
                if(generated.canFind(adj)){
                    totalHumidOfAdjacent += world.getTileAt(adj).baseHumidity;
                }
            }
            double avgHumid = totalHumidOfAdjacent / adjancencies.length;
            currentTile.baseHumidity = avgHumid + uniform(-1.0, 1.0);           ///Can vary up to one from avg. surrounding temperature
            currentTile.baseHumidity += currentTile.elevation / -3.0
            generated ~= currentTile.coords;
        }
        currentTile = adjacencies[uniform(0, adjacencies.length)];
    }
    int[][] generated;
    generated ~= world.getRandomTile();
    HexTile startingTile = world.getTileAt(generated[0]);
    HexTile currentTile = startingTile;
    while(generated.length < worldSize){                                        ///Repeat; initializing temperature
        if(!generated.canFind(currentTile.coords)){
            int[][] adjacencies = currentTile.getAdjacentTiles();
            double totalSoilOfAdjacent = 0;                                /// If there are no surrounding tiles, set temperature
            foreach(int[] adj; adjacencies){
                if(generated.canFind(adj)){
                    totalSoilOfAdjacent += world.getTileAt(adj).soil;
                }
            }
            double avgSoil = totalSoilOfAdjacent / adjancencies.length;
            currentTile.soil = avgSoil + uniform(-1.0, 1.0);           ///Can vary up to one from avg. surrounding temperature
            currentTile.soil += currentTile.elevation / 8.0
            generated ~= currentTile.coords;
        }
        currentTile = adjacencies[uniform(0, adjacencies.length)];
    }
}

void genRiver(World world){
    bool cont = true;
    int[] currentTile = World.getRandomTile();
    while(cont){
        if(currentTile.isWater || currentTile[0] == world.numRings){
            cont = false;
        }
        else{
            currentTile.isWater = true;
            int[] minElev = currentTile.getAdjacentTiles()[0];
            int index = 0;
            int direction = 0;
            foreach(int[] tile; currentTile.getAdjancentTiles()){
                if(world.tileAt(tile).elevation < world.tileAt(minElev).elevation){
                    minElev = tile;
                    direction = index;            }
                index++;
            }
            world.getTileAt(currentTile).direction = direction;
            currentTile = world.tileAt(minElev)
        }
    }
}

void genWindDirection(World world){
    foreach(Hextile tile; World.tiles){
        int[] maxTemp = tile.getAdjacentTiles()[0];
        int index = 0;
        int direction = 0;
        foreach(int[] coords; currentTile.getAdjancentTiles()){
            if(world.tileAt(coords).baseTemperature < world.tileAt(maxTemp).baseTemperature){
                maxTemp = tile;
                direction = index;            }
            index++;
        }
        tile.direction = direction;
    }
}

