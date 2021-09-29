

/**
 * Class: wb_slave_config
 * Provides configuration information for agent wb_slave
 */
class wb_slave_config `wb_slave_plist extends uvm_object;
	
	typedef wb_slave_config `wb_slave_params this_t;
	`uvm_object_param_utils (this_t)
		
	typedef `wb_slave_vif_t vif_t;
	
	vif_t				vif;
	
	static const string report_id = "wb_slave_config";
	
	// TODO: Add virtual interface handles

	// Specify the config values
	bit					has_monitor		= 1;
	bit					has_driver		= 1;
	bit					has_sequencer	= 1;

	
	/**
	 * Function: get_config
	 * Convenience function that obtains the config object from the
	 * UVM configuration database and reports an error if not present
	 */
	static function wb_slave_config::this_t get_config(
			uvm_component			comp,
			string					cfg_name = "wb_slave_config");
		this_t cfg;
		
		if (!uvm_config_db #(this_t)::get(comp, "", cfg_name, cfg)) begin
			comp.uvm_report_error(report_id,
				$psprintf("%s has no config associated with id %s",
					comp.get_full_name(), cfg_name),, `__FILE__, `__LINE__);
			return null;
		/*
		 */
		end
		
		return cfg;
	endfunction

endclass



