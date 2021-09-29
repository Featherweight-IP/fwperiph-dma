/****************************************************************************
 * wb_dma_single_xfer_action_test_seq.svh
 ****************************************************************************/

/**
 * Class: wb_dma_single_xfer_action_test_seq
 * 
 * TODO: Add class documentation
 */
class wb_dma_single_xfer_action_test_seq extends wb_dma_transfer_seq;
	`uvm_object_utils(wb_dma_single_xfer_action_test_seq)

	virtual task body();
	
		$display("--> body");
		$display("--> queue");
		`uvmdev_closure_spawn(wb_dma_dev, single_transfer,
			(m_action_mgr, 0, 
				0,
				'h0000_1000,
				1,
				'h0000_2000,
				1,
				'h100));
		$display("<-- queue");
		
		$display("--> wait_threads");
		m_action_mgr.await();
		$display("<-- wait_threads");
		$display("<-- body");
		
	endtask

endclass


