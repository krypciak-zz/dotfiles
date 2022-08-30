#!/bin/sh

# Replace the drivers with your gpu drivers
paru $PARU_ARGUMENTS $PACMAN_ARGUMENTS -S mesa mesa-utils lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon libva-mesa-driver mesa-vdpau 
