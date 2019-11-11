Problem:

KGPE-D16 is well aged now, offering only SATA2 interfaces by default. SATA3 interfaces are available with the installation of `PIKE 2008` SAS RAID card (which can be crossflashed into IT mode). However booting from the newer (and faster) SSD drives using NVMe interface via PCIe port is not supported. Not only NVMe is not bootable, but because it is not detected by the BIOS (proprietary or coreboot/libreboot) at all, moving only `boot` parition to a detectable drive (that being SATA2/3 SSD or even USB stick (optionally connected to internal header)) is not sufficient.

Solution: 

- install a small linux instance of choice on a bootable media (SATA2/3 or USB)
- run a script at boot time (eg via `rc.local`), which offers to `kexec` into linux kernel of choice on the NVMe drive

Notes:

Likely the script must be run in virtual terminal, otherwise it will not accept inputs properly, eg:

```
/bin/openvt -s -w /root/launch_main_os.sh
```