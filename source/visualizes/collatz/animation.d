/**
Collatz animation module.
*/
module visualizes.collatz.animation;

import std.exception :
    enforce;
import std.string : toStringz;
import std.range : take, repeat, array;

import bindbc.sdl :
    SDL_CreateWindowAndRenderer,
    SDL_DestroyRenderer,
    SDL_DestroyWindow,
    SDL_FreeSurface,
    SDL_RenderClear,
    SDL_RenderDrawPoint,
    SDL_RenderPresent,
    SDL_SetRenderDrawColor,
    SDL_WINDOW_SHOWN,
    SDL_Window,
    SDL_Renderer,
    SDL_Delay,
    SDL_GetPerformanceFrequency,
    SDL_GetPerformanceCounter,
    SDL_Event,
    SDL_PollEvent,
    SDL_QUIT;

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
    SDL_Window* window;
    SDL_Renderer* renderer;
    enforce(SDL_CreateWindowAndRenderer(width, height, SDL_WINDOW_SHOWN, &window, &renderer) == 0, sdlError);
    scope(exit)
    {
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
    }

    enforce(SDL_SetRenderDrawColor(renderer, 144, 170, 203, 255) == 0, sdlError);
    enforce(SDL_RenderClear(renderer) == 0, sdlError);
    enforce(SDL_SetRenderDrawColor(renderer, 243, 241, 245, 255) == 0, sdlError);

    auto collatz = Collatz('1'.repeat(100).array);

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
                enforce(SDL_RenderDrawPoint(renderer, x, cast(uint)(height - n - 1)) == 0, sdlError);
            }
        }

        SDL_RenderPresent(renderer);
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

