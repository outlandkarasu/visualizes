/**
Collatz animation module.
*/
module visualizes.collatz.animation;

import std.exception :
    enforce;
import std.string : toStringz;
import std.range : take, repeat, array;

import bindbc.sdl :
    SDL_CreateWindow,
    SDL_CreateRGBSurface,
    SDL_BlitSurface,
    SDL_DestroyWindow,
    SDL_GetWindowSurface,
    SDL_FreeSurface,
    SDL_UpdateWindowSurface,
    SDL_WINDOW_SHOWN,
    SDL_Window,
    SDL_Delay,
    SDL_GetPerformanceFrequency,
    SDL_GetPerformanceCounter,
    SDL_Event,
    SDL_PollEvent,
    SDL_QUIT,
    SDL_WINDOWPOS_UNDEFINED;

import visualizes.sdl : sdlError;
import visualizes.collatz.collatz : Collatz;

enum FPS = 60;

/**
Animate collatz.

Params:
    width = image width
    height = image height
*/
void animateCollatz(uint width, uint height)
{
    auto window = enforce(SDL_CreateWindow("Collatz", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN), sdlError);
    scope(exit) SDL_DestroyWindow(window);
    auto windowSurface = enforce(SDL_GetWindowSurface(window), sdlError);

    auto surface = enforce(SDL_CreateRGBSurface(0, width, height, 32, 0, 0, 0, 0), sdlError);
    scope(exit) SDL_FreeSurface(surface);

    auto collatz = Collatz('1'.repeat(200).array);

    immutable performanceFrequency = SDL_GetPerformanceFrequency();
    immutable countPerFrame = performanceFrequency / FPS;
    mainLoop: for (uint x = 0;; ++x)
    {
        immutable frameStart = SDL_GetPerformanceCounter();
        for (SDL_Event e; SDL_PollEvent(&e);)
        {
            if (e.type == SDL_QUIT)
            {
                break mainLoop;
            }
        }

        foreach (n, b; collatz[].take(height))
        {
            if (b && x < width)
            {
                auto pixels = (cast(uint*)surface.pixels)[0 .. width * height];
                pixels[width * (height - n - 1) + x] = 0x00FF0000;
            }
        }

        enforce(SDL_BlitSurface(surface, null, windowSurface, null) == 0, sdlError);
        enforce(SDL_UpdateWindowSurface(window) == 0, sdlError);
        collatz.next();

        immutable drawDelay = SDL_GetPerformanceCounter() - frameStart;
        if(countPerFrame < drawDelay)
        {
            SDL_Delay(0);
        }
        else
        {
            SDL_Delay(cast(uint)((countPerFrame - drawDelay) * 1000 / performanceFrequency));
        }
    }
}

