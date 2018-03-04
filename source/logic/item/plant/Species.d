module logic.item.plant.Species;

import graphics.Constants;
import logic.item.plant.Trait;

/**
 * Represents a plant species
 */
struct Species {
    string name; ///The name of the species
    string description; ///A description of the species
    Image representation; ///The image that represents the species; how it looks
    TraitSet requiredTraits; ///What traits are required for a plant to be of this species
    TraitSet commonTraits; ///What traits this species has commonly: aren't necessary, but are useful for determining actual species
}

/**
 * Gets the breed that closest represents the given traits
 */
Breed getSpecies(TraitSet traits) {
    return Breed.TOMATO_PLANT; //TODO:
}

/**
 * An enum of all the species that exist in the game
 */
enum Breed : Species {
    TOMATO_PLANT = Species("Tomato Plant", "Tom ate a plant.", Image.TempIcon, null, null)
}
