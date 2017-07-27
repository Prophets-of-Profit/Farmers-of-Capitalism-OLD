/*
TODO rework all of this into world constructor and delete this file
void generateTiles(World world, int numRivers){
    int worldSize = world.getNumTiles();

    int[][] generated;
    int[] maxElevationLocation;
    generated ~= world.getRandomTile();
    double maxElevation = -1.0;
    double minElevation = 1.0;
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
            if(currentTile.elevation < minElevation){
                minElevation = currentTile.elevation;
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
    double maxTemp = startingTile.baseTemperature;
    double minTemp = maxTemp;
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
            if(currentTile.baseTemperature > maxTemp){
                maxTemp = currentTile.baseTemperature;
            }
            if(currentTile.baseTemperature < minTemp){
                minTemp = currentTile.baseTemperature;
            }
        }
        int[][] adjacencies = currentTile.getAdjacentTiles();
        currentTile = world.getTileAt(adjacencies[uniform(0, adjacencies.length)]);
    }

    generated = [];
    generated ~= world.getRandomTile();
    startingTile = world.getTileAt(generated[0]);
    currentTile = startingTile;
    double maxHumid = startingTile.baseWater;
    double minHumid = maxHumid;
    while(generated.length < worldSize){                                        ///Repeat; initializing water
        if(!generated.canFind(currentTile.coords)){
            int[][] adjacencies = currentTile.getAdjacentTiles();
            double totalHumidOfAdjacent = 0;                                /// If there are no surrounding tiles, set temperature
            foreach(int[] adj; adjacencies){
                if(generated.canFind(adj)){
                    totalHumidOfAdjacent += world.getTileAt(adj).baseWater;
                }
            }
            double avgHumid = totalHumidOfAdjacent / adjacencies.length;
            currentTile.baseWater = avgHumid + uniform(-1.0, 1.0);           ///Can vary up to one from avg. surrounding temperature
            currentTile.baseWater += currentTile.elevation / -3.0;
            generated ~= currentTile.coords.dup();
            if(currentTile.baseWater > maxHumid){
                maxHumid = currentTile.baseWater;
            }
            if(currentTile.baseWater < minHumid){
                minHumid = currentTile.baseWater;
            }
        }
        int[][] adjacencies = currentTile.getAdjacentTiles();
        currentTile = world.getTileAt(currentTile.getAdjacentTiles()[uniform(0, adjacencies.length)]);
    }

    generated = [];
    generated ~= world.getRandomTile();
    startingTile = world.getTileAt(generated[0]);
    currentTile = startingTile;
    double maxSoil = startingTile.soil;
    double minSoil = maxSoil;
    while(generated.length < worldSize){                                        ///Repeat; initializing soil
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
            if(currentTile.soil > maxSoil){
                maxSoil = currentTile.soil;
            }
            if(currentTile.soil < minSoil){
                minSoil = currentTile.soil;
            }
        }
        int[][] adjacencies = currentTile.getAdjacentTiles();
        currentTile = world.getTileAt(adjacencies[uniform(0, adjacencies.length)]);
    }

    foreach(HexTile tile; world.tiles){
        tile.baseTemperature = (tile.baseTemperature - minTemp) / (maxTemp - minTemp);
        tile.elevation = (tile.elevation - minElevation) / (maxElevation - minElevation);
        tile.baseWater = (tile.baseWater - minHumid) / (maxHumid - minHumid);
        tile.soil = (tile.soil - minSoil) / (maxSoil - minSoil);
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
}*/
