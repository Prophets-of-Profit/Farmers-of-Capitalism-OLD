module item.plant.functions.GetColorFunctions;

import character.Character;
import item.Item;
import item.plant.Plant;

/**
 * Returns a function that will have the color always be a constant color
 */
auto makeConstantColor(Color constantColor){
    return (Plant forWhom) => constantColor;
}
