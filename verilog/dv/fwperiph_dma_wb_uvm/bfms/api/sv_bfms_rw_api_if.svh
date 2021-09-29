/****************************************************************************
 * sv_bfms_rw_api_if.svh
 ****************************************************************************/

/**
 * Class: sv_bfms_rw_api_if
 * 
 * TODO: Add class documentation
 */
/*interface*/ class sv_bfms_rw_api_if;
	
	virtual task write8(
			bit[31:0]			addr,
			bit[7:0]			data);
		$display("Error: unimplemented write8 task");
	endtask
	
	virtual task read8(
			bit[31:0]			addr,
			output bit[7:0]		data);
		$display("Error: unimplemented read8 task");
	endtask

	virtual task write16(
			bit[31:0]			addr,
			bit[15:0]			data);
		$display("Error: unimplemented write8 task");
	endtask
	
	virtual task read16(
			bit[31:0]			addr,
			output bit[15:0]	data);
		$display("Error: unimplemented read8 task");
	endtask
	
	virtual task write32(
			bit[31:0]			addr,
			bit[31:0]			data);
		$display("Error: unimplemented write32 function");
	endtask
	
	virtual task read32(
			bit[31:0]			addr,
			output bit[31:0]	data);
		$display("Error: unimplemented read32 function");
	endtask


endclass


