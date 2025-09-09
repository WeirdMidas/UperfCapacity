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
    
    # This migration cost fits with our scheduling period idea above
    set_task_migration_cost "1000000"
    
    # To try to mimic the CASS behavior of improving single-core performance by avoiding CPU throttling (in which case, we will provide cache locality to prevent the core from throttling)
    set_task_scheduler_flags "NEXT_BUDDY"
    
    # We can use rq_affinity to TRY to mimic the aspect of determining the best CPU to activate a task among CPUs that have the same relative utilization, but in a generic way where we will only determine the best CPU for tasks related to general interrupts, favoring single-core performance
    set_rq_affinity "1"
    
    # This core_ctl configuration is as close to ideal as possible for this architecture
    set_corectl_param "enable" "0:1 4:1"
    set_corectl_param "min_cpus" "0:4 4:2"
    set_corectl_param "busy_down_thres" "0:20 4:40"
    set_corectl_param "busy_up_thres" "0:40 4:70"
    set_corectl_param "offline_delay_ms" "0:100 4:50"
    set_corectl_param "task_thres" "4:4"
}

apply_once
