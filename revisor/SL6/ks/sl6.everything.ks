# Kickstart file for composing the "SL 6" spin of RHEL 6
# Use a part of 'iso' to define how large you want your isos.
# Only used when composing to more than one iso.
# Default is 695 (megs), CD size. unless "revisor -cli --install-dvd" is used
# where the default size is a DVD 
# Listed below is the size of a DVD if you wanted to split higher.

#part iso --size=4998

#timezone America/Chicago

# Package manifest for the compose. 
# Need to use "kickstart_manifest = 1" in your /etc/revisor.conf file
# to enable this file to be used as the definition of what is included
# in the compose , otherwise the "comps" file defines the compose
##########################
%packages 
*
%end
