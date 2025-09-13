#!/system/bin/sh
#
# Copyright (C) 2025 Weird Midas
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Runonce after boot, to speed up the transition of power modes in powercfg

apply_once() {
    # this task scheduler setting is good for balancing tasks between 8-core devices
    set_task_scheduler_param "10000000" "1250000" "3000000" "32" "0"
    
    # Let tasks migrate between cores by using the dynamlQ architecture as your main weapon
    set_task_migration_cost "0"
    
    # In a similar vein to setting sysctl_sched_migration_cost to zero, disable CACHE_HOT_BUDDY to better leverage the DynamIQ Shared Unit (DSU). With the DSU, L2$ and L3$ locality isn't lost when a task is migrated to another intra-DSU core
    set_task_scheduler_flags "NO_CACHE_HOT_BUDDY"
    
    # in a similar vein, disabling rq_affinity on all blocks ensures better load balancing due to I/O with better cache locality purposes, due to the dynamlQ architecture having shared cache
    set_rq_affinity "0"
    
    # We should not use the prime core for irq interrupts
    lock_val "3f" /proc/irq/default_smp_affinity
    
    # This core_ctl configuration is as close to ideal as possible for this architecture
    set_corectl_param "enable" "0:1 4:1 6:1"
    set_corectl_param "min_cpus" "0:4 4:2 6:0"
    set_corectl_param "busy_down_thres" "0:20 4:40 6:40"
    set_corectl_param "busy_up_thres" "0:40 4:70 6:70"
    set_corectl_param "offline_delay_ms" "0:100 4:100 6:50"
    set_corectl_param "nr_prev_assist_thresh" "6:1"
    set_corectl_param "task_thres" "4:3"
}

apply_once
