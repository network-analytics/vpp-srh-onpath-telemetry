# Cheatsheet

```shell
make rebuild
make run
```

## Export confs
```shell
export STARTUP_CONF=/home/taahual9/vpp-srh-onpath-telemetry/dev_srh_export_hackathon/1_vpp.conf
export STARTUP_CONF=/home/taahual9/vpp-srh-onpath-telemetry/dev_srh_export_hackathon/2_vpp.conf
export STARTUP_CONF=/home/taahual9/vpp-srh-onpath-telemetry/dev_srh_export_hackathon/3_vpp.conf
```

```shell
ping -I vpp1host 2001:f4::1
```

```
scp taahual9@10.110.110.236:/home/taahual9/Unyte/lab_srh.pcap /Users/ahuangfeng/Unyte/shared/lab_srh.pcap
```

TODO:
[ ] IEs used are ipv6 src and dst, should we use the created srhSegmentIPv6 and srhActiveSegmentIPv6 ?
[ ] implement sending options template
