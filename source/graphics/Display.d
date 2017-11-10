module graphics.Display;

import std.conv;
import std.datetime;
import std.experimental.logger;

import gfm.logger;
import gfm.sdl2;

class Display{

    Logger logger;
    SDL2 sdl;
    SDL2Window window;
    SDL2Renderer renderer;
    SDLTTF ttf;
    SDLImage image;
    __gshared bool isRunning;
    int framerate = 60;         //TODO config for framerate

    this(){
        debug{
            this.logger = new ConsoleLogger();
        }
        this.sdl = new SDL2(this.logger);
        //TODO config for window size
        this.window = new SDL2Window(this.sdl, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 640, 480, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE | SDL_WINDOW_INPUT_FOCUS | SDL_WINDOW_MOUSE_FOCUS);
        this.renderer = new SDL2Renderer(this.window);
        this.ttf = new SDLTTF(this.sdl);
        this.image = new SDLImage(this.sdl);
        this.window.setTitle("Farmers of Capitalism");
    }

    ~this(){
        this.sdl.destroy();
        this.window.destroy();
        this.renderer.destroy();
    }

    void run(){
        this.isRunning = true;
        SysTime lastTickTime;
        while(!this.sdl.wasQuitRequested() && this.isRunning){
            SDL_Event event;
            while(this.sdl.pollEvent(&event)){
                this.renderer.setColor(0, 0, 0);
                this.renderer.clear();
                switch(event.type){
                    case SDL_MOUSEMOTION:{
                        break;
                    }
                    case SDL_MOUSEBUTTONDOWN:{
                        break;
                    }
                    case SDL_MOUSEBUTTONUP:{
                        break;
                    }
                    default:break;
                }
            }
            if(this.renderer.info.isVsyncEnabled || Clock.currTime >= lastTickTime + dur!"msecs"((1000.0 / this.framerate).to!int)){
                lastTickTime = Clock.currTime;
                this.renderer.present();
            }
        }
        this.isRunning = false;
    }

}
