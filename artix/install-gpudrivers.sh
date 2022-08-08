#!/bin/sh

# Replace the drivers with your gpu drivers
paru --noremovemake --skipreview --noupgrademenu --needed -S mesa mesa-utils lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon libva-mesa-driver mesa-vdpau 
