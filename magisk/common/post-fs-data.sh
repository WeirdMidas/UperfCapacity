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

# Select the best Render as per device compatibility
if [ -f "/system/vendor/etc/permissions/android.hardware.vulkan.version-1_3.xml" ] && [[ $(getprop ro.build.version.sdk) -ge 33 ]]; then
    resetprop ro.hwui.use_vulkan true
else
    resetprop debug.hwui.renderer skiagl
    resetprop debug.renderengine.backend skiaglthreaded
fi

# We should implement these display settings as per compatibility to reduce jank and annoying slowdowns
if [ $(getprop ro.build.version.release) -ge 13 ]; then
    resetprop debug.sf.auto_latch_unsignaled true
fi

# Use ARM Frame Buffer on Mali GPUs
[ "$(getprop ro.hardware.vulkan)" = "mali" ] && resetprop ro.vendor.ddk.set.afbc 1

# I think this stands for Sunlight Reading Enhancement? Displayfeature constantly polls the light sensor (in fact, too frequently) when this feature is enabled. This is bad for us because citsensorservice calculates compensation for our under-display light sensor that involves HWC and consumes CPU. Frequent nonstop sensor reads caused citsensorservice usage to shoot up to 100% at times:
[ -n "$(getprop ro.vendor.sre.enable)" ] && resetprop --delete ro.vendor.sre.enable

# Use AOSP default Codec2/OMX ranks
[ -n "$(getprop debug.stagefright.omx_default_rank.sw-audio)" ] && resetprop --delete debug.stagefright.omx_default_rank.sw-audio
[ -n "$(getprop debug.stagefright.omx_default_rank)" ] && resetprop --delete debug.stagefright.omx_default_rank
[ -n "$(getprop debug.stagefright.ccodec)" ] && resetprop --delete debug.stagefright.ccodec
