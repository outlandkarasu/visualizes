/**
Application entry point module.
*/

import std.exception : enforce;
import std.stdio :
    stderr,
    writefln;
import std.string :
    format,
    fromStringz;

import bindbc.sdl :
    loadSDL,
    SDL_GetError,
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

string sdlError() nothrow
{
    return SDL_GetError().fromStringz.idup;
}

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

    return 0;
}

