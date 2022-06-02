% ADB(1) android-platform-system-core | adb Manuals
% The Android Open Source Project

# NAME

adb - Android Debug Bridge

# SYNOPSIS

**adb** [-d|-e|-s _serialNumber_] _command_

# DESCRIPTION

WARNING: This manual might be outdated, please refer to the official
documentation.

Android Debug Bridge (**adb**) is a versatile command line tool that lets you
communicate with an emulator instance or connected Android-powered device. It is
a client-server program that includes three components:

  * **A client**, which sends commands. The client runs on your development
    machine. You can invoke a client from a shell by issuing an **adb** command.
    Other Android tools such as DDMS also create **adb** clients.
  * **A daemon**, which runs commands on a device. The daemon runs as a
    background process on each emulator or device instance.
  * **A server**, which manages communication between the client and the daemon.
    The server runs as a background process on your development machine.

If there's only one emulator running or only one device connected, the **adb**
command is sent to that device by default. If multiple emulators are running
and/or multiple devices are attached, you need to use the **-d**, **-e**, or
**-s** option to specify the target device to which the command should be
directed.

# OPTIONS

-a
: Directs **adb** to listen on all interfaces for a connection.

-d
: Directs command to the only connected USB device. Returns an error if more
  than one USB device is present.

-e
: Directs command to the only running emulator. Returns an error if more than
  one emulator is running.

-s _specific device_
: Directs command to the device or emulator with the given serial number or
  qualifier. Overrides **ANDROID_SERIAL** environment variable.

-p _product name or path_
: Simple product name like **sooner**, or a relative/absolute path to a product
  out directory like **out/target/product/sooner**. If **-p** is not specified,
  the **ANDROID_PRODUCT_OUT** environment variable is used, which must be an
  absolute path.

-H
: Name of adb server host (default: **localhost**)

-P
: Port of adb server (default: **5037**)

# COMMANDS

adb devices [-l]
: List all connected devices. **-l** will also list device qualifiers.

adb connect _host_[:_port_]
: Connect to a device via TCP/IP. Port **5555** is used by default if no port
  number is specified.

adb disconnect [_host_[:_port_]]
: Disconnect from a TCP/IP device. Port **5555** is used by default if no port
  number is specified. Using this command with no additional arguments will
  disconnect from all connected TCP/IP devices.

## Device commands

adb push _local_... _remote_
: Copy file/dir to device.

adb pull [-a] _remote_ [_local_]
: Copy file/dir from device. **-a** means copy timestamp and mode.

adb sync [-l] [_directory_]
: Copy host->device only if changed. **-l** means list but don't copy.

If _directory_ is not specified, **/system**, **/vendor** (if present), **/oem**
(if present) and **/data** partitions will be updated.

If it is **system**, **vendor**, **oem** or **data**, only the corresponding
partition is updated.

adb shell [-e _escape_] [-n] [-T|-t] [-x] [_command_]
: Run remote shell command (interactive shell if no command given)

  * -e: Choose escape character, or **none**; default **~**
  * -n: Don't read from stdin
  * -T: Disable PTY allocation
  * -t: Force PTY allocation
  * -x: Disable remote exit codes and stdout/stderr separation

adb emu _command_
: Run emulator console command

adb logcat [_filter-spec_]
: View device log.

adb forward --list
: List all forward socket connections. The format is a list of lines with the
  following format: **_serial_ " " _local_ " " _remote_ "\n"**

adb forward _local_ _remote_
: Forward socket connections.

Forward specs are one of:

  * tcp:_port_
  * localabstract:_unix domain socket name_
  * localreserved:_unix domain socket name_
  * localfilesystem:_unix domain socket name_
  * dev:_character device name_
  * jdwp:_process pid_ (remote only)

adb forward --no-rebind _local_ _remote_
: Same as "adb forward _local_ _remote_" but fails if _local_ is already
  forwarded

adb forward --remove _local_
: Remove a specific forward socket connection.

adb forward --remove-all
: Remove all forward socket connections.

adb reverse --list
: List all reverse socket connections from device.

adb reverse _remote_ _local_
: Reverse socket connections.

Reverse specs are one of:

  * tcp:_port_
  * localabstract:_unix domain socket name_
  * localreserved:_unix domain socket name_
  * localfilesystem:_unix domain socket name_

adb reverse --no-rebind _remote_ _local_
: Same as 'adb reverse _remote_ _local_' but fails if _remote_ is already
  reversed.

adb reverse --remove _remote_
: Remove a specific reversed socket connection.

adb reverse --remove-all
: Remove all reversed socket connections from device.

adb jdwp
: List PIDs of processes hosting a JDWP transport.

adb install [-lrtsdg] _file_
: Push this package file to the device and install it.

  * **-l**: Forward lock application.
  * **-r**: Replace existing application.
  * **-t**: Allow test packages.
  * **-s**: Install application on sdcard.
  * **-d**: Allow version code downgrade (debuggable packages only).
  * **-g**: Grant all runtime permissions.

adb install-multiple [-lrtsdpg] _file..._
: Push this package file to the device and install it.

  * **-l**: Forward lock application.
  * **-r**: Replace existing application.
  * **-t**: Allow test packages.
  * **-s**: Install application on sdcard.
  * **-d**: Allow version code downgrade (debuggable packages only).
  * **-p**: Partial application install.
  * **-g**: Grant all runtime permissions.

adb uninstall [-k] _package_
: Remove this app package from the device. **-k** means keep the data and cache
  directories.

adb bugreport [_zipfile_]
: Return all information from the device that should be included in a bug report.

adb backup [-f _file_] [-apk|-noapk] [-obb|-noobb] [-shared|-noshared] [-all] [-system|-nosystem] [_packages..._]
: Write an archive of the device's data to _file_. If no **-f** option is
  supplied then the data is written to **backup.ab** in the current directory.

**-apk** | **-noapk** enable/disable backup of the .apks themselves in the
archive; the default is noapk.

**-obb** | **-noobb** enable/disable backup of any installed apk expansion (aka
.obb) files associated with each application; the default is noobb.

**-shared** | **-noshared** enable/disable backup of the device's shared storage
/ SD card contents; the default is noshared.

**-all** means to back up all installed applications.


**-system** | **-nosystem** toggles whether **-all** automatically includes
system applications; the default is to include system apps.

_packages..._ is the list of applications to be backed up. If the **-all** or
**-shared** flags are passed, then the package list is optional. Applications
explicitly given on the command line will be included even if **-nosystem**
would ordinarily cause them to be omitted.

adb restore _file_
: Restore device contents from the _file_ backup archive.

adb disable-verity
: Disable dm-verity checking on USERDEBUG builds.

adb enable-verity
: Re-enable dm-verity checking on USERDEBUG builds.

adb keygen _file_
: Generate adb public/private key. The private key is stored in _file_, and the
  public key is stored in _file_.pub. Any existing files are overwritten.

adb help
: Show help message.

adb version
: Show version number.

## Scripting

adb wait-for-[-_transport_]-_state_
: Wait for device to be in the given state: **device**, **recovery**,
  **sideload**, or **bootloader**. _transport_ is: **usb**, **local** or **any**
  (default = **any**)

adb start-server
: Ensure that there is a server running.

adb kill-server
: Kill the server if it is running.

adb get-state
: Prints: **offline** | **bootloader** | **device**

adb get-serialno
: Prints: _serial-number_.

adb get-devpath
: Prints: _device-path_.

adb remount
: Remounts the **/system**, **/vendor** (if present) and **/oem** (if present)
  partitions on the device read-write.

adb reboot [bootloader|recovery]
: Reboots the device, optionally into the bootloader or recovery program.

adb reboot sideload
: Reboots the device into the sideload mode in recovery program (adb root
  required).

adb reboot sideload-auto-reboot
: Reboots into the sideload mode, then reboots automatically after the sideload
  regardless of the result.

adb sideload _file_
: Sideloads the given package.

adb root
: Restarts the adbd daemon with root permissions.

adb unroot
: Restarts the adbd daemon without root permissions.

adb usb
: Restarts the adbd daemon listening on USB.

adb tcpip _port_
: Restarts the adbd daemon listening on TCP on the specified port.

## Networking

adb ppp _tty_ [_parameters_]
: Run PPP over USB.

_parameters_: E.g. **defaultroute debug dump local notty usepeerdns**

Note: you should not automatically start a PPP connection. _tty_ refers to the
tty for PPP stream. E.g. **dev:/dev/omap_csmi_tty1**

# Internal Debugging

adb reconnect
: Kick current connection from host side and make it reconnect.

adb reconnect device
: Kick current connection from device side and make it reconnect.

# ENVIRONMENT VARIABLES

ADB_TRACE
: Print debug information. A comma separated list of the following values **1**
  or **all**, **adb**, **sockets**, **packets**, **rwx**, **usb**, **sync**,
  **sysdeps**, **transport**, **jdwp**

ANDROID_SERIAL
: The serial number to connect to. **-s** takes priority over this if given.

ANDROID_LOG_TAGS
: When used with the logcat option, only these debug tags are printed.

# SEE ALSO

https://developer.android.com/tools/help/adb.html
