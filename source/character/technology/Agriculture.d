module character.technology.Agriculture;

import character.technology.Technology;
import character.Player;

public class Agriculture : Technology {

    override bool canBeUnlockedBy(Player player){
        return true;
    }

    override void onUnlock(Player player){
    }

}
