module graphics.Display;

import derelict.sdl2.sdl;

/**
 * Loads SDL.
 */
shared static this(){
    DerelictSDL2.load(SharedLibVersion(2, 0, 6));
}

/**
 * Stores window in object format.
 */
class Display{

}
