#!/system/bin/sh
#
# Copyright (C) 2021-2022 Matt Yang
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

###############################
# Abbreviations
###############################

SCHED="/proc/sys/kernel"
DEBUG=" /sys/kernel/debug"

###############################
# Powermodes helper functions
###############################

# $1:keyword $2:nr_max_matched
get_package_name_by_keyword() {
    echo "$(pm list package | grep "$1" | head -n "$2" | cut -d: -f2)"
}

# $1:"0:576000 4:710400 7:825600"
set_cpufreq_min() {
    lock_val "$1" /sys/module/msm_performance/parameters/cpu_min_freq
    local key
    local val
    for kv in $1; do
        key=${kv%:*}
        val=${kv#*:}
        lock_val "$val" /sys/devices/system/cpu/cpu$key/cpufreq/scaling_min_freq
    done
}

# $1:"0:576000 4:710400 7:825600"
set_cpufreq_max() {
    lock_val "$1" /sys/module/msm_performance/parameters/cpu_max_freq
    local key
    local val
    for kv in $1; do
        key=${kv%:*}
        val=${kv#*:}
        lock_val "$val" /sys/devices/system/cpu/cpu$key/cpufreq/scaling_max_freq
    done
}

# $1:"schedutil/pl" $2:"0:4 4:3 7:1"
set_governor_param() {
    local key
    local val
    for kv in $2; do
        key=${kv%:*}
        val=${kv#*:}
        lock_val "$val" /sys/devices/system/cpu/cpu$key/cpufreq/$1
    done
}

# $1:"min_cpus" $2:"0:4 4:3 7:1"
set_corectl_param() {
    local key
    local val
    for kv in $2; do
        key=${kv%:*}
        val=${kv#*:}
        lock_val "$val" /sys/devices/system/cpu/cpu$key/core_ctl/$1
    done
}

# $1:upmigrate $2:downmigrate $3:group_upmigrate $4:group_downmigrate
set_sched_migrate() {
    mutate "$2" $SCHED/sched_downmigrate
    mutate "$1" $SCHED/sched_upmigrate
    mutate "$2" $SCHED/sched_downmigrate
    mutate "$4" $SCHED/sched_group_downmigrate
    mutate "$3" $SCHED/sched_group_upmigrate
    mutate "$4" $SCHED/sched_group_downmigrate
}

# $1:latency $2:min_granu $3:wakeup $4:nr_migrate $5:tunable_scaling
set_task_scheduler_param() {
    if [ -f $SCHED/sched_tunable_scaling ]; then
        mutate "$1" $SCHED/sched_latency_ns
        mutate "$2" $SCHED/sched_min_granularity_ns
        mutate "$3" $SCHED/sched_wakeup_granularity_ns
        mutate "$4" $SCHED/sched_nr_migrate
        mutate "$5" $SCHED/sched_tunable_scaling
    else
        mount -t debugfs debugfs /sys/kernel/debug
        mutate "$1" $DEBUG/sched/tunable_scaling
        mutate "$2" $DEBUG/sched/min_granularity_ns
        mutate "$3" $DEBUG/sched/wakeup_granularity_ns
        mutate "$4" $DEBUG/sched/nr_migrate
        mutate "$5" $DEBUG/sched/tunable_scaling
        umount /sys/kernel/debug
    fi
}

# $1:migrate_cost
set_task_migration_cost() {
    if [ -f $SCHED/sched_migration_cost_ns ]; then
        mutate "$1" $SCHED/sched_migration_cost_ns
    else
        mount -t debugfs debugfs /sys/kernel/debug
        mutate "$1" $DEBUG/sched/migration_cost_ns
        umount /sys/kernel/debug
    fi
}

# $1:flag $2: flag
set_task_scheduler_flags() {
    if [ -f $SCHED/sched_tunable_scaling ]; then
        mount -t debugfs debugfs /sys/kernel/debug
        mutate "$1" $DEBUG/sched_features
        mutate "$2" $DEBUG/sched_features
        mutate "$3" $DEBUG/sched_features
        umount /sys/kernel/debug
    else
        mount -t debugfs debugfs /sys/kernel/debug
        mutate "$1" $DEBUG/sched/features
        mutate "$2" $DEBUG/sched/features
        mutate "$3" $DEBUG/sched/features
        umount /sys/kernel/debug
    fi
}

# stop before updating cfg
perfhal_stop() {
    for i in 0 1 2 3 4; do
        for j in 0 1 2 3 4; do
            stop "perf-hal-$i-$j" 2>/dev/null
        done
    done
    usleep 500
}

# start after updating cfg
perfhal_start() {
    for i in 0 1 2 3 4; do
        for j in 0 1 2 3 4; do
            start "perf-hal-$i-$j" 2>/dev/null
        done
    done
}
