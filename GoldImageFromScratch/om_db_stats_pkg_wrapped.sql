create or replace package om_db_stats_pkg
is

    /**
     * Locks statistics for a specific order table partition as well as statistics of the corresponding partitions of
     * reference partitioned tables.
     * 
     * @param a_partition_name
     *            The order partition for which statistics should be locked.
     */
    procedure lock_order_ptn_stats(
            a_partition_name in varchar2);
    
    /**
     * Unlocks statistics for a specific order table partition as well as statistics of the corresponding partitions of
     * reference partitioned tables.
     * 
     * @param a_partition_name
     *            The order partition for which statistics should be unlocked.
     */
    procedure unlock_order_ptn_stats(
            a_partition_name in varchar2);
            

    /**
     * Copies statistics for a specific order table partition as well as statistics of the corresponding partitions of
     * reference partitioned tables.
     * 
     * @param a_copied
     *            Whether statistics were copied. 
     * @param a_dst_partition_name
     *            Partition to which to copy statistics. If not specified, defaults to the most recently added partition.
     * @param a_src_partition_name
     *            Partition from which to copy statistics. If not specified, a partition with the most recent valid 
     *            statistics is used.
     */
    procedure copy_order_ptn_stats(
            a_copied out boolean,
            a_dst_partition_name in varchar2 default null,
            a_src_partition_name in varchar2 default null);
            
            
    /**
     * Locks statistics for orders tables with high volatility setting.
     * 
     * Locking volatile order table statistics can be used to avoid gathering statistics on volatile order tables when
     * current order data is not representative of normal - or peak - system utilization. 
     */
    procedure lock_volatile_order_stats;
    
    /**
     * Unlocks statistics for orders tables with high volatility setting.
     */
    procedure unlock_volatile_order_stats;

    
    /**
     * Sets the INCREMENTAL statistics preference for partitioned non-volatile OSM order tables. Incremental statistics should
     * not be enabled on highly volatile tables.     
     * 
     * @param a_incremental
     *            INCREMENTAL statistics preference.
     *            When true, also sets the PUBLISH preference to true as this is required for INCREMENTAL collection.
     *            Also when true, sets the INCREMENTAL_STALENESS preference if supported by the database. Support on 12c and with
     *            patch 13957757 on 11g.
     */
    procedure set_table_prefs_incremental(
            a_incremental in boolean);
			
    /**
     * Locks statistics for orders tables.
	 *
     * @param a_tables_locked
     *            list of order tables which need to be lock.	 
     */
    procedure lock_order_table_stats(a_tables_locked out om_t_om_textvals);
    
    /**
     * Unlocks statistics for orders tables.
	 *
     * @param a_tables_locked
     *            list of tables which need to be unlock. If null, all OSM order tables are unlocked.
     */    
    procedure unlock_table_stats(a_tables_locked in om_t_om_textvals default null);

              
end om_db_stats_pkg;

/
create or replace package body om_db_stats_pkg wrapped 
a000000
b2
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
b
47e5 1195
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

/
