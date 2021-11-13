/**
Automaton draw module.
*/
module visualizes.automaton.draw;

import std.algorithm : swap, min, max;
import std.exception :
    enforce;
import std.string : toStringz;
import std.range : take, repeat, array;

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
import visualizes.automaton.automaton : Automaton;

/**
Draw automaton.

Params:
    width = image width
    height = image height
    path = image file path
*/
void drawAutomaton(uint width, uint height, scope const(char)[] path)
{
    auto surface = enforce(SDL_CreateRGBSurface(0, width, height, 32, 0, 0,0, 0), sdlError);
    scope(exit) SDL_FreeSurface(surface);

    auto renderer = enforce(SDL_CreateSoftwareRenderer(surface), sdlError);
    scope(exit) SDL_DestroyRenderer(renderer);

    enforce(SDL_SetRenderDrawColor(renderer, 0xFE, 0xF5, 0xED, 255) == 0, sdlError);
    enforce(SDL_RenderClear(renderer) == 0, sdlError);

    enforce(SDL_SetRenderDrawColor(renderer, 0x87, 0xAA, 0xAA, 255) == 0, sdlError);

    auto automaton = Automaton(30);
    immutable bitsCount = 10000;
    auto bits1 = new ubyte[](bitsCount);
    auto bits2 = new ubyte[](bitsCount);
    auto bits = bits1;
    auto bitsNext = bits2;

    immutable center = bitsCount / 2;
    bits[center] = 1;
    immutable left = max(0, center - width / 2);
    immutable right = left + width;
    immutable offset = height / 4;

    foreach (y; offset .. height)
    {
        foreach (n, b; bits[left .. right])
        {
            if (b)
            {
                enforce(SDL_RenderDrawPoint(renderer, cast(uint)n, y) == 0, sdlError);
            }
        }

        automaton.apply(bits, bitsNext);
        bitsNext.swap(bits);
    }

    SDL_RenderPresent(renderer);
    enforce(IMG_SavePNG(surface, path.toStringz) == 0, sdlError);
}

