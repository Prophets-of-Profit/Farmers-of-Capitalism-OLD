module player.technology.Agriculture;

import player.technology.Technology;

public class Agriculture : Technology {

    override bool canBeUnlockedBy(Player player){
        return true;
    }

    override void onUnlock(Player player){
    }

}
