#!/usr/bin/env bash
#
# idrac-power-tuning.sh
#
# Applies the BIOS power/thermal settings used to bring the P570F
# (proxrail001) idle draw from 482W -> 254W:
#   - System Profile:   Performance Per Watt (OS)
#   - Workload Profile: Virtualization Optimized Performance Per Watt
#   - Stages a BIOS config job and forces the reboot needed to apply it
#   - Waits for the job to complete, then verifies the settings stuck
#
# Run this from an SSH session already inside the iDRAC racadm shell
# (i.e. `racadm` is available directly, no -r/-u/-p needed).
#
# NOTE: This forces a power cycle of the host to apply the BIOS
# changes. Don't run this against a host with anything running on it.

set -euo pipefail

echo "== Current System Profile settings =="
racadm get BIOS.SysProfileSettings || true
echo

echo "== Setting System Profile: Performance Per Watt (OS) =="
racadm set BIOS.SysProfileSettings.SysProfile PerfWattOptimizedOs

echo "== Setting Workload Profile: Virtualization Optimized Performance Per Watt =="
racadm set BIOS.SysProfileSettings.WorkloadProfile VtPerWattOptimizedProfile

echo "== (Optional) Disabling Internal SD Card Port (IDSDM) — comment out if not wanted =="
racadm set BIOS.IntegratedDevices.InternalSDCardPort Off

echo "== Staging config job and forcing power cycle to apply =="
racadm jobqueue create BIOS.Setup.1-1 -r pwrcycle

echo
echo "== Watching job queue (Ctrl+C to stop watching; job still applies in background) =="
for i in $(seq 1 30); do
  racadm jobqueue view
  echo "--- (check $i/30, waiting 20s — look for the job above to hit 'Completed') ---"
  sleep 20
done

echo
echo "== Post-apply verification (re-run after the host has rebooted) =="
racadm get BIOS.SysProfileSettings

echo
echo "Done. Confirm no more '(Pending Value=...)' entries above."
echo "Then in the Proxmox host, check idle frequency/power with:"
echo "  watch -n1 \"grep MHz /proc/cpuinfo\""
echo "  turbostat --interval 2   # apt install linux-cpupower"
