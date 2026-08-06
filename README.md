# VxRail_Initial_Configuration

## Power Reduction

1. HTTP iDrac > Configuration > Power Management > Power Configuration  
Redundancy Policy => Not Redundant  
Hot Spare => Enabled  
One PSU Running at 80% load is more efficient than 2 running at 40%  
2. SSH root@<iDrac_IP> >> Run lines one by one within power_tuning.sh  
After rebooting you should see the changes reflected in HTTP iDrac or via racadm get  
If the changes didn't take, view the Job Queue for related errors  

## Getting ProxMox up and running

iDrac accepts DHCP by default, access via https://<iDrac_IP>, root:calvin

Within HTTP iDrac you'll...

1. Create the boot raid volume  
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
zpool create -o ashift=12 <pool_name> <mirror|raidz2|raidz1>  

## Disable ProxMox Enterprise License

1. SSH root@</ProxMox_IP> >> Run disable_proxmox_enterprise.sh  
Validate within ProxMox GUI > Node > Repositories  
