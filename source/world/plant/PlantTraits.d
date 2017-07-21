/**
* Contains all possible functional attributes of plants.
* Each active trait can be implemented in certain sockets of Plant (incrementalActions, steppedOnActions, etc.) and does something.
* Each passive trait is stored as a string in Plant.attribute and checked for in Plant functions.
* Passive traits:
*     *Patent: Ownership based on creator rather than tile owner.
*         Level 1: Ownership determined based on immediate creator or creator of parents.
*     *Moveable: Can be replanted after being planted, passing growth cycles, and being harvested.
*         Level 1: Can be moved if maturity <= 20%.
*         Level 2: Can be moved if maturity <= 40%.
*         Level 3: Can be moved if maturity <= 60%.
*         Level 4: Can be moved if maturity <= 80%.
*         Level 5: Can be moved.
*     *Invasive: Inhibits other plants on the same tile. Slowed by Resilience of other plants. TODO: Implement
*         Level 1: Slows growth for all other plants on tile by 25%.
*         Level 2: Slows growth for all other plants on tile by 50%.
*         Level 3: Slows growth for all other plants on tile by 75%.
*         Level 4: Stops growth for all other plants on tile.
*         Level 5: All other plants on tile wither by 25% of growth rate instead of growing.
*     *Aquatic: Can be planted on water tiles.
*     *Slowing: Increases movement cost for a tile.
*         Movement cost increase is equal to level.
*TODO: More Passive Traits
*
* Active traits:
*TODO: More Active Traits
*/
module PlantTraits;
import Player;

void delegate()[] naturallyPossibleIncrementalActions = [];
void delegate(Player stepper)[] naturallyPossibleSteppedOnActions = [];
void delegate(Player player)[] naturallyPossibleMainActions = [];
void delegate(Player destroyer)[] naturallyPossibleDestroyedActions = [];
void delegate(Player placer)[] naturallyPossiblePlacedActions = [];
string[] naturallyPossibleAttributes = ["Moveable", "Invasive", "Slowing"];