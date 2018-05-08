# Improved Tow Truck Script
A modified version of Asser90's tow script with multiple fixes and improvements.

## Important Note:
Script is designed to work with the regular GTA V FLATBED model, as well as with 2 other modified flatbeds, which I have included. To use this script with other flatbed models the placement values will have to be adjusted, this can be done by following the instructions at the top of the `client.lua` file.

- Credit for the Mule flatbed (flatbed2) goes to TheF3nt0n.
- Credit for the flatbed3 model goes to BrewCityBass.

## Features:
- Fixes attach/detach positions on both truck and ground. No more upside down cars when detaching!
- No more "jello" vehicles that stretch and warp when being towed.
- Can no longer detach a vehicle while the truck is moving or attach vehicles while they are moving.
- Vehicles will detach if the truck flips over.
- Improved notifications.
- The vehicle that you want to tow needs to be within 12m of your towtruck. (configurable in the `client.lua` file)
- Large vehicles cannot be towed. (configurable in the `client.lua` file)
- You can have multiple towtrucks registered and have custom x,y,z offsets. (configurable in the `client.lua` file)

## How it works:
- Using a trainer spawn `flatbed`, `flatbed2` or `flatbed3` and get in.
- When you find a vehicle to tow, get out and walk up to the vehicle.
- While facing the vehicle type `/tow` in chat to attach the vehicle to the flatbed.
- Once at your destination, get out of the truck and type `/tow` in chat again to detach the vehicle from the flatbed.

## Known Bugs/Issues:
- If another player is close to you when the command is entered the vehicle may not attach/detach. **Ask them to step away.** 
The cause of this has been identified as the raycast is detecting the other player instead of the vehicle.
- Having another player (passenger) in the flatbed with you is known to cause issues with attaching/detaching vehicles. You may want to RP that it is against company policy to have passengers. Use your imagination for now. :)

#### Join my Discord: http://discord.me/deziel
