# VxRail_Initial_Configuration

iDrac accepts DHCP by default, access via https://<iDrac_IP>, root:calvin
When first logging in you'll need to create a unique password to replace calvin

## Power Reduction

SSH iDrac >> Run lines one by one within power_tuning.sh  
After rebooting you should see the changes reflected in HTTP iDrac or via racadm get  
If the changes didn't take, view the Job Queue for related errors  

## Getting ProxMox up and running

1. Create the boot raid volume  
Storage > Physical Disks > Create Virtual Disk (Select the two BOSS Controller disks) and create a RAID1  
These disks reside inside the VxRail, directly attached to the motherboard, meant only for Hypervisor installation  
Monitor via HTTP iDrac > Maintenance > Job Queue  

2. Install ProxMox  
HTTP iDrac > Virtual Console > Virtual Media > Browse to ProxMox ISO and select Boot Once  
Be sure to assign an IP that is outside of your network's DHCP reservation pool  
ProxMox requires a FQDN, either use your domain, or make one up <Host>.<Domain>  

3. Create ZFS Pools if desired  
The HTTP iDrac Virtual Console should now plop you into ProxMox  
zpool create -o ashift=12 <pool_name> <mirror|raidz2|raidz1>  

## Disable ProxMox Enterprise License

1. SSH root@</ProxMox_IP> >> Run disable_proxmox_enterprise.sh  
Validate within ProxMox GUI > Node > Repositories  

## Networking

1. You'll want to align on VLAN assigment
2. You'll want to put all management IP onto a single VLAN
3. Configure ProxMox mgmt through iDrac, then use HHTP GUI
