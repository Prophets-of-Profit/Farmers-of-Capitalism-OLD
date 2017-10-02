module item.plant.TraitsList;

import std.conv;

import item.plant.functions.BirthLocationFunctions;
import item.plant.functions.CanBePlacedFunctions;
import item.plant.functions.DestroyedActions;
import item.plant.functions.GetColorFunctions;
import item.plant.functions.GetOwnerFunctions;
import item.plant.functions.GetSizeFunctions;
import item.plant.functions.GetUsefulnessFunctions;
import item.plant.functions.IncrementalActions;
import item.plant.functions.MainActions;
import item.plant.functions.MoveCostFunctions;
import item.plant.functions.MutabilityFunctions;
import item.plant.functions.SteppedOnFunctions;
import item.plant.PlantTraits;
import item.plant.Plant;
import world.World;

TraitSet makeAllTraits(){
    return TraitSet([
        new class Trait {
            this(){
                super(ActionType.PLACEABLE, VisibilityType.CO_RECESSIVE, Point(-5, -5));
            }
            override bool getBool(Coordinate location, Plant forWhom){
                return isAquaticCompatible(location, forWhom);
            }
        }
    ]);
}
