-- $Id: GravityTests.hs,v 1.1 2013/02/20 01:19:13 leavens Exp leavens $
module GravityTests where

import Gravity
import Testing
import FloatTesting

main = dotests "GravityTests $Revision: 1.1 $" tests

radius_of_earth :: Meter
radius_of_earth = 6.37e6

mass_of_earth :: Kg
mass_of_earth = 5.96e24

suns_force = grav_force_c suns_mass
    where suns_mass = 1.9891e30 :: Kg

suns_force_at_earth_orbit = suns_force au
    where au = 1.496e11 :: Meter

tests :: [TestCase N]
tests = 
    [withinTest (earths_force_at_surface 1.0) "~=~" 9.79700272815321
    ,withinTest (grav_force_c 1.0 1.0 1.0) "~=~" big_G
    ,withinTest force_on_150_lbs "~=~" 666.5782686208163
    ,withinTest (suns_force_at_earth_orbit mass_of_earth) 
     "~=~" 3.5331780523463635e22
    ]
