module graphics.Display;

import std.conv;
import std.datetime;
import std.experimental.logger;

import gfm.logger;
import gfm.sdl2;

class Display{

    Logger logger;              ///Gives some information about the window
    SDL2 sdl;                   ///Centrally handles events
    SDL2Window window;          ///The window where things are displayed
    SDL2Renderer renderer;      ///Renders objects on the window
    SDLTTF ttf;                 ///Handles true type fonts
    SDLImage image;             ///Handles images
    __gshared bool isRunning;   ///Whether the window is running
    int framerate = 60;         ///The maximum framerate for the window                //TODO config for framerate

    this(){
        /**
         * The constructor for Display
         * Initializes various SDL handlers
         */
        debug{
            //Returns window information if buid is debug
            this.logger = new ConsoleLogger();
        }
        //Creates the sdl object
        this.sdl = new SDL2(this.logger);
        //Creates the window; TODO config for window size
        this.window = new SDL2Window(this.sdl, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 640, 480, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE | SDL_WINDOW_INPUT_FOCUS | SDL_WINDOW_MOUSE_FOCUS);
        //Creates the renderer
        this.renderer = new SDL2Renderer(this.window);
        //Creates the ttf
        this.ttf = new SDLTTF(this.sdl);
        //Creates the image handler
        this.image = new SDLImage(this.sdl);
        //Sets title to "Farmers of Capitalism"
        this.window.setTitle("Farmers of Capitalism");
    }

    ~this(){
        /**
         * The destructor for Display
         * Destroys handlers
         */
        this.sdl.destroy();
        this.window.destroy();
        this.renderer.destroy();
    }

    void run(){
        /**
         * Runs the Display
         */
        this.isRunning = true;
        SysTime lastTickTime;       //The last time a tick happened
        while(!this.sdl.wasQuitRequested() && this.isRunning){
            SDL_Event event;        //Creates an event
            while(this.sdl.pollEvent(&event)){
                this.renderer.setColor(0, 0, 0);
                this.renderer.clear();
                switch(event.type){
                    case SDL_MOUSEMOTION:{
                        //TODO
                        break;
                    }
                    case SDL_MOUSEBUTTONDOWN:{
                        //TODO
                        break;
                    }
                    case SDL_MOUSEBUTTONUP:{
                        //TODO
                        break;
                    }
                    default:break;
                }
            }
            if(this.renderer.info.isVsyncEnabled || Clock.currTime >= lastTickTime + dur!"msecs"((1000.0 / this.framerate).to!int)){
                //Ticks once and sets the last tick to the current time is the length of tick has passed
                lastTickTime = Clock.currTime;
                this.renderer.present();
            }
        }
        this.isRunning = false;         //Sets isRunning to false if quit is requested
    }

}
