/**
Draw collatz module.
*/
module visualizes.collatz.draw;

import std.exception :
    enforce;
import std.string : toStringz;
import std.range : take;

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
import visualizes.collatz.collatz : Collatz;

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

    enforce(SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255) == 0, sdlError);

    auto collatz = Collatz("11011");
    foreach (y; 0 .. height)
    {
        foreach (n, b; collatz[].take(width))
        {
            if (b)
            {
                enforce(SDL_RenderDrawPoint(renderer, cast(uint)(width - 1 - n), y) == 0, sdlError);
            }
        }

        if (collatz[].length <= 1)
        {
            break;
        }

        collatz.next();
    }

    SDL_RenderPresent(renderer);
    enforce(IMG_SavePNG(surface, path.toStringz) == 0, sdlError);
}

