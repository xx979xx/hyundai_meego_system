#!/bin/sh
ML7213_PHUB_BASE_ADDR=d0160000
FUNCSEL_REG_OFFSET=508

chmod a+x app-iomem_ctl
insmod /lib/modules/`uname -r`/kernel/drivers/staging/iomem_ctl/iomem_ctl.ko

./app-iomem_ctl ${ML7213_PHUB_BASE_ADDR} ${FUNCSEL_REG_OFFSET} w 0

rmmod iomem_ctl.ko

echo 'T' > /dev/mfd-iap2

i2cset -y 1 0x54 0x17 0xbc
sleep 0.5
i2cset -y 1 0x54 0x17 0x98

echo "Front USB is device."
