//----------------------------------------------------------------------
//   Copyright 2007-2012 Mentor Graphics Corporation
//   All Rights Reserved Worldwide
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
/****************************************************************************
 * mem_mgr_ev.svh
 * 
 * Copyright 2010 Mentor Graphics Corporation. All Rights Reserved
 * 
 * mem_mgr_ev describes a memory access. The memory manager produces
 * memory events based on DMA master interface activity to memory. The
 * scoreboard uses these events to check correct DMA operation
 ****************************************************************************/
`ifndef INCLUDED_MEM_MGR_EV_SVH
`define INCLUDED_MEM_MGR_EV_SVH

class mem_mgr_ev extends uvm_sequence_item;
	`uvm_object_utils(mem_mgr_ev)
	
	bit [31:0]					addr;
	bit 						we;
	bit [7:0]					data[7:0];
	bit [3:0]					size;
	
endclass

`endif /* INCLUDED_MEM_MGR_EV_SVH */
