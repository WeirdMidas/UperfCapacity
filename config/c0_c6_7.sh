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
    # It's easier to respect the limits of LITTLE cores for task migration LITTLE cores can typically handle up to 80% of tasks placed on them Big cores can handle up to 2.4x more tasks than little cores, showing that the difference between the two is almost drastic
    set_sched_migrate "80 80" "60 60" "90" "75"
    
    # Set the migration costs to 0 instead of its per default value for overall improved leverage on intra DSU-supported cores
    set_task_migration_cost "0"
    
    # Disable the CACHE_HOT_BUDDY task scheduling flag for overall improved leverage on intra DSU-supportive cores
    set_task_scheduler_flags "NO_CACHE_HOT_BUDDY"
    
    # This is the ideal Corectl configuration based on the architecture and your demand and efficiency needs
    set_corectl_param "enable" "0:1 6:1 7:1"
    set_corectl_param "busy_down_thres" "0:20 6:40 7:40"
    set_corectl_param "busy_up_thres" "0:40 6:60 7:60"
    set_corectl_param "offline_delay_ms" "0:50 6:100 7:50"
    set_corectl_param "nr_prev_assist_thresh" "7:1"
    set_corectl_param "task_thres" "0:4 6:3"
}

apply_once
