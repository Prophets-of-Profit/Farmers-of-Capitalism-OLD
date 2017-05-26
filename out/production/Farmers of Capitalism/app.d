import std.stdio;
import World;

static World mainWorld;

void main()
{
    //TODO add "derelict-steamworks": "~>0.0.8" to dependencies once its dub setup is fixed
    writeln("I shall not conform.");
    mainWorld = new World(100);
}

unittest{

}