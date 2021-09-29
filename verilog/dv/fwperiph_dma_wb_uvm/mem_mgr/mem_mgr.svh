//----------------------------------------------------------------------
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

`undef DEBUG_MEM_MGR
`undef DEBUG_MEM_MGR_VERBOSE
	
`ifdef DEBUG_MEM_MGR
`define mm_info(msg) `uvm_info(get_name(), msg, UVM_LOW)
`else
`define mm_info(msg)
`endif
	
`ifdef DEBUG_MEM_MGR_VERBOSE
`define mm_info_v(msg) `uvm_info(get_name(), msg, UVM_LOW)
`else
`define mm_info_v(msg)
`endif

// class used to manage reserved memory
class mem_mgr_mem_region;
	string					desc;
	bit [31:0]				addr;
	bit [31:0]				size;
//	bit [7:0]				storage[];
	bit						freed;
endclass

class mem_mgr extends uvm_component;
	`uvm_component_utils(mem_mgr)
	
	uvm_analysis_port #(mem_mgr_ev)						mem_ev_ap;

	bit [31:0]											m_mem_base;
	bit [31:0]											m_mem_size;
	bit [7:0]											m_storage[];
	mem_mgr_mem_region									m_map[$];
	mem_mgr_mem_region									m_free_list[$];
	
	// Pool of R/W sequences
	/** TODO:
	wb_simple_rw_seq 									m_req_pool[$];
	 */
	semaphore											m_access_sem;
	mem_mgr_ev											m_mem_ev;
	
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
		
		// TODO: parameterize or enable configuration
		m_mem_base = 'h0000_1000;
		m_mem_size = 'h0020_0000;
		mem_ev_ap = new("mem_ev_ap", this);
		
		m_storage = new[m_mem_size];
		
		m_access_sem = new(1);
		
		m_mem_ev = mem_mgr_ev::type_id::create("ev");
	endfunction

	/*
	function bit is_direct_mapped(bit[31:0] addr);
		region = find_mem_region(addr);
		return 1;
	endfunction
	 *
	 */
	
	/**
	 * Allocate a memory address given the block size (in bytes)
	 * 
	 * align must be power of 2
	 */
	task malloc(
		output bit [31:0]		addr,
		input bit [31:0]		size,
		string					desc,
		bit [31:0]				align=1);
		mem_mgr_mem_region region = new, region_t;
		bit [31:0] align_mask = align-1;
		bit [31:0] align_addr;
		
		m_access_sem.get(1);
		
		`mm_info($psprintf("malloc(%0d) align=%0d align_mask='h%08h %0s", 
			size, align, align_mask, desc));
		
		region.addr    = m_mem_base;
		region.size    = size+4;
		region.desc    = desc;
//		region.storage = new[region.size];
		
		if (m_map.size() == 0) begin
			`mm_info("    first alloc");
			m_map.push_back(region);
		end else begin
			
			for (int i=0; i<m_map.size(); i++) begin
				`mm_info($psprintf("    region 'h%0h .. 'h%0h",
						m_map[i].addr, (m_map[i].addr+m_map[i].size-1)));
				// Align the address as specified
//				if (align > 1) begin
//					`mm_info($psprintf("    pre-align addr='h%08h", region.addr));
//					region.addr = (region.addr + (align - (region.addr & align_mask)));
//					region.size -= (align - (region.addr & align_mask));
//					`mm_info($psprintf("    post-align addr='h%08h", region.addr));
//				end
				
				/**
				 * Check whether the requested block fits ahead of the
				 * current allocated block (we've initialized region to 
				 * the base address
				 */
				if (m_map[i].addr > region.addr &&
						(region.addr + region.size) < m_map[i].addr) begin
					$sformat(region.desc, "%s ('h%08h .. 'h%08h)", desc,
						region.addr, (region.addr+region.size-1)); 
//					region_t = find_mem_region(region.addr);
//					if (region_t != null) begin
//						`uvm_error(get_name(),
//							$psprintf("Allocation fail (1): Address 'h%08h already allocated 'h%08h..'h%08h", 
//								region.addr, region_t.addr, (region_t.addr+region_t.size-1)));
//						foreach (m_map[x]) begin
//							$display("Region %0d: 'h%08h..'h%08h",
//								x, m_map[x].addr, (m_map[x].addr+m_map[x].size-1));
//						end
//					end
					m_map.insert(i, region);
					`mm_info("    insert region here");
					break;
				end else begin
					// Continue searching for an available space 
					region.addr = m_map[i].addr + m_map[i].size;

					if (align > 1) begin
						`mm_info($psprintf("    pre-align addr='h%08h", region.addr));
						region.addr = (region.addr + (align - (region.addr & align_mask)));
						`mm_info($psprintf("    post-align addr='h%08h", region.addr));
					end
					
					if (i+1 >= m_map.size()) begin
						$sformat(region.desc, "%s ('h%08h .. 'h%08h)", desc,
							region.addr, (region.addr+region.size-1)); 
						if (get_region_desc(region.addr, desc)) begin
							uvm_report_error("MEM_MGR", 
								$psprintf("Allocation fail (2): Address 'h%0h already allocated", region.addr));
						end
						m_map.push_back(region);
						`mm_info("    add at end");
						break;
					end
				end  
			end
		end

`ifdef DEBUG_MEM_MGR
		`mm_info($psprintf("malloc returns 'h%0h", region.addr));
		foreach (m_map[x]) begin
			$display("Region %0d: 'h%08h..'h%08h %s",
				x, m_map[x].addr, (m_map[x].addr+m_map[x].size-1), m_map[x].desc);
		end
`endif

		if ((region.addr+region.size) >= (m_mem_base+m_mem_size)) begin
			uvm_report_error("MEM_MGR", $psprintf("Memory allocation of %0d words (%s) failed", 
				size, desc));
			foreach (m_map[x]) begin
				$display("Region %0d: 'h%08h..'h%08h",
					x, m_map[x].addr, (m_map[x].addr+m_map[x].size-1));
			end
		end
				
//		addr = (region.addr + (4-(region.addr%4)));
		addr = region.addr;
		`mm_info($psprintf("malloc: %0d => 'h%08h", size, addr));
		m_access_sem.put(1);
	endtask
	
	/**
	 * Free a memory block given the address
	 */
	task free(bit [31:0] addr);
		bit found = 0;
		mem_mgr_mem_region region = null;
		
		m_access_sem.get(1);
		
		$display("NOTE: free('h%08h)", addr);
		
		for (int i=0; i<m_map.size(); i++) begin
			if (addr >= m_map[i].addr && addr < (m_map[i].addr+m_map[i].size)) begin
				region = m_map[i];
				break;
			end 
		end
		
		if (region != null) begin
			m_free_list.push_back(region);
			region.freed = 1;
		end else begin
			uvm_report_error("MEM_MGR", $psprintf("Failed to locate block for 'h%08h", addr));
			foreach (m_map[x]) begin
				$display("Region %0d: 'h%08h..'h%08h %s",
					x, m_map[x].addr, (m_map[x].addr+m_map[x].size-1), m_map[x].desc);
			end
		end
		
		if (m_free_list.size() >= 4) begin
			region = m_free_list[0];
			m_free_list.delete(0);
			// region = m_free_list.pop_front();
			do_free(region);
		end   
		
		m_access_sem.put(1);
	endtask 
	
	function void do_free(mem_mgr_mem_region region);
		bit found = 0;
		
		for (int i=0; i<m_map.size(); i++) begin
			if (m_map[i].addr == region.addr) begin
				found = 1;
				m_map.delete(i);
				break;
			end 
		end
		if (!found) begin
			uvm_report_error("MEM_MGR", $psprintf("Failed to find region 'h%08h", region.addr));
			foreach (m_map[x]) begin
				$display("Region %0d: 'h%08h..'h%08h",
					x, m_map[x].addr, (m_map[x].addr+m_map[x].size-1));
			end
		end
	endfunction
	
	function mem_mgr_mem_region find_mem_region(bit [31:0] addr);
		// addr = addr[31:2]; // page-align
		
		for (int i=0; i<m_map.size(); i++) begin
			if ((addr >= m_map[i].addr) && 
				(addr < (m_map[i].addr + m_map[i].size))) begin
				return m_map[i];
			end 
		end
		
		return null;
	endfunction 
	
	function bit get_region_desc(bit [31:0] addr, output string desc);
		// addr = addr[31:2]; // page-align
		
		for (int i=0; i<m_map.size(); i++) begin
			if ((addr >= m_map[i].addr) && 
				(addr < (m_map[i].addr + m_map[i].size))) begin
				desc = m_map[i].desc;
				return 1;
			end 
		end
		
		for (int i=0; i<m_free_list.size(); i++) begin
			if ((addr >= m_free_list[i].addr) && 
				(addr < (m_free_list[i].addr + m_free_list[i].size))) begin
				desc = m_free_list[i].desc;
				return 1;
			end 
		end
		
		return 0;
	endfunction 
		 

	/**
	 * This function is called to perform a direct access
	 * to the memory
	 */
	function void direct_access(
		bit [31:0]			addr,
		bit					we,
		inout bit [7:0]		data);
		mem_mgr_mem_region region;

		if (addr < (m_mem_base + m_mem_size)) begin
//			region = find_mem_region(addr);
//			if (region == null) begin
//				uvm_report_error("MEM_MGR", $psprintf(
//					"%0s to 'h%08h is to an unmapped region", 
//					(we)?"Write":"Read", addr));
//			end
			
			if (we) begin
				m_storage[addr-m_mem_base] = data;
			end else begin
				data = m_storage[addr-m_mem_base];
			end
		end else begin
			uvm_report_error("MEM_MGR", 
				$psprintf("Direct access to address 'h%h outside the memory space", addr));
		end

		 `mm_info_v($psprintf("[Direct Access] %0s 'h%08h = 'h%08h", 
				(we)?"Write":"Read", addr, data));
	endfunction
	
	function bit map(
		bit[31:0]			addr,
		bit[31:0]			sz);
		bit ret = 0;
		mem_mgr_mem_region region;
		
		region = find_mem_region(addr);
		
		if (region == null) begin
			region = new;
		
			`mm_info($psprintf("malloc(%0d) align=%0d align_mask='h%08h %0s", 
					size, align, align_mask, desc));
		
			region.addr    = addr;
			region.size    = sz+4;
			region.desc    = "map";
			
			if (m_map.size() == 0) begin
				m_map.push_back(region);
			end else begin
				for (int i=0; i<m_map.size(); i++) begin
					if (m_map[i].addr > region.addr &&
							(region.addr + region.size) < m_map[i].addr) begin
						m_map.insert(i, region);
						break;
					end else if (i+1 >= m_map.size()) begin
						m_map.push_back(region);
						break;
					end
				end
			end
		end else begin
			$display("Note: region 'h%08h already mapped", addr);
		end
		
		return ret;
	endfunction
	
	function bit unmap(bit[31:0] addr);
		bit ret = 1;
		mem_mgr_mem_region region;
		
		region = find_mem_region(addr);
		
		if (region == null) begin
			`uvm_error("MEM_MGR", $sformatf("failed to unmap 'h%08h", addr));
		end else begin
			do_free(region);
		end
		
		return ret;
	endfunction
	
	function void write32(
		bit [31:0]			addr,
		bit [31:0]			data,
		bit 				le=1);
		bit[7:0] b;
		
		for (int i=0; i<4; i++) begin
			if (le) begin
				b = (data >> 8*i);
			end else begin
				b = (data >> 8*(3-i));
			end
			direct_access(addr+i, 1, b);
		end
	endfunction
	
	function void read32(
		input  bit [31:0]		addr,
		output bit [31:0]		data,
		input  bit 				le=1);
		bit[7:0] b;
	
		data = 0;
		for (int i=0; i<4; i++) begin
			direct_access(addr+i, 0, b);
			if (le) begin
				data |= (b << 8*i);
			end else begin
				data |= (b << 8*(3-i));
			end
		end
	endfunction	
	
	
	/**
	 * Perform a memory access. If the address is
	 * mapped to the testbench, then perform the access directly.
	 * If not, then perform the access on interface 'ifc'
	task access(
		input bit [31:0]	addr,
		input bit			we,
		inout bit [31:0]	data,
		input bit			ifc=0);
		wb_simple_rw_seq	req;
		
		if (addr[1:0] != 0) begin
			uvm_report_error("MEM_MGR", 
				$psprintf("Access to 'h%h is not word aligned", addr));
		end 
		
		if ((addr & 'hb000_0000) == 'hb000_0000) begin
			m_access_sem.get(1);
			
			if (m_req_pool.size() == 0) begin
				req = wb_simple_rw_seq::type_id::create("req");
			end else begin
				req = m_req_pool.pop_back();
			end 
			
			req.addr 	= addr;
			req.rnw  	= ~we;
			req.data[0] = data;
			req.n_bytes = 4;
			
			if (ifc == 0) begin
				req.start(m_m0_sequencer);
			end else begin
				req.start(m_m1_sequencer);
			end
			
			if (we == 0)  begin
				data = req.data[0];
			end
			
			m_req_pool.push_back(req);
			
			m_access_sem.put(1);
		end else if (addr < (m_mem_base + m_mem_size)) begin
			direct_access(addr, we, data);
		end else begin
			uvm_report_error("MEM_MGR", 
				$psprintf("Access to address 'h%h outside the memory space", addr));
		end 
	endtask 
	 */
	
	/**
	 * This function is called by the slave sequences
	 * when they detect an access on the slave interfaces 
	function void bus_access(
		bit					ifc,
		bit [31:0]			addr,
		bit					we,
		inout bit [31:0]	data);
		
		if (addr[1:0] != 0) begin
			uvm_report_error("MEM_MGR", 
				$psprintf("Access to 'h%h is not word aligned", addr));
		end 
		m_mem_ev.ifc  = ifc;
		m_mem_ev.addr = addr;
		m_mem_ev.we 	= we;
		m_mem_ev.data = data;
		
		if (addr < (m_mem_base + m_mem_size)) begin
			direct_access(addr, we, data);
		end else begin
			uvm_report_error("MEM_MGR", 
				$psprintf("Bus Access to address 'h%h outside the memory space", addr));
		end

`ifdef DEBUG_MEM_MGR_VERBOSE
		uvm_report_info("MEM_MGR", $psprintf("[Bus Access] %0s 'h%08h = 'h%08h", 
				(we)?"Write":"Read", addr << 2, data));
`endif
		
		mem_ev_ap.write(m_mem_ev);
	endfunction
	 */
	
endclass 

