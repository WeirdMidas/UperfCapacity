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
    set_corectl_param "enable" "0:1 4:1"
    set_corectl_param "min_cpus" "0:4 4:2"
    set_corectl_param "busy_down_thres" "0:20 4:40"
    set_corectl_param "busy_up_thres" "0:40 4:70"
    set_corectl_param "offline_delay_ms" "0:100 4:100"
    set_corectl_param "task_thres" "4:4"
}

apply_once
