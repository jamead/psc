# Power Supply Controller

This is a custom designed hardware platform for the next gen power supply controller.

Uses the DESY FWK FPGA Firmware Framework https://fpgafw.pages.desy.de/docs-pub/fwk/index.html

## Requires

* Xilinx 2022.2
* git
* python3

## Building

```sh
. /path/to/Vitis/2022.2/settings64.sh

git clone --recurse-submodules https://github.com/jamead/psc
make env

make cfg=hw project
make cfg=hw build

make cfg=sw project
make cfg=sw build

```
