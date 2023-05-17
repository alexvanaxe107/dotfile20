#!/usr/bin/env bash

setcap 'CAP_SYS_NICE=eip' /usr/bin/gamescope

#echo 0 > /proc/sys/vm/compaction_proactiveness
#echo 1048576 > /proc/sys/vm/min_free_kbytes
#echo 10 > /proc/sys/vm/swappiness
#echo 5 > /sys/kernel/mm/lru_gen/enabled
#echo 0 > /proc/sys/vm/zone_reclaim_mode
#echo 1 > /proc/sys/vm/page_lock_unfairness

# *** Note that if your game uses TCMalloc (e.g., Dota 2 and CS:GO) then it is not recommended to disable THP
#echo never > /sys/kernel/mm/transparent_hugepage/enabled
#echo never > /sys/kernel/mm/transparent_hugepage/shmem_enabled
#echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
# *** Comment until here

# *** You may want to comment the bellow session as well
#echo 0 > /proc/sys/kernel/sched_child_runs_first
#echo 1 > /proc/sys/kernel/sched_autogroup_enabled
#echo 500 > /proc/sys/kernel/sched_cfs_bandwidth_slice_us
#echo 1000000 > /sys/kernel/debug/sched/latency_ns
#echo 500000 > /sys/kernel/debug/sched/migration_cost_ns
#echo 500000 > /sys/kernel/debug/sched/min_granularity_ns
#echo 0 > /sys/kernel/debug/sched/wakeup_granularity_ns
#echo 8 > /sys/kernel/debug/sched/nr_migrate
# *** Comment until here
