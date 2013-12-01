#MiCore Kernel scripts & tools#

Introduction
-------------------------------------------------------------------------------------
This is a set of scripts & tools to build MiCore kernel for Xiaomi devices<br>
This is a work in progress project, adding new devices on the roll<br>
<br>
This set of scripts & tools are only for <b>aries</b> and includes:
- scripts to set up tools and paths
- scripts & tools to build kernel and boot.img
- initramfs

How to use
-------------------------------------------------------------------------------------
This is an extension of the MiCore Kernel sources.<br>
<b>aries</b> - <a href="https://github.com/Redmaner/MiCore_kernel_aries">Kernel source</a><br>
<br>
Change directory to the root of the kernel source:<br>
<code>cd MiCore_kernel_[device]</code><br>
<br>
Download the MiCore Kernel scripts & tools:<br>
<code>git clone git@github.com:Redmaner/MiCore_kernel_aries.git micore_tools</code><br>
<br>
Set up tools & paths for MiCore build environment:<br>
<code>. micore_scripts/micore_setup.sh</code><br>
<br>
See the specific arguments to build MiCore kernel<br>
<code> ./make_micore.sh --help</code><br>

License
-------------------------------------------------------------------------------------
GNU General Public License version 3<br>
<br>
Copyright (c) 2013 Jake van der Putten<br>
<br>
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.<br>
<br>
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.<br>
<br>
You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
