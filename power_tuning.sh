# Applies the BIOS power/thermal settings used to bring the P570F idle from 482W -> 254W:
#   - System Profile:   Performance Per Watt (OS)
#   - Workload Profile: Virtualization Optimized Performance Per Watt
#   - Stages a BIOS config job and forces the reboot needed to apply it
#   - Waits for the job to complete, then verifies the settings stuck
#
# Run this from an SSH session already inside the iDRAC racadm shell
# Unfortunately must be run manually line by line
#
# NOTE: This forces a power cycle of the host to apply the BIOS
# changes. Don't run this against a host with anything running on it.

### We want to disable one PSU entirely, 80% load on one is better that 40% load on two
### Be sure to remove the unused PSU entirely, or it will alert for missing AC connection
racadm set System.ServerPwr.PSRedPolicy 0
racadm set System.ServerPwr.PSRapidOn 0
racadm set System.ServerPwr.RapidOnPrimaryPSU 1

### Allows OS to control c-state, DAPC cannot engage lowest c-state
### The OS (ProxMox) will have more granular control of CPU frequencies
racadm set BIOS.SysProfileSettings.SysProfile PerfPerWattOptimizedOs

### Disables annoying SD card warnings, we use BOSS
racadm set BIOS.IntegratedDevices.InternalSDCard Off

### Queue the above changes in job queue and reboot VxRail
racadm jobqueue create BIOS.Setup.1-1 -r pwrcycle

### View progress of submitted job
racadm jobqueue view

### Ensure changes took effect
racadm get BIOS.SysProfileSettings
racadm get BIOS.IntegratedDevices

### Ensure lowest c-state of 1200mhz per core
watch -n1 "grep MHz /proc/cpuinfo"
