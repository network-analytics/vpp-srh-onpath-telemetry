
```shell
make rebuild
make run
```

## Export confs
```shell
export STARTUP_CONF=/home/vagrant/Unyte/vpp/dev_srh_export/1_vpp.conf
export STARTUP_CONF=/home/vagrant/Unyte/vpp/dev_srh_export/2_vpp.conf
export STARTUP_CONF=/home/vagrant/Unyte/vpp/dev_srh_export/3_vpp.conf
```

```shell
ping -I vpp1host 2001:f4::1
```

TODO:
[ ] length of IPv6 SR is 4 every time? it is wrong right ?
[ ] ipfix template limited to a static 5 segments on the segment list
[ ] IEs used are ipv6 src and dst, should we use the created srhSegmentIPv6 and srhActiveSegmentIPv6 ?
[ ] implement sending options template
