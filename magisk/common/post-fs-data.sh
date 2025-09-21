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

MODDIR=${0%/*}

if [ -f "$MODDIR/flag/need_recuser" ]; then
    rm -f $MODDIR/flag/need_recuser
    true >$MODDIR/disable
else
    true >$MODDIR/flag/need_recuser
fi

# Vulkan Enabler
if [ -f "/system/vendor/etc/permissions/android.hardware.vulkan.version-1_3.xml" ] && [[ $(getprop ro.build.version.sdk) -ge 33 ]]; then
    resetprop debug.hwui.renderer skiavk
    resetprop debug.renderengine.backend skiavkthreaded
else
    resetprop debug.hwui.renderer skiagl
    resetprop debug.renderengine.backend skiaglthreaded
fi
