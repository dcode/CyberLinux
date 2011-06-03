# Kickstart file for composing the "SL 6" spin of RHEL 6
# Use a part of 'iso' to define how large you want your isos.
# Only used when composing to more than one iso.
# Default is 695 (megs), CD size. unless "revisor -cli --install-dvd" is used
# where the default size is a DVD
# Listed below is the size of a DVD if you wanted to split higher.
#part iso --size=4998

#timezone America/Chicago


# Package manifest for the compose.  Uses repo group metadata to translate groups.
# (@base is added by default unless you add --nobase to %packages)
# (default groups for the configured repos are added by --default)
##########################
%packages --default
@additional-devel
@backup-client
@backup-server
@base
@basic-desktop
@cifs-file-server
@compat-libraries
@console-internet
@core
@debugging
@desktop-debugging
@desktop-platform
@desktop-platform-devel
@development
@dial-up
@directory-client
@directory-server
@eclipse
@emacs
@fonts
@ftp-server
@general-desktop
@graphical-admin-tools
@graphics
@hardware-monitoring
@infiniband
@input-methods
@internet-applications
@internet-browser
@java-platform
@kde-desktop
@large-systems
@legacy-unix
@legacy-x
@mail-server
@mainframe-access
@misc-sl
@mysql
@mysql-client
@network-file-system-client
@network-server
@network-tools
@nfs-file-server
@openafs-client
@office-suite
@performance
@perl-runtime
@php
@postgresql
@postgresql-client
@print-client
@print-server
@repos
@remote-desktop-clients
@scientific
@security-tools
@server-platform
@server-platform-devel
@smart-card
@spins
@storage-client-fcoe
@storage-client-iscsi
@storage-client-multipath
@storage-server
@system-admin-tools
@system-management
@system-management-messaging-client
@system-management-messaging-server
@system-management-snmp
@system-management-wbem
@technical-writing
@tex
@turbogears
@virtualization
@virtualization-client
@virtualization-platform
@virtualization-tools
@web-server
@web-servlet
@x11
tcsh
kernel*
selinux-policy*
policycoreutils*
anaconda
%end
