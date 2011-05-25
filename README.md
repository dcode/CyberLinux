# CND Linux

This is a *slow* work in progress. I intend to use the [spin](http://spins.fedoraproject.org/about) framework from [Fedora](http://fedoraproject.org) to rebrand and modify the default install of [Scientific Linux](http://www.scientificlinux.org) to be suitable for use on a US Government network according to Federal Information Processing Standards (FIPS). Specifically, this will target DoD usage.

## Features

Some of the features that I plan to include:

 * Rebranding
 * Login Banners
 * Smart Card (CAC/PIV) authentication
 * Full-Disk Encryption (possibily with SmartCard authentication)
 * Baseline of [Security Technical Implementation Guides](http://iase.disa.mil/stigs/stig/index.html)(STIGs)

I intend to build all of this into a Kickstart-able installation. I've done some initial work of getting SmartCard authentication into the disk encryption pre-boot. The CAC/PIV smart cards add some additional challenges beyond open source cards.
