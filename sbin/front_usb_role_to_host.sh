#!/bin/sh
ML7213_PHUB_BASE_ADDR=d0160000
FUNCSEL_REG_OFFSET=508

chmod a+x app-iomem_ctl
insmod /lib/modules/`uname -r`/kernel/drivers/staging/iomem_ctl/iomem_ctl.ko

./app-iomem_ctl ${ML7213_PHUB_BASE_ADDR} ${FUNCSEL_REG_OFFSET} w 1

rmmod iomem_ctl.ko

i2cset -y 1 0x54 0x17 0xbc
sleep 0.5
i2cset -y 1 0x54 0x17 0x92
echo 1 > /sys/bus/usb/devices/usb1/eye_pattern_test
echo "Front USB is Host. eye pattern generate on front USB port"
