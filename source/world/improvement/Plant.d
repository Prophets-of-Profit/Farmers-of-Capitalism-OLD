import tilePiece;

/**
 * A class containing all plant methods. Extends TilePiece.
 *
 */

class Plant : TilePiece{

    public int[] mendelianTraits;       //All traits that follow a pattern of Mendelian inheritance stored as ints 0, 1, 2 based on how many recessive alleles the plant has.
    public int[] codominantTraits;      //All traits that follow a pattern of incomplete inheritance stored as ints 0, 1, 2 based on how many recessive alleles the plant has.
    public double[] numericalTraits;    //All traits that follow a pattern of numerical inheritance stored based on the value of the trait, from 0 to 1.




}

/**
 * A function that takes two plants and returns an offspring based on their traits.
 *
 */

public Plant crossBreed(Plant plant1, Plant plant2){
    offspring = new Plant;
    for(int i = 0; i < plant1.mendelianTraits.length; i++){
        int newTrait = 0;

        if(plant1.mendelianTraits[i] == 1){
            newTrait += uniform(0,2);
        }else if(plant1.mendelianTraits[i] == 2){
            newTrait++;
        }

        if(plant2.mendelianTraits[i] == 1){
            newTrait += uniform(0,2);
        }else if(plant2.mendelianTraits[i] == 2){
            newTrait++;
        }

        offspring.mendelianTraits ~= newTrait;
    }

    for(int i = 0; i < plant1.incompleteTraits.length; i++){
        int newTrait = 0;

        if(plant1.incompleteTraits[i] == 1){
            newTrait += uniform(0,2);
        }else if(plant1.incompleteTraits[i] == 2){
            newTrait++;
        }

        if(plant2.incompleteTraits[i] == 1){
            newTrait += uniform(0,2);
        }else if(plant2.incompleteTraits[i] == 2){
            newTrait++;
        }

        offspring.incompleteTraits ~= newTrait;
    }

    for(int i = 0; i < plant1.numericalTraits.length; i++){
        double newTrait = (plant1.numericalTraits[i] + plant2.numericalTraits[i])/2;
        offspring.numericalTraits ~= newTrait;
    }

    return offspring;


}

unittest{
    plant1 = new Plant;
    plant2 = new Plant;
    int numMendelianTraits = 10;
    int numIncompleteTraits = 5;
    int numNumericalTraits = 6;
    for(int i = 0; i < numMendelianTraits; i++){
        plant1.mendelianTraits ~= uniform(0, 2);
        plant2.mendelianTraits ~= uniform(0, 2);
    }
    for(int i = 0; i < numIncompleteTraits; i++){
        plant1.incompleteTraits ~= uniform(0, 2);
        plant2.incompleteTraits ~= uniform(0, 2);
    }
    for(int i = 0; i < numNumericalTraits; i++){
        plant1.numericalTraits ~= uniform(0, 2);
        plant2.numericalTraits ~= uniform(0, 2);
    }
    Plant offspring = crossBreed(plant1, plant2);
    writeln("Parent 1 traits: ", plant1.mendelianTraits, plant1.incompleteTraits, plant1.numericalTraits);
    writeln("Parent 2 traits: ", plant2.mendelianTraits, plant2.incompleteTraits, plant2.numericalTraits);
    writeln("Offspring traits: ", offspring.mendelianTraits, offspring.incompleteTraits, offspring.numericalTraits);
}