# VxRail_Initial_Configuration

## Getting ProxMox up and running

iDrac accepts DHCP by default, access via https://<IP>, root:calvin

Within HTTP iDrac you'll...

1. Create the boot raid volume \n
Storage > Physical Disks > Create Virtual Disk (Select the two BOSS Controller disks) and create a RAID1
These disks reside inside the VxRail, directly attached to the motherboard, meant only for Hypervisor installation
Monitor via Maintenance > Job Queue

2. Create new root password
Open the Virtual Console, login with default root:calvin, change password

3. Install ProxMox
Virtual Console > Virtual Media > Browse to ProxMox ISO and select Boot Once
Install ProxMox as desired, be sure to assign an IP that is outside of your DHCP reservation pool, and not the IP of the iDrac
ProxMox requires a FQDN, either use your domain, or make one up <Host>.<Domain>

4. Create ZFS Pools if desired
The Virtual Console should now plop you into ProxMox
zpool create -o ashift=12 <pool-name> <mirror|raidz2|raidz1>

## Power Reduction

1. HTTP iDrac > Configuration > Power Management > Power Configuration
Redundancy Policy => Not Redundant
Hot Spare => Enabled
One PSU Running at 80% load is more efficient than 2 running at 40%
2. SSH root@<iDrac_IP> Run power_tuning.sh
After rebooting you should see the changes reflected in HTTP iDrac
Or by running racadm get BIOS.SysProfileSettings AND racadm get BIOS.IntegratedDevices
If the changes didn't take, view the Job Queue for related errors

## Disable ProxMox Enterprise License

1. Run disable_proxmox_enterprise.sh
Validate within ProxMox GUI > Node > Repositories
