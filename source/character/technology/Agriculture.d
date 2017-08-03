module character.technology.Agriculture;

import character.technology.Technology;
import character.Player;

class Agriculture : Technology {

    override bool canBeUnlockedBy(Player player){
        return true;
    }

}
