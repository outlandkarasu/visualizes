/**
Application entry point module.
*/

import std.exception :
    enforce;
import std.stdio :
    writefln;
import std.string :
    format;

import bindbc.sdl :
    loadSDL,
    SDL_INIT_VIDEO,
    SDL_Init,
    SDL_Quit,
    sdlSupport,
    unloadSDL;
import bindbc.sdl.image :
    IMG_Init,
    IMG_INIT_PNG,
    IMG_Quit,
    loadSDLImage,
    sdlImageSupport,
    unloadSDLImage;

import visualizes.sdl : sdlError;
import visualizes.collatz : drawCollatz;

/**
Application entry point.
*/
int main()
{
    immutable loadedSDLVersion = loadSDL();
    enforce(loadedSDLVersion >= sdlSupport, format("loadSDL error: %s", loadedSDLVersion));
    scope(exit) unloadSDL();

    writefln("loaded SDL: %s", loadedSDLVersion);

    immutable loadedSDLImageVersion = loadSDLImage();
    enforce(loadedSDLImageVersion >= sdlImageSupport, format("loadSDL_Image error: %s", loadedSDLImageVersion));
    scope(exit) unloadSDLImage();
    
    writefln("loaded SDL_Image: %s", loadedSDLImageVersion);

    enforce(SDL_Init(SDL_INIT_VIDEO) == 0, sdlError);
    scope(exit) SDL_Quit();

    writefln("init SDL");
    enforce(IMG_Init(IMG_INIT_PNG) == IMG_INIT_PNG, sdlError);
    scope(exit) IMG_Quit();

    writefln("init SDL_Image");

    drawCollatz(640, 480, "test.png");

    return 0;
}

