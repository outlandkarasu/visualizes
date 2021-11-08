/**
Draw collatz module.
*/
module visualizes.collatz.draw;

import std.exception :
    enforce;
import std.string : toStringz;

import bindbc.sdl :
    IMG_SavePNG,
    SDL_CreateRGBSurface,
    SDL_CreateSoftwareRenderer,
    SDL_DestroyRenderer,
    SDL_FreeSurface,
    SDL_RenderClear,
    SDL_RenderDrawPoint,
    SDL_RenderPresent,
    SDL_SetRenderDrawColor;

import visualizes.sdl : sdlError;

/**
Draw collatz.

Params:
    width = image width
    height = image height
    path = image file path
*/
void drawCollatz(uint width, uint height, scope const(char)[] path)
{
    auto surface = enforce(SDL_CreateRGBSurface(0, width, height, 32, 0, 0,0, 0), sdlError);
    scope(exit) SDL_FreeSurface(surface);

    auto renderer = enforce(SDL_CreateSoftwareRenderer(surface), sdlError);
    scope(exit) SDL_DestroyRenderer(renderer);

    enforce(SDL_SetRenderDrawColor(renderer, 0, 0, 0, 0) == 0, sdlError);
    enforce(SDL_RenderClear(renderer) == 0, sdlError);
    SDL_RenderPresent(renderer);

    enforce(IMG_SavePNG(surface, path.toStringz) == 0, sdlError);
}

