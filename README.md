# VPP topologies

This repository has the VPP configurations for the following POCs in [VPP](https://github.com/FDio/vpp):
- [draft-ietf-opsawg-ipfix-srv6-srh](https://datatracker.ietf.org/doc/draft-ietf-opsawg-ipfix-srv6-srh/)
- [draft-ietf-opsawg-ipfix-on-path-telemetry](https://datatracker.ietf.org/doc/draft-ietf-opsawg-ipfix-on-path-telemetry/)

## Dependencies
- VPP fork repository: [network-analytics-vpp](https://github.com/network-analytics/vpp)
- Tested in `ubuntu/focal64` using [Vagrantfile](./Vagrantfile)

## Running

### draft-ietf-opsawg-ipfix-srv6-srh

- The POC is implemented in [dev_srh_export](./dev_srh_export)
- VPP source code: branch `feature/srh-ipfix` of [network-analytics-vpp](https://github.com/network-analytics/vpp/tree/feature/srh-ipfix)

### draft-ietf-opsawg-ipfix-on-path-telemetry

- The POC is implemented in [dev_jbayaux_ioam](./dev_jbayaux_ioam)
- VPP source code: branch `feature/ipfix-onpath-telemetry` of [network-analytics-vpp](https://github.com/network-analytics/vpp/tree/feature/ipfix-onpath-telemetry)


## Credits

IOAM patch was implemented by [jbayaux](https://github.com/jbayaux) in [ioam-vpp](https://github.com/Advanced-Observability/ioam-vpp)
