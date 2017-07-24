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
*         Level 1: Slows growth for all other plants on tile by 5%.
*         Level 2: Slows growth for all other plants on tile by 10%.
*         Level 3: Slows growth for all other plants on tile by 15%.
*         Level 4: Slows growth for all other plants on tile by 20%.
*         Level 5: Slows growth for all other plants on tile by 25%.
*     *Aquatic: Can be planted on water tiles.
*     *Slowing: Increases movement cost for a tile.
*         Movement cost increase is equal to level.
*     *Speeding: Decreases movement cost for a tile.
*         Movement cost decrease is equal to level.
*     *Symbiotic: Aids other plants on the same tile. Works less if target is Invasive. TODO: Implement
*         Level 1: Speeds growth for all other plants on tile by 5%.
*         Level 2: Speeds growth for all other plants on tile by 10%.
*         Level 3: Speeds growth for all other plants on tile by 15%.
*         Level 4: Speeds growth for all other plants on tile by 20%.
*         Level 5: Speeds growth for all other plants on tile by 25%.
*
*TODO: More Passive Traits
*
* Active traits:
*TODO: More Active Traits
*/
module PlantTraits;
import Player;
import std.algorithm;

void delegate()[] naturallyPossibleIncrementalActions = [];                                                 ///The set of all incremental actions that are possible in nature (wild plants).
void delegate(Player stepper)[] naturallyPossibleSteppedOnActions = [];                                     ///The set of all steppedOn actions that are possible in nature.
void delegate(Player player)[] naturallyPossibleMainActions = [];                                           ///The set of all main actions that are possible in nature.
void delegate(Player destroyer)[] naturallyPossibleDestroyedActions = [];                                   ///The set of all destroyed actions that are possible in nature.
void delegate(Player placer)[] naturallyPossiblePlacedActions = [];                                         ///The set of all placed actions that are possible in nature.
string[] naturallyPossibleAttributes = ["Moveable", "Invasive", "Slowing", "Symbiotic", "Speeding"];        ///The set of all attributes that are naturally possible in nature.
string[][] mutuallyExclusiveAttributes = [["Invasive", "Symbiotic"], ["Slowing", "Speeding"]]               ///Contains list of attributes that can never be on the same plant.


