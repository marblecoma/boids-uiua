# Boids in Uiua
Boids in Uiua using [Iris](https://github.com/Marcos-cat/iris)

This is a basic implementation of Craig Reynolds [Boids](https://en.wikipedia.org/wiki/Boids). Parameters of the program, such as the screen size, number of boids, perception radius, and impact of forces can be configured at the top of the file. 

I have switched everything over to data defs for the boids. I have implemented firefly behavior of flashing and nudging the timers based on neighbor flashing based on [fireflies](https://ncase.me/fireflies/). 

Holding down the left mouse button will cause the boids to chase the mouse position in the non-data defs version. 

## TODO

- Quadtree?
- <s>Allow program to be reset via keyboard command</s>
- <s>Allow dynamic control of strength of each force</s>
- Make the flashing a singular event
