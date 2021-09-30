#include <zephyr.h>
#include <device.h>
#include <sys/printk.h>
#include <sys/sys_io.h>
#include <stdio.h>

/*
static struct device *devices[] = {
        DEVICE_DT_GET(DT_NODELABEL(pic)),
        DEVICE_DT_GET(DT_NODELABEL(pic2)),
        DEVICE_DT_GET(DT_NODELABEL(pic3))
};
 */

void main(void)
{
	/*
        size_t n_devs;
        const struct device *dev_h;
        struct device *dma1;
        struct device *dma2;
        int i;
	 */

        printk("Hello World! %s\n", CONFIG_BOARD);
        {
        	uint32_t data;
        	sys_write32(0x55aaeeff, 0);
        	data = sys_read32(0);
        	fprintf(stdout, "Data[0]: 0x%08x\n", data);
        	fflush(stdout);

        	sys_write32(0x55aaeeff, 4);
        	data = sys_read32(4);
        	fprintf(stdout, "Data[4]: 0x%08x\n", data);
        	fflush(stdout);

        	sys_write32(0x55aaeeff, 8);
        	data = sys_read32(8);
        	fprintf(stdout, "Data[8]: 0x%08x\n", data);
        	fflush(stdout);
        }

	/*
        n_devs = z_device_get_all_static(&dev_h);
        printk("%d devices\n", n_devs);
        for (i=0; i<n_devs; i++) {
                printk("Name[%d]: %s\n", i, dev_h[i].name);
        }

        for (i=0; i<3; i++) {
                printk("Dev[%d]: %s\n", i, devices[i]->name);
        }

        dma1 = device_get_binding("dma1");
        dma2 = device_get_binding("dma2");
        printk("dma1: %d\n", (int)dma1);
        printk("dma2: %d\n", (int)dma2);
	 */
}

