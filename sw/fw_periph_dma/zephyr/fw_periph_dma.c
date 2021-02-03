/*
 * fw_periph_dma.c
 *
 *  Created on: Jan 29, 2021
 *      Author: mballance
 */

#define DT_DRV_COMPAT fw_periph_dma

#include <kernel.h>
#include <device.h>
#include <init.h>
#include <devicetree.h>
#include <drivers/dma.h>
#include "fw_periph_dma.h"

static void fw_periph_dma_isr(const struct device *dev) {
	const fw_periph_dma_cfg_t *const dma_cfg =
			(const fw_periph_dma_cfg_t const*)dev->config;
	sys_write32(0x00000000, &dma_cfg->regs->int_msk_a);
}

static int fw_periph_dma_init(const struct device *dev) {
	uint32_t i;
	const fw_periph_dma_cfg_t *const dma_cfg =
			(const fw_periph_dma_cfg_t const*)dev->config;
	printk("==> fw_periph_dma_init\n");

	// Configure channel defaults
	for (i=0; i<8; i++) {
		uint32_t sz_v = ((256/4) << 16);
		uint32_t csr = 0; // Cannot guarantee that registers are properly reset

		csr |= (1 << 18); 	// Enable completion interrupt
		csr &= ~(1); 		// Disable the channel
		sys_write32(csr, &dma_cfg->regs->channels[i].csr);
		sys_write32(csr, &dma_cfg->regs->channels[i].size);

		// Configure address mask
		sys_write32(0xFFFFFFFC, &dma_cfg->regs->channels[i].src_msk);
		sys_write32(0xFFFFFFFC, &dma_cfg->regs->channels[i].dst_msk);
	}

	// Route enabled channels to INTA
	sys_write32(0xFFFFFFFF, &dma_cfg->regs->int_msk_a);
	sys_write32(0x0, &dma_cfg->regs->int_msk_b);

	// Configure interrupts for this DMA
	dma_cfg->irq_config();

	printk("<== fw_periph_dma_init\n");
	return 0;
}

static int fw_periph_dma_config(
		const struct device 	*dev,
		uint32_t				channel,
		struct dma_config		*config) {
	uint32_t csr;
	const fw_periph_dma_cfg_t *const dma_cfg =
			(const fw_periph_dma_cfg_t const*)dev->config;
	printk("==> fw_periph_dma_config\n");

	if (channel >= 8) {
		return -1;
	}

	csr = sys_read32(&dma_cfg->regs->channels[channel].csr);
	csr |= (1 << 18); // interrupt on done
	csr |= (1 << 17); // interrupt on error

	// TODO: interfaces

	// TODO: configure direction

	sys_write32(csr, &dma_cfg->regs->channels[channel].csr);
//	csr |= (1 << 0); // Enable channel




	printk("<== fw_periph_dma_config\n");
	return 0;
}

static int fw_periph_dma_reload(
		const struct device 	*dev,
		uint32_t				channel,
		uint32_t				src,
		uint32_t				dst,
		size_t					size) {
	const fw_periph_dma_cfg_t *const dma_cfg =
			(const fw_periph_dma_cfg_t const*)dev->config;
	uint32_t sz;
	// Updates the source/dest/size for a transfer, while leaving
	// the rest of the configuration as-is

	// Configure source and destination
	sys_write32(src, &dma_cfg->regs->channels[channel].src);
	sys_write32(dst, &dma_cfg->regs->channels[channel].dst);
	sz = sys_read32(&dma_cfg->regs->channels[channel].size);
	sz &= ~(0xFFFF);
	sz |= (size & 0xFFFF);
	sys_write32(sz, &dma_cfg->regs->channels[channel].size);

	return 0;
}

static int fw_periph_dma_start(
		const struct device 	*dev,
		uint32_t				channel) {
	const fw_periph_dma_cfg_t *const dma_cfg =
			(const fw_periph_dma_cfg_t const*)dev->config;
	uint32_t csr;

	csr = sys_read32(&dma_cfg->regs->channels[channel].csr);
	csr |= 1;
	sys_write32(csr, &dma_cfg->regs->channels[channel].csr);

	return 0;
}

static int fw_periph_dma_stop(
		const struct device 	*dev,
		uint32_t				channel) {
	const fw_periph_dma_cfg_t *const dma_cfg =
			(const fw_periph_dma_cfg_t const*)dev->config;
	uint32_t csr;

	csr = sys_read32(&dma_cfg->regs->channels[channel].csr);
	csr &= ~(1);
	sys_write32(csr, &dma_cfg->regs->channels[channel].csr);

	return 0;
}

static int fw_periph_dma_get_status(
		const struct device 	*dev,
		uint32_t				channel,
		struct dma_status		*status) {
	const fw_periph_dma_cfg_t *const dma_cfg =
			(const fw_periph_dma_cfg_t const*)dev->config;
	return 0;
}

static const struct dma_driver_api fw_periph_dma_driver_api = {
		.config     = &fw_periph_dma_config,
		.reload     = &fw_periph_dma_reload,
		.start      = &fw_periph_dma_start,
		.stop       = &fw_periph_dma_stop,
		.get_status = &fw_periph_dma_get_status
};

struct fw_dma_dev_data {

};

struct fw_dma_cfg_data {

};

//	DEVICE_DECLARE(fw_periph_dma##inst);

#define FW_PERIPH_DMA_CREATE(inst) \
	\
	static void fw_periph_dma##inst##_irq_config(void); \
	\
	static const fw_periph_dma_cfg_t fw_periph_dma_cfg_##inst = { \
			.regs = (fw_periph_dma_regs_t *)DT_INST_REG_ADDR(inst), \
			.irq_config = fw_periph_dma##inst##_irq_config \
	}; \
	static struct fw_dma_dev_data fw_periph_dma_data_##inst; \
	\
	DEVICE_AND_API_INIT(fw_periph_dma_##inst, DT_INST_LABEL(inst), \
			&fw_periph_dma_init, \
			&fw_periph_dma_data_##inst, \
			&fw_periph_dma_cfg_##inst, \
			POST_KERNEL, \
			CONFIG_KERNEL_INIT_PRIORITY_DEVICE, \
			&fw_periph_dma_driver_api); \
	\
	static void fw_periph_dma##inst##_irq_config(void) { \
		IRQ_CONNECT(DT_INST_IRQN(inst), \
				DT_INST_IRQ(inst, priority), \
				fw_periph_dma_isr, \
				DEVICE_GET(fw_periph_dma_##inst), \
				DT_INST_IRQ(inst, sense)); \
		printk("fw_periph_dma_irq_config %d\n", DT_INST_IRQN(inst)); \
		irq_enable(DT_INST_IRQN(inst)); \
	}


DT_INST_FOREACH_STATUS_OKAY(FW_PERIPH_DMA_CREATE)
