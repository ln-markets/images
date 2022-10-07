# LN Markets Images

All the Bitcoin and lightning images used by [LN Markets](https://alpinelinux.org/)

## Introduction

All images built are based on [Alpine Linux](https://alpinelinux.org/)

Every image run the app as a non root user, you can also set the user id and group id who will run the image and map it to your needs.

## Configuration

`PUID` and `PGID` are common to all images

By changing them variables you will also change the owner on the app files

| Name | Description                           |
| ---- | ------------------------------------- |
| PUID | Set the user id running the app       |
| PGID | Set the user group id running the app |

All the images create a user with default user id of _1000_ and default group id of _1000_

All default user home is set to `/home` to ease the use of volumes and mapping
