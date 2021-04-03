# SetCollisionGroup
The right way to set the collision group in CS:S/CS:GO (and TF2).

The typical way to set collision groups through SourcePawn is through `SetEntData()`, but that leads to the "Physics Mayhem" bug where guns and other entities could fall through the map. Instead of changing the member variable directly (`m_CollisionGroup`), we can just call a function within the game itself. This plugin does this for you.

If you would like to add the functionality for other games, feel free to open a Pull Request and I will accept it. Currently, it only works for CS:S on Linux and Windows.

## Authors:
* [destoer](https://github.com/destoer)
* [me](https://github.com/ashort96)

## Contributors
* [Scags](https://github.com/Scags)

## Credits:
* <https://bugs.alliedmods.net/show_bug.cgi?id=6348>
* <https://web.archive.org/web/20190406220848/https://forum.facepunch.com/gmoddev/likl/Crazy-Physics-cause-found/1/>
