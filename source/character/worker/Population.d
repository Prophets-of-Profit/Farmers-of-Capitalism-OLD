module character.worker.Population;

import std.random;

import item.Inventory;

immutable int baseRoomPerPopulation = 5;
immutable double reproductionRatePerWorker = 0.1;

/**
 * An inventory that holds characters
 */
class Population : Inventory(Character) {

    double growthTick = 0;          ///The percentage of growth of the population.
    District district;              ///The district this population is a part of.

    /**
     * Constructs a new population.
     * Populations have a base size determined by an immutable variable.
     */
    this(){
        super(baseRoomPerPopulation);
    }

    /**
     * Check for or cause growth of the population.
     * Populations grow if there is housing space. They grow faster the more people there are that live there.
     * Returns whether or not the population grew.
     */
    bool grow(){
        growthTick += (1 - this.countSpaceUsed() / this.maxSize) * this.countSpaceUsed() * reproductionRatePerWorker;
        while(growthTick >= 1){
            this.contained ~= new Worker(this.district.location, this.contained[uniform(0, this.contained.length)].race)
            growthTick -= 1;
        }
    }
}
