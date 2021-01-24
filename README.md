# fwperiph-dma
Provides a simple peripheral-capable DMA engine. 
This IP is based on the venerable `wb_dma` IP orignally
hosted on opencores.org.

The following changes have been made:
- Removing assignment delays
- Removing timescale

Future work:
- Remove passthrough mode
- Add support for additional bus protocols
- Add support for narrow transfers from peripherals
- Add support for bursting
- Add Zephyr drivers

 