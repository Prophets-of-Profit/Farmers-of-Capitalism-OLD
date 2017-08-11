module item.plant.PlantTraits;

import character.Character;
import item.plant.Plant;

void delegate(Character actor)[][ActionType] naturalActions;    ///A list of all possible natural actions in the game sorted by ActionType
PlantAttribute[] naturalAttributes;                             ///A list of all natural attributes in the game
PlantAttribute[][] mutuallyExclusiveAttributes;                 ///A list of mutually exclusive attributes (eg. a plant cannot have 2 mutually exclusive attributes)

/**
 * Attributes a plant can have
 *     *Patent: Ownership based on creator rather than tile owner.
 *         Level 1: Ownership determined based on immediate creator or creator of parents.
 *     *Moveable: Can be replanted after being planted, passing growth cycles, and being harvested.
 *         Level 1: Can be moved if maturity <= 20%.
 *         Level 2: Can be moved if maturity <= 40%.
 *         Level 3: Can be moved if maturity <= 60%.
 *         Level 4: Can be moved if maturity <= 80%.
 *         Level 5: Can be moved.
 *     *Invasive: Inhibits other plants on the same tile. Slowed by Resilience of other plants. TODO: Implement Resilience
 *         Level 1: Slows growth for all other plants on tile by 25%.
 *         Level 2: Slows growth for all other plants on tile by 50%.
 *         Level 3: Slows growth for all other plants on tile by 75%.
 *         Level 4: Stops growth for all other plants on tile.
 *         Level 5: All other plants on tile wither by 25% of growth rate instead of growing.
 *     *Aquatic: Can be planted on water tiles.
 *     *Slowing: Increases movement cost for a tile.
 *         Movement cost increase is equal to level.
 */
enum PlantAttribute{
    PATENT, MOVABLE, INVASIVE, AQUATIC, SLOWING, SPEEDING, SYMBIOTIC, MUTABLE
}

/**
* Enums for the types of stats that a plant can have
* Growth: Rate of growth.
* Resilience: Resistance to invasive species and being stepped on.
* Yield: Amount of products produced when destroyed.
* Seed Quantity: Amount of seeds produced when naturally reproducing.
* Seed Strength: Distance seeds can go before settling.
*/
enum PlantReq{
    GROWTH, RESILIENCE, YIELD, SEED_QUANTITY, SEED_STRENGTH
}
