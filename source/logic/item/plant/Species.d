module logic.item.plant.Species;

import std.algorithm;
import std.traits;
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
    Breed spec;
    Breed[] speciesCandidates;
    //Adds any species to speciesCandidates as long as the given traitset fills the trait requirements of the species
    foreach (species; EnumMembers!Breed) {
        bool hasRequiredTraits = true;
        foreach (category; EnumMembers!TraitExpression) {
            foreach (requiredTrait; species.requiredTraits[category]) {
                if (!traits[category].canFind(requiredTrait)) {
                    hasRequiredTraits = false;
                    break;
                }
            }
            if (!hasRequiredTraits) {
                break;
            }
        }
        if (hasRequiredTraits) {
            speciesCandidates ~= species;
        }
    }
    foreach (candidate; speciesCandidates) {
        //TODO: get distance between given traitset and each candiate's required and common traits
    }
    return spec; //TODO: return candidate with smallest distance from given traitset
}

/**
 * An enum of all the species that exist in the game
 */
enum Breed : Species {
    TOMATO_PLANT = Species("Tomato Plant", "Tom ate a plant.", Image.TomatoItem, null, null)
}
