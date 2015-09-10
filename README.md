# flashrd-bridge

Flashrd-bridge is a (yet another) attempt to build a small, easily managed small/embedded system to function as a Tor bridge in a small office/residential environment.

Flashrd (http://www.nmedia.net/flashrd/) is a build system for creating custom OpenBSD images to run on flash media.

Tor bridges (https://www.torproject.org/) are hidden gateways into the Tor public anonymity network which cater to end-users in censored environments.

Flashrd-bridge is not intended for anything more than a simple Tor bridge. It will provide configuration and bridge information over the local network while all configuration is currently done from the shell interface. Future versions may include a web interface for configuration changes.

Flashrd system updates are performed automatically using public servers. The current version is checked, and the new image files are downloaded to the device. Upon reboot, the new system attempts to run. In the event the new system does not work correctly, Flashrd defers to the old image files.

The target architecture for Flashrd-bridge is currently only amd64 and i386 systems, such as Soekris, Alix and APU boards, the latter two produced by PCEngines.
