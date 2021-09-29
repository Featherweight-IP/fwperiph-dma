
typedef class wb_master_driver;
class wb_master_api_impl `wb_master_plist extends wb_master_api;
	
	wb_master_driver `wb_master_params m_drv;
	
	task reset();
		$display("reset: m_reset=%0d", m_drv.m_reset);
		m_drv.m_reset = 1;
		m_drv.m_reset_sem.put(1);
	endtask
		
	task response(bit ERR);
		if (m_drv.m_wait_resp) begin
			m_drv.m_resp_err = ERR;
			m_drv.m_resp_sem.put(1);
		end else begin
			$display("Warning: gratuitous response received");
		end
	endtask
endclass

class wb_master_driver `wb_master_plist extends uvm_driver #(wb_master_seq_item);
	
	typedef wb_master_driver `wb_master_params this_t;
	typedef wb_master_config `wb_master_params cfg_t;
	typedef wb_master_api_impl `wb_master_params api_t;
	
	`uvm_component_param_utils (this_t);

	const string report_id = "wb_master_driver";
	
	uvm_analysis_port #(wb_master_seq_item)		ap;
	
	cfg_t													m_cfg;
	semaphore												m_sem = new(1);
	semaphore												m_reset_sem = new(0);
	bit														m_reset = 0;
	semaphore												m_resp_sem = new(0);
	bit														m_wait_resp;
	bit														m_resp_err;
	bit														m_big_endian = 1;
	
	function new(string name, uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		api_t api;
		super.build_phase(phase);
		
		ap = new("ap", this);
		
		api = new();
		api.m_drv = this;
		
		m_cfg = cfg_t::get_config(this);
		m_cfg.vif.m_api = api;
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction
	
	/**
	 * Task: read32
	 *
	 * Override from class 
	 */
	virtual task read32(input bit[31:0] addr, output bit[31:0] data);
		cfg_t::vif_t vif = m_cfg.vif;
		m_sem.get(1);
		if (!m_reset) begin
			m_reset_sem.get(1);
		end
		m_wait_resp = 1;
		vif.wb_master_bfm_request(addr, 1, 1, 'hf, 0);
		m_resp_sem.get(1);
		m_wait_resp = 0;
		vif.wb_master_bfm_get_data(0, data);
		m_sem.put(1);
	endtask

	/**
	 * Task: read8
	 *
	 * Override from class 
	 */
	virtual task read8(input bit[31:0] addr, output bit[7:0] data);
		// TODO: deal with select
		// TODO: deal with data swizzling
		cfg_t::vif_t vif = m_cfg.vif;
		bit[3:0] mask;
		bit[31:0] data_tmp;
		
		if (m_big_endian) begin
			mask = (1 << (3-(addr & 3)));
		end else begin
			mask = (1 << (addr & 3));
		end
		
//		$display("read8: addr='h%08h mask='h%08h", addr, mask);
		m_sem.get(1);
		
		if (!m_reset) begin
			m_reset_sem.get(1);
		end
		
		m_wait_resp = 1;
		vif.wb_master_bfm_request(addr, 1, 1, mask, 0);
		m_resp_sem.get(1);
		m_wait_resp = 0;
		vif.wb_master_bfm_get_data(0, data_tmp);
//		$display("read8:   raw data='h%08h", data_tmp);
		if (m_big_endian) begin
			data_tmp >>= 8*(3-(addr & 3));
		end else begin
			data_tmp >>= 8*(addr & 3);
		end
//		$display("read8:   real data='h%08h", data_tmp);
		data = data_tmp;
		m_sem.put(1);
	endtask

	/**
	 * Task: read16
	 *
	 * Override from class 
	 */
	virtual task read16(input bit[31:0] addr, output bit[15:0] data);
		// TODO: deal with select
		// TODO: deal with data swizzling
		cfg_t::vif_t vif = m_cfg.vif;
		bit[3:0] mask;
		bit[31:0] data_tmp;
		
		if (m_big_endian) begin
			mask = (3 << (2-(addr & 2)));
		end else begin
			mask = (3 << (addr & 2));
		end
		
		$display("read16: addr='h%08h mask='h%08h", addr, mask);
		m_sem.get(1);
		
		if (!m_reset) begin
			m_reset_sem.get(1);
		end
		
		m_wait_resp = 1;
		vif.wb_master_bfm_request(addr, 1, 1, mask, 0);
		m_resp_sem.get(1);
		m_wait_resp = 0;
		vif.wb_master_bfm_get_data(0, data_tmp);
		$display("read16:   raw data='h%08h", data_tmp);
		if (m_big_endian) begin
			data_tmp >>= 8*(2-(addr & 2));
		end else begin
			data_tmp >>= 8*(addr & 2);
		end
		$display("read16:   real data='h%08h", data_tmp);
		data = data_tmp;
		m_sem.put(1);
	endtask
	
	/**
	 * Task: write32
	 *
	 * Override from class 
	 */
	virtual task write32(input bit[31:0] addr, input bit[31:0] data);
		cfg_t::vif_t vif = m_cfg.vif;
		m_sem.get(1);
		if (!m_reset) begin
			m_reset_sem.get(1);
		end
		
		m_wait_resp = 1;
		vif.wb_master_bfm_set_data(0, data);
		vif.wb_master_bfm_request(addr, 1, 1, 'hf, 1);
		m_resp_sem.get(1);
		m_wait_resp = 0;
		m_sem.put(1);
	endtask

	/**
	 * Task: write8
	 *
	 * Override from class 
	 */
	virtual task write8(input bit[31:0] addr, input bit[7:0] data);
		cfg_t::vif_t vif = m_cfg.vif;
		bit[3:0] mask;
		bit[31:0] data_tmp;
		
		data_tmp = data;
		if (m_big_endian) begin
			mask = (1 << (3-(addr & 3)));
			data_tmp <<= 8*(3-(addr & 3));
		end else begin
			mask = (1 << (addr & 3));
			data_tmp <<= 8*(addr & 3);
		end
		
//		$display("write8: addr='h%08h data='h%08h data_tmp='h%08h mask=%08h",
//				addr, data, data_tmp, mask);

		m_sem.get(1);
		
		if (!m_reset) begin
			m_reset_sem.get(1);
		end
		m_wait_resp = 1;
		vif.wb_master_bfm_set_data(0, data_tmp);
		vif.wb_master_bfm_request(addr, 1, 1, mask, 1);
		m_resp_sem.get(1);
		m_wait_resp = 0;
		m_sem.put(1);
	endtask

	/**
	 * Task: write16
	 *
	 * Override from class 
	 */
	virtual task write16(input bit[31:0] addr, input bit[15:0] data);
		cfg_t::vif_t vif = m_cfg.vif;
		bit[3:0] mask;
		bit[31:0] data_tmp;
		
		data_tmp = data;
		if (m_big_endian) begin
			mask = ('h3 << (2-(addr & 2)));
			data_tmp <<= 8*(2-(addr & 2));
		end else begin
			mask = ('h3 << (addr & 2));
			data_tmp <<= 8*(addr & 2);
		end
		
		$display("write16: addr='h%08h data='h%08h data_tmp='h%08h mask=%08h",
						addr, data, data_tmp, mask);

		m_sem.get(1);
		if (!m_reset) begin
			m_reset_sem.get(1);
		end
		m_wait_resp = 1;
		vif.wb_master_bfm_set_data(0, data_tmp);
		vif.wb_master_bfm_request(addr, 1, 1, mask, 1);
		m_resp_sem.get(1);
		m_wait_resp = 0;
		m_sem.put(1);
	endtask
	
	task run_phase(uvm_phase phase);
		wb_master_seq_item		item;
		bit[3:0] mask;
		bit[31:0] data_tmp;
		bit[31:0] addr;
		
		$display("--> run_phase: wait for reset");
		if (!m_reset) begin
			m_reset_sem.get(1);
		end
		$display("<-- run_phase: wait for reset");
		
		forever begin
			cfg_t::vif_t vif = m_cfg.vif;
			
			seq_item_port.get_next_item(item);
//			item.print();
		
			data_tmp = item.data;
			addr = item.addr;
			m_sem.get(1);
		
			case (item.size)
				1: begin
					if (m_big_endian) begin
						mask = (1 << (3-(addr & 3)));
						data_tmp <<= 8*(3-(addr & 3));
					end else begin
						mask = (1 << (addr & 3));
						data_tmp <<= 8*(addr & 3);
					end					
				end
				
				2: begin
					// TODO:
				end
				
				4: begin
					mask = 'hf;
				end
			endcase

			m_wait_resp = 1;
			vif.wb_master_bfm_set_data(0, data_tmp);
			vif.wb_master_bfm_request(addr, 1, 1, mask, 
					item.is_write);
			m_resp_sem.get(1);
			m_wait_resp = 0;
	
			if (!item.is_write) begin
				vif.wb_master_bfm_get_data(0, data_tmp);
			
				case (item.size) 
					1: begin
						if (m_big_endian) begin
							data_tmp >>= 8*(3-(addr & 3));
						end else begin
							data_tmp >>= 8*(addr & 3);
						end					
					end
				
					2: begin
						// TODO:
					end
				endcase
			
				item.data = data_tmp;
			end
			
			m_sem.put(1);
			
			// Send the item to the analysis port
			ap.write(item);
			
			seq_item_port.item_done();
		end
	endtask
endclass



