# Boxctl
Wrapper for machinectl and systemctl to manage systemd-nspawn OS containers with a
prescriptive way to cutover to new images and fallback to old ones (without depending
on BTRFS or ZFS). OverlayFS is used to maintain control over changes from the original
image. The goal of this wrapper is to remain as light-weight as possible, preferencing
the preservation of the systemd-nspawn-flavored approaches to running containers
over any features added in this wrapper script. This is not intended to replace
machinectl, but to instead to supplement it with a prescriptive workflow for
upgrading to new system containers while providing a valid fallback posture if
needed.

<b><i>Note: this is a work in progress, so it is not stable yet.</i></b>

## Dependencies
This package requires the tar-overlay package to function: https://github.com/wagoodman/tar-overlay

## Example

```
# assume a container filesystem is provided in the given tar file, stage this
# "image" (called 'foo-0.1') for future use.
boxctl stage-image <path-to-'foo-0.1.tar'>

# Create a new container named "system1" that uses the 'foo-0.1' image
boxctl cutover-instance system1 foo-0.1

<by this point the container has been started and is now running>

# Stop the container
boxctl poweroff system1

# Start the container
boxctl start system1

# Stage a new version of the container software
boxctl stage-image <path-to-'foo-0.2.tar'>

# Stop the running system1 container, cutover to the new image, and start the
# container with a new instance of the foo-0.2 image
boxctl cutover-instance system1 foo-0.2

<by this point the container has been started and is now running with the foo-0.2 image>

# Something is wrong and you've determined that you need to fallback to the previous
# version of the container filesystem (foo-0.1), with all changes from before the
# last cutover.
boxctl fallback-instance system1

<by this point the container has been restarted and is now running with the original foo-0.1 image instance>
```

## Motivation
Tools like systemd-nspawn and machinectl are great, as they provide operational
control over your containers without forcing you to use a particular image
management solution. However, it would be nice to "glue" nspawn to such a solution
when necessary, similar to Docker images --tar-overlay was written with this
case in mind. Boxctl is the "glue" to thinly bind the capabilities of nspawn and
friends with the "immutable image" approach of Docker without requiring Docker. In
this way a cutover/fallback approach is prescribed, preserving changes to the
filesystem of a container as if they were physical system or VM. This blends
together the usefulness of nspawn/machinectl to create and manage system containers
while preserving a few aspects gleaned from the application container approach.

## Usage

```
boxctl - wrapper for systemd-nspawn system container management

    boxctl <command> <instance-name> [<image-name>]

Container commands:
    configure <name>   Enter the container without booting it (for making filesystem changes).
    disable <name>     Ensure the system container does *not* start upon reboot of the host.
    enable <name>      Ensure the system container starts upon reboot of the host.
    list <name>        Show all running system containers.
    login <name>       Enter a TTY session to the system container.
    poweroff <name>    Shutdown the system container.
    restart <name>     Power off then power on the system container.
    start <name>       Power on the system container.
    status <name>      Determine the operational condition of the system container.
    terminate <name>   Forcefully kill the system container (not recommended).

Container image/instance commands:
    cutover-instance <name> <image-name>   Actively cutover to a new container instance.
    delete-instance <name> <image-name>    Delete the instance based off of the given image name.
    fallback-instance <name>               Fallback to a previously used instance.
    list-images                     Show avaliable images, current instance, and fallback instance.
    reset <name> <image-name>       Reset the current instance to the originally installed image.
    stage-image <tar-path>          Install a new image from the given tar.gz archive.
```
