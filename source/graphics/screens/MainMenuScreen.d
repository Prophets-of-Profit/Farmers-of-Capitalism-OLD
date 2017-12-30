module graphics.screens.MainMenuScreen;

import std.algorithm;
import d2d;

class MainMenuScreen : Screen {

    Sound!(SoundType.Music) enterpriseOrchestra;

    this(Display container) {
        super(container);
        this.enterpriseOrchestra = new Sound!(SoundType.Music)("res/music/enterprise - orchestra.mp3");
        musicVolume = MIX_MAX_VOLUME / 4;
    }

    void handleEvent(SDL_Event event) {
        if (container.keyboard.allPressables.filter!(key => key.id == SDLK_ESCAPE).front.testAndRelease()) {
            this.container.isRunning = false;
        }
    }

    override void onFrame() {

    }

    override void draw() {
    }


}