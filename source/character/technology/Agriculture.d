module character.technology.Agriculture;

import character.Player;
import character.technology.Technology;

class Agriculture : Technology {

    override bool canBeUnlockedBy(Player player){
        return true;
    }

}
