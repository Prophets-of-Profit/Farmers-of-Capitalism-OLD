/**
 * "I feel like I have accomplished very much spending ~3 hours on a single line of easy code"
 *      -Saurabh Totey
 *
 * "Be careful not to choke on your aspirations"
 *      -Elia Gorokhovsky
 *
 * "I have PantheonTSD"
 *      -Kadin Tucker
 *
 * "I like caterpillars"
 *      -Gernene Tan
 *
 * A proprietary software written by Saurabh Totey, Elia Gorokhovsky, Gernene Tan and Kadin Tucker.
 *
 *    $$$$$$$$\                                                                       $$$$$$\         $$$$$$\                   $$\  $$\             $$\$$\
 *    $$  _____|                                                                     $$  __$$\       $$  __$$\                  \__| $$ |            $$ \__|
 *    $$ |  $$$$$$\  $$$$$$\ $$$$$$\$$$$\  $$$$$$\  $$$$$$\  $$$$$$$\        $$$$$$\ $$ /  \__|      $$ /  \__|$$$$$$\  $$$$$$\ $$\$$$$$$\   $$$$$$\ $$ $$\ $$$$$$$\$$$$$$\$$$$\
 *    $$$$$\\____$$\$$  __$$\$$  _$$  _$$\$$  __$$\$$  __$$\$$  _____|      $$  __$$\$$$$\           $$ |      \____$$\$$  __$$\$$ \_$$  _|  \____$$\$$ $$ $$  _____$$  _$$  _$$\
 *    $$  __$$$$$$$ $$ |  \__$$ / $$ / $$ $$$$$$$$ $$ |  \__\$$$$$$\        $$ /  $$ $$  _|          $$ |      $$$$$$$ $$ /  $$ $$ | $$ |    $$$$$$$ $$ $$ \$$$$$$\ $$ / $$ / $$ |
 *    $$ | $$  __$$ $$ |     $$ | $$ | $$ $$   ____$$ |      \____$$\       $$ |  $$ $$ |            $$ |  $$\$$  __$$ $$ |  $$ $$ | $$ |$$\$$  __$$ $$ $$ |\____$$\$$ | $$ | $$ |
 *    $$ | \$$$$$$$ $$ |     $$ | $$ | $$ \$$$$$$$\$$ |     $$$$$$$  |      \$$$$$$  $$ |            \$$$$$$  \$$$$$$$ $$$$$$$  $$ | \$$$$  \$$$$$$$ $$ $$ $$$$$$$  $$ | $$ | $$ |
 *    \__|  \_______\__|     \__| \__| \__|\_______\__|     \_______/        \______/\__|             \______/ \_______$$  ____/\__|  \____/ \_______\__\__\_______/\__| \__| \__|
 *                                                                                                                     $$ |
 *                                                                                                                     $$ |
 *                                                                                                                     \__|
 * Above text was made with http://patorjk.com/
 */
module app;

import std.algorithm;
import d2d;
import graphics.Constants;
import graphics.views.MainMenuActivity;

/** 
 * Entry point for the program
 */
void main() {
    Display mainDisplay = new Display(640, 480, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE,
            SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC | SDL_RENDERER_TARGETTEXTURE,
            "Farmers of Capitalism!");
    updateTextures(mainDisplay.renderer); //updateTextures is defined in graphics.Constants
    mainDisplay.activity = new MainMenuActivity(mainDisplay);
    mainDisplay.renderer.logicalSize = logicalSize; //logicalSize defined in graphics.Constants
    mainDisplay.eventHandlers ~= new class EventHandler {
        void handleEvent(SDL_Event event) {
            if (mainDisplay.keyboard.allKeys[SDLK_F11].testAndRelease()) {
                SDL_SetWindowFullscreen(mainDisplay.window.handle(), mainDisplay.window.info()
                        .canFind(SDL_WINDOW_FULLSCREEN_DESKTOP) ? 0 : SDL_WINDOW_FULLSCREEN_DESKTOP);
            }
        }
    };
    mainDisplay.window.icon = images[Image.Icon];
    mainDisplay.run();
}
