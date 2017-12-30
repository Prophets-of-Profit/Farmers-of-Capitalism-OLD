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
 * A proprietary software written by Saurabh Totey, Elia Gorokhovsky, and Kadin Tucker.
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

import d2d;
import graphics.Constants;
import graphics.screens.MainMenuScreen;


/** 
 * Entry point for the program
 */
void main() {
    Display mainDisplay = new Display(640, 480, SDL_WINDOW_SHOWN, "Farmers of Capitalism!", Image.Temp_Icon);
    mainDisplay.screen = new MainMenuScreen(mainDisplay);
    mainDisplay.run();
}