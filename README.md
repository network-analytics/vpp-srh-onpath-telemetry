# VPP topologies

This repository have the vpp configurations for the following POCs in VPP:
- [draft-tgraf-opsawg-ipfix-srv6-srh](https://datatracker.ietf.org/doc/html/draft-tgraf-opsawg-ipfix-srv6-srh-05)
- [draft-tgraf-opsawg-ipfix-on-path-telemetry](https://datatracker.ietf.org/doc/html/draft-tgraf-opsawg-ipfix-on-path-telemetry-00)

## Dependencies
- VPP fork repository: [INSA-unyte-vpp](https://github.com/insa-unyte/vpp)
- Tested in `ubuntu/focal64` using [Vagrantfile](./Vagrantfile)

## Running

### draft-tgraf-opsawg-ipfix-srv6-srh

- The POC is implemented in [dev_srh_export](./dev_srh_export)
- VPP source code: branch `feature/srh-ipfix` of [INSA-unyte-vpp](https://github.com/insa-unyte/vpp)

### draft-tgraf-opsawg-ipfix-on-path-telemetry

- The POC is implemented in [dev_jbayaux_ioam](./dev_jbayaux_ioam)
- VPP source code: branch `feature/ipfix-onpath-telemetry` of [INSA-unyte-vpp](https://github.com/insa-unyte/vpp)


## Credits

IOAM patch was implemented by [jbayaux](https://github.com/jbayaux) in [vpp](https://github.com/jbayaux/vpp)
