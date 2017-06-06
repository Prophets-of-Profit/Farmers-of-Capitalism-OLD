import World;
import Player;

static World mainWorld; ///The main world of the entire game

//TODO add "derelict-steamworks": "~>0.0.8" and "derelict-glfw3": "~>4.0.0-alpha.6" to dub.json dependencies
//TODO add main class that can be serialized and deserialized and is saved as a serialized object with all the data inside of it
void main()
{
    mainWorld = new World(100);
}