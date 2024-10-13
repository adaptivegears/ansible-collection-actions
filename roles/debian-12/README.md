# Debian 12 (AMD64)

Base Image:
- https://www.debian.org/CD/netinst/
- https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.7.0-amd64-netinst.iso

Minimal Installation that includes: OpenSSH server

Fully functional but purposely bare minimal image of the server.

```shell
____  _                 _               _
/ ___|| |_ __ _ _ __   __| | __ _ _ __ __| |
\___ \| __/ _` | '_ \ / _` |/ _` | '__/ _` |
___) | || (_| | | | | (_| | (_| | | | (_| |
|____/ \__\__,_|_| |_|\__,_|\__,_|_|  \__,_|

____       _     _             _ ____
|  _ \  ___| |__ (_) __ _ _ __ / |___ \
| | | |/ _ \ '_ \| |/ _` | '_ \| | __) |
| |_| |  __/ |_) | | (_| | | | | |/ __/
|____/ \___|_.__/|_|\__,_|_| |_|_|_____|
```

## Packages
Every listed requirement includes its dependencies, which are not listed or described.

### Kernel
https://packages.debian.org/bookworm/linux-image-amd64
`linux-image-amd64` meta-package provides the latest Linux kernel image for AMD64 architectures.

https://packages.debian.org/bookworm/kmod
`kmod` package provides tools for managing Linux kernel modules. It includes utilities for loading, unloading, and listing kernel modules.

https://packages.debian.org/bookworm/dmidecode
`dmidecode` package provides a tool for dumping DMI (Desktop Management Interface) data from the system BIOS. This information includes hardware details such as the system manufacturer, model, and serial number.

### Hardware

https://packages.debian.org/bookworm/firmware-linux-free
`firmware-linux-free` package provides firmware files for various hardware devices that are supported by the Linux kernel. These firmware files are necessary for the proper operation of certain hardware components.

https://packages.debian.org/bookworm/intel-microcode
`intel-microcode` package provides microcode updates for Intel CPUs. These updates fix processor bugs that could cause system instability or crashes, patch security vulnerabilities (like Spectre and Meltdown), and sometimes can improve CPU performance or power efficiency.
When installed, it updates the CPU's microcode early in the boot process. These updates are not permanent; they are applied each time the system boots.

https://packages.debian.org/bookworm/amd64-microcode
`amd64-microcode` packages provides microcode updates for AMD CPUs.

https://packages.debian.org/bookworm/discover
`discover` package provides hardware detection and configuration tools for Linux systems. It can detect hardware components and load the appropriate kernel modules to support them.

https://packages.debian.org/bookworm/dmidecode
`dmidecode` package provides information about the system's hardware as described in the system BIOS according to the SMBIOS/DMI standard.

https://packages.debian.org/bookworm/pciutils
`pciutils` package provides utilities for querying and displaying information about PCI devices in the system. It includes tools like `lspci` and `lspci`.

https://packages.debian.org/bookworm/udev
`udev` package provides a dynamic device management system for Linux. It manages device nodes in `/dev`, handles hotplug events, and provides a consistent device naming scheme.

### Bootloader
https://packages.debian.org/bookworm/efibootmgr
`efibootmgr` package provides a tool for managing UEFI boot entries. It allows you to view, create, modify, and delete boot entries in the UEFI firmware.

https://packages.debian.org/bookworm/grub-pc
`grub-pc` package provides the GRUB bootloader for BIOS-based systems. It allows the system to boot using the traditional BIOS firmware.

https://packages.debian.org/bookworm/grub-efi-amd64
`grub-efi-amd64` package provides GRUB bootloader files necessary for booting on UEFI-based systems. This package allows the system to boot using UEFI firmware instead of the traditional BIOS.

https://packages.debian.org/bookworm/grub-efi-amd64-signed
`grub-efi-amd64-signed` package provides signed versions of the GRUB bootloader files for UEFI-based systems. These signed files can be used with Secure Boot enabled to verify the integrity of the bootloader.

https://packages.debian.org/bookworm/shim-signed
`shim-signed` package provides a minimalist boot loader which allows verifying signatures of other UEFI binaries against either the Secure Boot DB/DBX or against a built-in signature database.

### System
https://packages.debian.org/bookworm/base-files
`base-files` package provides essential files and directories for the Debian base system. It includes configuration files, system scripts, and other core components.

https://packages.debian.org/bookworm/init-system-helpers
`init-system-helpers` package provides helper tools that are necessary for switching between the various init systems.

https://packages.debian.org/bookworm/sysvinit-utils
`sysvinit-utils` package provides utilities for managing the System V init system.

https://packages.debian.org/bookworm/init
`init` metapackage which allows you to select from the available init systems while ensuring that one of these is available on the system at all times.

https://packages.debian.org/bookworm/libc-bin
`libc-bin` package provides essential binaries for the GNU C Library (glibc). It includes core system utilities like `ldconfig`, `getconf`, and `iconv`.

https://packages.debian.org/bookworm/util-linux
`util-linux` package provides a suite of essential utilities for any Linux system. It includes tools for managing disks, partitions, and filesystems, as well as other system utilities.

https://packages.debian.org/bookworm/util-linux-extra
`util-linux-extra` package provides tools commonly found on systems where humans login interactively.

https://packages.debian.org/bookworm/tasksel-data
`tasksel-data` package provides data about the standard tasks available on a Debian system.

https://packages.debian.org/bookworm/cron
`cron` package provides the cron daemon, which is used to schedule and run periodic tasks on a Linux system.

https://packages.debian.org/bookworm/logrotate
`logrotate` package provides a utility for rotating log files on a Linux system. It allows you to automatically compress, rotate, and delete log files based on a specified configuration.

https://packages.debian.org/bookworm/dbus
`dbus` package provides the D-Bus message bus system, which allows applications to communicate with each other and the system.

https://packages.debian.org/bookworm/dbus-user-session
`dbus-user-session` package provides a D-Bus message bus for user sessions. It allows applications running in a user session to communicate with each other and the system.

https://packages.debian.org/bookworm/systemd
`systemd` package provides the systemd init system, which is the default init system for Debian. It manages system services, processes, and other system resources.

https://packages.debian.org/bookworm/systemd-resolved
`systemd-resolved` package provides a system service that provides network name resolution to local applications. It implements a caching DNS stub resolver and an LLMNR and MulticastDNS resolver.

https://packages.debian.org/bookworm/systemd-sysv
`systemd-sysv` package provides compatibility links for running System V init scripts under systemd.

https://packages.debian.org/bookworm/systemd-timesyncd
`systemd-timesyncd` package provides a simple NTP client for synchronizing the system clock with remote NTP servers.

https://packages.debian.org/bookworm/libnss-systemd
`libnss-systemd` package provides a Name Service Switch module for resolving hostnames using systemd-resolved.

https://packages.debian.org/bookworm/libpam-systemd
`libpam-systemd` package provides a PAM module for authenticating users and managing sessions using systemd-logind.

https://packages.debian.org/bookworm/lsb-release
`lsb-release` package provides the `lsb_release` command, which displays information about the Linux Standard Base (LSB) distribution.

https://packages.debian.org/bookworm/unattended-upgrades
`unattended-upgrades` package provides a utility for automatically installing security updates on a Debian system.

### Users and Groups
https://packages.debian.org/bookworm/base-passwd
`base-passwd` package provides essential system user and group accounts for the Debian base system. It includes accounts like `root`, `daemon`, `bin`, `sys`, and others.

https://packages.debian.org/bookworm/login
`login` package provides the `login` program, which is used to authenticate users and start a new session on the system. It is typically used to log in to the system via a text-based console or terminal.

https://packages.debian.org/bookworm/passwd
`passwd` package provides the `passwd` command, which is used to change a user's password on the system.

https://packages.debian.org/bookworm/sudo
`sudo` package provides the `sudo` command, which allows users to run commands with the privileges of another user, typically the root user.

### File System
https://packages.debian.org/bookworm/mount
`mount` package provides the `mount` and `umount` commands, which are used to mount and unmount filesystems.

https://packages.debian.org/bookworm/fdisk
`fdisk` package provides a disk partitioning utility. It allows users to create, delete, and manage disk partitions on Linux systems.

https://packages.debian.org/bookworm/lvm2
`lvm2` package provides the Logical Volume Manager (LVM) tools for managing logical volumes and volume groups on Linux systems.

https://packages.debian.org/bookworm/e2fsprogs
`e2fsprogs` package provides utilities for managing ext2, ext3, and ext4 filesystems. It includes tools like `mkfs.ext2`, `mkfs.ext3`, `mkfs.ext4`, and `fsck`.

### Shells

https://packages.debian.org/bookworm/bash
`bash` package provides the GNU Bourne-Again SHell (Bash), which is the default shell for most Linux distributions. It provides a command-line interface for interacting with the system and running shell scripts.

https://packages.debian.org/bookworm/bash-completion
`bash-completion` package provides programmable completion for the Bash shell. It enhances the shell's tab-completion feature by providing completions for various commands, options, and arguments.

https://packages.debian.org/bookworm/dash
`dash` package provides the Debian Almquist Shell (Dash), which is a lightweight POSIX-compliant shell. It is used as the default system shell for Debian systems.

https://packages.debian.org/bookworm/busybox
`busybox` package provides a single binary that includes a collection of common Unix utilities.

https://packages.debian.org/bookworm/bsdutils
`bsdutils` package provides bare minimum of BSD utilities needed. It includes tools like `logger`, `renice`, and `script`.

https://packages.debian.org/bookworm/bsdextrautils
`bsdextrautils` package provides extra BSD utilities: `col`, `colcrt`, `colrm`, `column`, `hd`, `hexdump`.

https://packages.debian.org/bookworm/coreutils
`coreutils` package provides a set of essential command-line utilities for managing files, directories, and text streams. It includes tools like `ls`, `cp`, `mv`, `rm`, and many others.

https://packages.debian.org/bookworm/diffutils
`diffutils` package provides utilities for comparing and merging files. It includes tools like `diff`, `cmp`, and `diff3`.

https://packages.debian.org/bookworm/findutils
`findutils` package provides utilities for finding files and directories on a Linux system. It includes tools like `find`, `locate`, and `xargs`.

https://packages.debian.org/bookworm/debianutils
`debianutils` package provides various Debian-specific utilities. It includes tools like `run-parts`, and `which`.

https://packages.debian.org/bookworm/procps
`procps` package provides utilities for monitoring and managing processes on a Linux system. It includes tools
like `ps`, `top`, `kill`, and `free`.

https://packages.debian.org/bookworm/psmisc
`psmisc` package provides additional utilities for managing processes on a Linux system. It includes tools like `fuser`, `killall`, and `pstree`.

https://packages.debian.org/bookworm/lsof
`lsof` package provides a utility for listing open files on a Linux system. It allows you to see which files are currently open by which processes.

https://packages.debian.org/bookworm/file
`file` package provides a utility for determining the type of a file. It uses a magic number database to identify file types based on their contents.

https://packages.debian.org/bookworm/readline-common
`readline-common` package provides common files for the GNU Readline library, which is used for command-line editing in various programs.

https://packages.debian.org/bookworm/ncurses-bin
`ncurses-bin` package provides utilities for working with the ncurses text-based user interface library. It includes tools like `clear`, `tput`, and `infocmp`.

https://packages.debian.org/bookworm/ncurses-term
`ncurses-term` package provides terminal definitions for the ncurses library. It includes terminfo database entries for various terminal types.

https://packages.debian.org/bookworm/whiptail
`whiptail` package provides a utility for creating dialog boxes in shell scripts. It allows you to create interactive text-based interfaces for user input and feedback.

### Editors

https://packages.debian.org/bookworm/mawk
`mawk` package provides the Mawk interpreter, which is a fast and small implementation of the AWK programming language.

https://packages.debian.org/bookworm/nano
`nano` package provides a simple and easy-to-use text editor for the command line. It is designed to be user-friendly and accessible to new users.

https://packages.debian.org/bookworm/vim-tiny
`vim-tiny` package provides a minimal version of the Vim text editor. It includes essential features for editing text files in a terminal environment.

https://packages.debian.org/bookworm/less
`less` package provides a pager program for viewing text files one page at a time. It allows users to scroll through files and search for specific content.

https://packages.debian.org/bookworm/grep
`grep` package provides the `grep` command, which is used to search text files for lines that match a specified pattern. It supports regular expressions for more complex searches.

https://packages.debian.org/bookworm/sed
`sed` package provides the `sed` command, which is a stream editor for filtering and transforming text. It allows users to perform text manipulation operations on input streams.

### Package Management

https://packages.debian.org/bookworm/apt
`apt` package provides the Advanced Package Tool (APT) for managing software packages on Debian-based systems. It allows users to install, update, and remove packages from the system.

https://packages.debian.org/bookworm/apt-listchanges
`apt-listchanges` package provides a tool for displaying changelogs when installing or upgrading packages with APT. It allows users to see what changes have been made in new package versions.

https://packages.debian.org/bookworm/apt-transport-https
`apt-transport-https` package provides support for downloading packages over HTTPS using APT. It ensures that packages are securely downloaded from the Debian repositories.

https://packages.debian.org/bookworm/apt-utils
`apt-utils` package provides various utilities for working with APT, such as `apt-get`, `apt-cache`, and `apt-listchanges`.

https://packages.debian.org/bookworm/debian-archive-keyring
`debian-archive-keyring` package provides the public keys used by the Debian archive to verify package signatures. It is essential for ensuring the authenticity of packages downloaded from the Debian repositories.

https://packages.debian.org/bookworm/dpkg
`dpkg` package provides the Debian package management system for installing, removing, and managing software packages on Debian-based systems.

### Compression

https://packages.debian.org/bookworm/cpio
`cpio` package provides the `cpio` command, which is used to create and extract archives in the cpio format. It is commonly used in conjunction with `tar` for creating and managing backups.

https://packages.debian.org/bookworm/tar
`tar` package provides the `tar` command, which is used to create and extract tar archives. It supports various compression formats and options for managing files and directories.

https://packages.debian.org/bookworm/gzip
`gzip` package provides the `gzip` command, which is used to compress and decompress files using the GNU Zip (Gzip) algorithm.

https://packages.debian.org/bookworm/bzip2
`bzip2` package provides the `bzip2` command, which is used to compress and decompress files using the Burrows-Wheeler block-sorting text compression algorithm.

https://packages.debian.org/bookworm/xz-utils
`xz-utils` package provides the `xz` command, which is used to compress and decompress files using the LZMA algorithm.

https://packages.debian.org/bookworm/zstd
`zstd` package provides the `zstd` command, which is used to compress and decompress files using the Zstandard compression algorithm.

### Networking
https://packages.debian.org/bookworm/hostname
`hostname` package provides the `hostname` command, which is used to set or display the system's hostname.

https://packages.debian.org/bookworm/netbase
`netbase` package provides the necessary infrastructure for basic TCP/IP based networking.

https://packages.debian.org/bookworm/ifupdown
`ifupdown` package provides the `ifup` and `ifdown` commands, which are used to configure and manage network interfaces on Debian systems.

https://packages.debian.org/bookworm/iputils-ping
`iputils-ping` package provides the `ping` command, which is used to test network connectivity by sending ICMP echo requests to a remote host.

https://packages.debian.org/bookworm/isc-dhcp-client
`isc-dhcp-client` package provides the DHCP client for automatically configuring network interfaces using the Dynamic Host Configuration Protocol (DHCP).

https://packages.debian.org/bookworm/isc-dhcp-common
`isc-dhcp-common` package provides common files and utilities for the ISC DHCP client and server.

https://packages.debian.org/bookworm/nftables
`nftables` package provides the nftables framework for packet filtering and network address translation on Linux systems.

https://packages.debian.org/bookworm/iptables
`iptables` package provides the `iptables` command, which is used to configure packet filtering rules in the Linux kernel's netfilter framework.

https://packages.debian.org/bookworm/traceroute
`traceroute` package provides the `traceroute` command, which is used to trace the route packets take to a destination host on the network.

https://packages.debian.org/bookworm/openssh-server
`openssh-server` package provides the OpenSSH server for secure remote access and file transfer over the SSH protocol.

https://packages.debian.org/bookworm/openssh-client
`openssh-client` package provides the OpenSSH client for secure remote access and file transfer over the SSH protocol.

https://packages.debian.org/bookworm/task-ssh-server
`task-ssh-server` package provides a metapackage for installing an SSH server on Debian systems.

https://packages.debian.org/bookworm/bind9-dnsutils
`bind9-dnsutils` package provides the `dig` and `nslookup` commands for querying DNS servers and troubleshooting DNS issues.

https://packages.debian.org/bookworm/inetutils-telnet
`inetutils-telnet` package provides the `telnet` command, which is used to establish interactive text-based communication with a remote host over the Telnet protocol.

https://packages.debian.org/bookworm/socat
`socat` package provides the `socat` command, which is used to establish bidirectional data transfers between two endpoints over various protocols.

https://packages.debian.org/bookworm/tcpdump
`tcpdump` package provides the `tcpdump` command, which is used to capture and analyze network traffic on a Linux system.

https://packages.debian.org/bookworm/ca-certificates
`ca-certificates` package provides a collection of trusted CA certificates for verifying the authenticity of SSL/TLS connections.

https://packages.debian.org/bookworm/wget
`wget` package provides the `wget` command, which is used to download files from the web using HTTP, HTTPS, and FTP protocols.

https://packages.debian.org/bookworm/curl
`curl` package provides the `curl` command, which is used to transfer data to or from a server using various protocols, including HTTP, HTTPS, and FTP.

https://packages.debian.org/bookworm/media-types
`media-types` package provides the MIME media types for various file formats used in web content and email attachments.

### Virtualization
https://packages.debian.org/bookworm/qemu-guest-agent
`qemu-guest-agent` package provides the QEMU guest agent for communication between the host and guest systems in virtualized environments.

https://packages.debian.org/bookworm/qemu-utils
`qemu-utils` package provides various utilities for working with QEMU virtual machines, such as `qemu-img` for managing disk images.

### Cloud
https://packages.debian.org/bookworm/cloud-init
`cloud-init` package provides the cloud initialization tool for configuring cloud instances on various cloud platforms, such as AWS, Azure, and Google Cloud.

https://packages.debian.org/bookworm/cloud-utils
`cloud-utils` package provides various utilities for working with cloud images and instances.

### Perl
https://packages.debian.org/bookworm/perl-base
`perl-base` package provides the base Perl interpreter and essential modules for running Perl scripts on Debian systems.

https://packages.debian.org/bookworm/perl
`perl` package provides the full Perl interpreter and additional modules for developing and running Perl scripts on Debian systems.

### Python
https://packages.debian.org/bookworm/python3
`python3` package provides the Python 3 interpreter and standard library for developing and running Python scripts on Debian systems.

https://packages.debian.org/bookworm/python3-requests
`python3-requests` package provides the `requests` library for making HTTP requests in Python scripts.

### Locale
https://packages.debian.org/bookworm/tzdata
`tzdata` package provides the time zone and daylight-saving time data for various regions around the world. It is used by the system to determine the local time and manage time zone settings.

https://packages.debian.org/bookworm/locales
`locales` package provides locale data for various languages and regions. It includes translations, character sets, and other settings for internationalization and localization.

https://packages.debian.org/bookworm/locales-all
`locales-all` package provides all available locale data for internationalization and localization on Debian systems.

https://packages.debian.org/bookworm/debconf-i18n
`debconf-i18n` package provides internationalization support for the Debian Configuration Management System (Debconf). It includes translations for various languages.

### Cryptography
https://packages.debian.org/bookworm/gnupg2
`gnupg2` package provides the GNU Privacy Guard (GPG) tool for secure communication and data encryption using public-key cryptography.

https://packages.debian.org/bookworm/gpgv
`gpgv` package provides the GNU Privacy Guard (GPG) verification tool for verifying the authenticity of signed packages and files.

### Miscellaneous

https://packages.debian.org/bookworm/distro-info-data
`distro-info-data` package provides information about the Debian distribution, including release names, codenames, and release dates.

https://packages.debian.org/bookworm/publicsuffix
`publicsuffix` package provides a list of domain name suffixes (TLDs) for use in web browsers and other applications to prevent domain name spoofing and phishing attacks.

https://packages.debian.org/bookworm/iso-codes
`iso-codes` package provides a collection of ISO standards for country, language, and currency codes. It is used in various applications for internationalization and localization.
