		     FIELDS ARE CURRIED FUNCTIONS

				  by

			   Gary T. Leavens
           Computer Science, University of Central Florida
                     $Date: 2013/02/20 01:19:13 $

INTRODUCTION

The earth and everything in it is held together
by forces that can be modeled with curried functions.
In this brief literate Haskell program,
an example of currying the gravitational force law
shows how curried functions can be used to model
the physical notion of the gravitational field,
and how a curried function allows for planned tools.


AN EXAMPLE

Consider the Newtonian gravitational force law as an example.
This might be coded in Haskell as in the function grav_force defined below.

> module Gravity where

> grav_force :: ((Kg, Meter, Kg) -> N)
> grav_force (m1, r, m2) =
>     if r == 0.0
>     then 0.0
>     else (big_G * m1 * m2)
>          / (square r)

In the definition of grav_force, the following type synonyms are used.

> type Kg = Double              -- i.e., kilograms
> type Meter = Double           -- i.e., m
> type N = Double               -- Newtons
> type N_x_m2_per_kg2 = Double  -- N$\cdot$m$^2$/kg$^2$

Also used in the definition of grav_force is the universal gravitational
constant, big_G.

> big_G :: N_x_m2_per_kg2
> big_G = 6.670e-11

Finally, here is the definition of the function square.

> square :: Double -> Double
> square r = r * r

Currying the function grav_force gives an excellent teaching example,
because at each stage of partial application, a useful function is
obtained.  The curried version of grav_force, grav_force_c, is below.
(It uses the definitions above for G and square.)

> grav_force_c :: (Kg -> (Meter -> (Kg -> N)))
> grav_force_c m1 r m2 =
>         if r == 0.0
>         then 0.0
> 	  else (big_G * m1 * m2)
>              / (square r)

(Incidently, defining curried functions like the above
is supported directly by the Haskell syntax.
This kind of definition is a standard idiom in Haskell.)

The following attempts to explain how curried functions work,
and at the same time explain their utility.
Suppose we want to work with the gravitational
force exerted by the earth.  To do this we would pass to
grav_force_c the mass of the earth.

> earths_force_fun :: (Meter -> (Kg -> N))
> earths_force_fun = grav_force_c mass_of_earth
>        	     where mass_of_earth = 5.96E24

Passing any other mass, such as the mass of the galaxy or a student,
to grav_force_c, gives an analogous function for that mass.
This illustrates the use of curried functions as tool-makers.

The function earths_force_fun is itself a curried function,
(and is analogous to a gravititional field, see the my technical report
referenced below for details).  To fix a distance from the earth's center,
one passes that distance to earths_force_fun.  For example, to
work with the force at the surface of the earth, we pass
the radius of the earth to it.

> earths_force_at_surface :: (Kg -> N)
> earths_force_at_surface =  let radius_of_earth = 6.37E6
>                            in earths_force_fun radius_of_earth

Passing any other radius from the earth's center to earths_force_fun,
such as the distance from the earth's center to the orbit of the
space shuttle, or to the sun or moon, gives an analogous function
for that radius.

The function earths_force_at_surface can be used to find the
magnitude of the force exerted on any given mass at the earth's surface.
For example, the magnitude of force exerted on a mass of 68 kilograms
(about 150 pounds) would be calculated by the following expression.

> force_on_150_lbs :: N
> force_on_150_lbs = earths_force_at_surface 68.039

Of course, one can use earths_force_at_surface with other masses.


FIELDS ARE LIKE CURRIED FUNCTIONS

Turning this example around, curried functions can also be used
to help understand fields in Physics.  For a discussion of this,
more details on the above, and historical references, see my technical report
"Fields in Physics are like Curried Functions
or Physics for Functional Programmers" (Department of Computer Science,
Iowa State University, Technical Report \#94-06b, April 1994,
revised May 1994).  (This technical report has code examples written
in Scheme.)  You can get using the following URL.

	http://www.eecs.ucf.edu/~leavens/main.html
