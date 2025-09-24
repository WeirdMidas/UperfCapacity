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
    set_sched_migrate "80" "60" "90" "75"
    
    # Typically, a migration time of 1ms is sufficient in current environments
    set_task_migration_cost "1000000"
    
    # This is the ideal Corectl configuration based on the architecture and your demand and efficiency needs
    set_corectl_param "enable" "0:1 4:1"
    set_corectl_param "busy_down_thres" "0:20 4:40"
    set_corectl_param "busy_up_thres" "0:40 4:70"
    set_corectl_param "offline_delay_ms" "0:100 4:100"
    set_corectl_param "task_thres" "4:4"
}

apply_once
