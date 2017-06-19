module world.WorldGen;

import std.stdio;
import std.random;
import std.algorithm;
import World;
import HexTile;

void generateTiles(World world, int numRivers){
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
            double avgElevation = totalElevationOfAdjacent / adjacencies.length;
            currentTile.elevation = avgElevation + uniform(-1.0, 1.0);           ///Can vary up to one from avg. surrounding elevation
            if(currentTile.elevation > maxElevation){
                maxElevation = currentTile.elevation;
                maxElevationLocation = currentTile.coords.dup();
            }
            generated ~= currentTile.coords.dup();
        }
        int[][] adjacencies = currentTile.getAdjacentTiles();
        currentTile = world.getTileAt(adjacencies[uniform(0, adjacencies.length)]);
    }

    generated = [];
    generated ~= world.getRandomTile();
    startingTile = world.getTileAt(generated[0]);
    currentTile = startingTile;
    while(generated.length < worldSize){                                        ///Repeat; initializing temperature
        if(!generated.canFind(currentTile.coords)){
            int[][] adjacencies = currentTile.getAdjacentTiles();
            double totalTempOfAdjacent = 0;                                /// If there are no surrounding tiles, set temperature
            foreach(int[] adj; adjacencies){
                if(generated.canFind(adj)){
                    totalTempOfAdjacent += world.getTileAt(adj).baseTemperature;
                }
            }
            double avgTemp = totalTempOfAdjacent / adjacencies.length;
            currentTile.baseTemperature = avgTemp + uniform(-1.0, 1.0);           ///Can vary up to one from avg. surrounding temperature
            currentTile.baseTemperature += currentTile.elevation / -5.0;
            generated ~= currentTile.coords.dup();
        }
        int[][] adjacencies = currentTile.getAdjacentTiles();
        currentTile = world.getTileAt(adjacencies[uniform(0, adjacencies.length)]);
    }

    generated = [];
    generated ~= world.getRandomTile();
    startingTile = world.getTileAt(generated[0]);
    currentTile = startingTile;
    while(generated.length < worldSize){                                        ///Repeat; initializing humidity
        if(!generated.canFind(currentTile.coords)){
            int[][] adjacencies = currentTile.getAdjacentTiles();
            double totalHumidOfAdjacent = 0;                                /// If there are no surrounding tiles, set temperature
            foreach(int[] adj; adjacencies){
                if(generated.canFind(adj)){
                    totalHumidOfAdjacent += world.getTileAt(adj).baseHumidity;
                }
            }
            double avgHumid = totalHumidOfAdjacent / adjacencies.length;
            currentTile.baseHumidity = avgHumid + uniform(-1.0, 1.0);           ///Can vary up to one from avg. surrounding temperature
            currentTile.baseHumidity += currentTile.elevation / -3.0;
            generated ~= currentTile.coords.dup();
        }
        int[][] adjacencies = currentTile.getAdjacentTiles();
        currentTile = world.getTileAt(currentTile.getAdjacentTiles()[uniform(0, adjacencies.length)]);
    }
    generated = [];
    generated ~= world.getRandomTile();
    startingTile = world.getTileAt(generated[0]);
    currentTile = startingTile;
    while(generated.length < worldSize){                                        ///Repeat; initializing temperature
        if(!generated.canFind(currentTile.coords)){
            int[][] adjacencies = currentTile.getAdjacentTiles();
            double totalSoilOfAdjacent = 0;                                /// If there are no surrounding tiles, set temperature
            foreach(int[] adj; adjacencies){
                if(generated.canFind(adj)){
                    totalSoilOfAdjacent += world.getTileAt(adj).soil;
                }
            }
            double avgSoil = totalSoilOfAdjacent / adjacencies.length;
            currentTile.soil = avgSoil + uniform(-1.0, 1.0);           ///Can vary up to one from avg. surrounding temperature
            currentTile.soil += currentTile.elevation / 8.0;
            generated ~= currentTile.coords.dup();
        }
        int[][] adjacencies = currentTile.getAdjacentTiles();
        currentTile = world.getTileAt(adjacencies[uniform(0, adjacencies.length)]);
    }
    for(int i = 0; i < numRivers; i++){
        genRiver(world);
    }
    genWindDirection(world);
}

void genRiver(World world){
    bool cont = true;
    int[] currentTile = world.getRandomTile();
    while(cont){
        if(world.getTileAt(currentTile).isWater || currentTile[0] == world.numRings){
            cont = false;
        }
        else{
            world.getTileAt(currentTile).isWater = true;
            int[] minElev = world.getTileAt(currentTile).getAdjacentTiles()[0];
            int index = 0;
            int direction = 0;
            foreach(int[] tile; world.getTileAt(currentTile).getAdjacentTiles()){
                if(world.getTileAt(tile).elevation < world.getTileAt(minElev).elevation){
                    minElev = tile;
                    direction = index;
                    }
                index++;
            }
            world.getTileAt(currentTile).direction = direction;
            currentTile = minElev;
        }
    }
}

void genWindDirection(World world){
    foreach(HexTile tile; world.tiles){
        if(!tile.isWater){
            int[] maxTemp = tile.getAdjacentTiles()[0];
            int index = 0;
            int direction = 0;
            foreach(int[] coords; tile.getAdjacentTiles()){
                if(world.getTileAt(coords).baseTemperature < world.getTileAt(maxTemp).baseTemperature){
                    maxTemp = tile.coords.dup();
                    direction = index;
                    index++;
                }
            }
            tile.direction = direction;
        }
    }
}

