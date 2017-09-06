module item.plant.TraitsList;

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

//BirthLocationFunctions
//CanBePlacedFunctions
Trait!(bool delegate(Coordinate, Plant)) aquatic = new Trait!(bool delegate(Coordinate, Plant))(VisibilityType.WEAK_RECESSIVE, Point(-5, -5), isAquaticCompatible);
//DestroyedActions
//GetColorFunctions
//GetOwnerFunctions
//GetUsefulnessFunctions
//GetIncrementalFunctions
//MainActions
//MoveCostFunctions
//MutabilityFunctions
//SteppedOnFunctions

enum Traits{
    AQUATIC = aquatic;
}
