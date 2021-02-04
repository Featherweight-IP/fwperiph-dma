/*
 * fw_periph_dma.h
 *
 *  Created on: Jan 29, 2021
 *      Author: mballance
 */

#ifndef INCLUDED_FW_PERIPH_DMA_H
#define INCLUDED_FW_PERIPH_DMA_H

typedef struct fw_periph_dma_channel_regs_s {
    uint32_t                csr;
    uint32_t                size;
    uint32_t                src;
    uint32_t                src_msk;
    uint32_t                dst;
    uint32_t                dst_msk;
    uint32_t                desc;
    uint32_t                swptr;
} fw_periph_dma_channel_regs_t;

typedef struct fw_periph_dma_regs_s {
    uint32_t                		csr;
    uint32_t                		int_msk_a;
    uint32_t                		int_msk_b;
    uint32_t                		int_src_a;
    uint32_t                		int_src_b;
    uint32_t                		pad[3]; // Channels start at 0x20
    fw_periph_dma_channel_regs_t	channels[8];
} fw_periph_dma_regs_t;

typedef struct fw_periph_dma_ch_s {
	dma_callback_t			callback;
	void					*user_data;
} fw_periph_dma_ch_t;

typedef struct fw_periph_dma_cfg_s {
	fw_periph_dma_regs_t	*regs;
	fw_periph_dma_ch_t		channels[8];
	void                   (*irq_config)();
} fw_periph_dma_cfg_t;




#endif /* INCLUDED_FW_PERIPH_DMA_H */
