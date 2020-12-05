# Copyright (C) 2020 Paranoid Android
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

# Android Beam
PRODUCT_COPY_FILES += \
    vendor/kracken/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# ART
# Optimize everything for preopt
PRODUCT_DEX_PREOPT_DEFAULT_COMPILER_FILTER := everything
ifeq ($(TARGET_SUPPORTS_64_BIT_APPS), true)
# Use 64-bit dex2oat for better dexopt time.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat64.enabled=true
endif

# Boot Animation
PRODUCT_COPY_FILES += \
    vendor/kracken/prebuilt/bootanimation/bootanimation.zip:$(TARGET_COPY_OUT_SYSTEM)/media/bootanimation.zip

# DRM
ifeq ($(TARGET_SUPPORTS_64_BIT_APPS), true)
TARGET_ENABLE_MEDIADRM_64 := true
endif

# Filesystem
TARGET_FS_CONFIG_GEN += vendor/kracken/config/config.fs

# GMS
ifneq ($(TARGET_DISABLES_GMS), true)

# Inherit Gapps.
GAPPS_VARIANT := nano
$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)
GAPPS_PRODUCT_PACKAGES += \
		Chrome \
		PrebuiltBugle \
		CalculatorGoogle \
		GoogleContacts \
		LatinImeGoogle \
		PrebuiltDeskClockGoogle \
		WebViewGoogle \
		CalendarGooglePrebuilt \
		GoogleDialer

GAPPS_EXCLUDED_PACKAGES := Velvet
GAPPS_FORCE_PACKAGE_OVERRIDES := true
GAPPS_FORCE_WEBVIEW_OVERRIDES := true
GAPPS_FORCE_MMS_OVERRIDES := true
GAPPS_FORCE_DIALER_OVERRIDES := true
GAPPS_PACKAGE_OVERRIDES := LatinImeGoogle

# Don't preoptimize prebuilts when building GMS.
DONT_DEXPREOPT_PREBUILTS := true

else

# Use default filter for problematic AOSP apps.
PRODUCT_DEXPREOPT_QUICKEN_APPS += \
    Dialer

endif #TARGET_DISABLES_GMS

# Overlays
include vendor/kracken/overlay/overlays.mk

# Packages
include vendor/kracken/config/packages.mk

# Properties
include vendor/kracken/config/properties.mk

# Version
include vendor/kracken/config/version.mk

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    vendor/kracken/config/permissions/privapp-permissions-qti.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-qti.xml \
    vendor/kracken/config/permissions/qti_whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/qti_whitelist.xml

# Include Common Qualcomm Device Tree on Qualcomm Boards
$(call inherit-product-if-exists, device/qcom/common/common.mk)

# Init
PRODUCT_PACKAGES += \
    init.kracken.rc

# SECCOMP Extension
BOARD_SECCOMP_POLICY += vendor/kracken/seccomp

PRODUCT_COPY_FILES += \
    vendor/kracken/seccomp/codec2.software.ext.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/codec2.software.ext.policy \
    vendor/kracken/seccomp/codec2.vendor.ext.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/codec2.vendor.ext.policy \
    vendor/kracken/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    vendor/kracken/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

# Skip boot jars check
SKIP_BOOT_JARS_CHECK := true

# Snapdragon LLVM Compiler
ifneq ($(HOST_OS),linux)
ifneq ($(sdclang_already_warned),true)
$(warning **********************************************)
$(warning * SDCLANG is not supported on non-linux hosts.)
$(warning **********************************************)
sdclang_already_warned := true
endif
else
# include definitions for SDCLANG
include vendor/kracken/sdclang/sdclang.mk
endif

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Treble
# Enable ALLOW_MISSING_DEPENDENCIES on Vendorless Builds
ifeq ($(BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE),)
  ALLOW_MISSING_DEPENDENCIES := true
endif


# Wi-Fi

# Disable EAP Proxy because it depends on proprietary headers
# and breaks WPA Supplicant compilation.
DISABLE_EAP_PROXY := true

# Move Wi-Fi modules to vendor
PRODUCT_VENDOR_MOVE_ENABLED := true
