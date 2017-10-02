module graphics.panel.Panel;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

/**
 * A screen object with a location and dimensions
 */
class Panel {

    int[2] location;        ///The location of this panel on the screen
    int[2] dimensions;      ///The size of this panel
    bool isEnabled;         ///Whether or not this panel is to be displayed
    SDL_Surface* image;     ///The image to be displayed for this panel

    /**
     * Returns whether or not a point in within the boundaries of the panel
     */
    bool isPointInPanel(int[2] point){
        return point[0] - this.location[0] > 0 && point[0] - this.location[0] < this.dimensions[0] && point[1] - this.location[1] > 0 && point[1] - this.location[1] < this.dimensions[1];
    }

    /**
     *
     */
    void displayPanel(Surface* toBlitTo){
        //TODO: figure out how to do this without it not working
    }

}
