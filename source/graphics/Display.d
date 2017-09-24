module graphics.Display;

import derelict.sdl2.sdl;

/**
 * Loads SDL
 */
shared static this(){
    DerelictSDL2.load(SharedLibVersion(2, 0, 6));
}

/**
 * Stores window in object format
 */
class Display{

    SDL_Window* window;             ///The window object
    SDL_Surface* mainSurface;       ///The surface object

    /**
     * Gets the width of the window
     */
    @property int width(){
        int w;
        SDL_GetWindowSize(this.window, &w, null);
        return w;
    }

    /**
     * Gets the height of the window
     */
    @property int height(){
        int h;
        SDL_GetWindowSize(this.window, null, &h);
        return h;
    }

    /**
     * Sets the width of the window
     */
    @property void width(int w){
        SDL_SetWindowSize(this.window, w, this.height);
    }

    /**
     * Sets the height of the window
     */
    @property void height(int h){
        SDL_SetWindowSize(this.window, this.width, h);
    }

    /**
     * TODO: make the display take in a main object
     */
    this(int width = 1024, int height = 768){
        this.window = SDL_CreateWindow("Farmers of Capitalism", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN);
        this.mainSurface = SDL_GetWindowSurface(this.window);
    }

    /**
     * Refreshes the window
     */
    void update(){
        SDL_FillRect(this.mainSurface, null, SDL_MapRGB(this.mainSurface.format, 0, 255, 0));
        SDL_UpdateWindowSurface(this.window);
    }

}
