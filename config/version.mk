#
# Copyright (C) 2019 Paranoid Android
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

#
# Handle various build version information.
#
# Guarantees that the following are defined:
#     KRACKEN_VERSION_FLAVOR
#     KRACKEN_VERSION_CODE
#     KRACKEN_BUILD_VARIANT
#

ifndef KRACKEN_VERSION_FLAVOR
  # This is the global pa version flavor that determines the focal point
  # behind our releases. This is bundled alongside the $(KRACKEN_VERSION_CODE)
  # and only changes per major Android releases.
  KRACKEN_VERSION_FLAVOR := Ruby
endif

ifndef KRACKEN_VERSION_CODE
  # The version code is the upgradable portion during the cycle of
  # every major Android release. Each version code upgrade indicates
  # our own major release during each lifecycle.
  KRACKEN_VERSION_CODE := 1
endif

# Determines the variant of the build.
# DEV: Unofficial builds given to the general population, created by
# non KRACKEN developers.
# ALPHA: Public/Private builds for testing purposes
# BETA: Public builds for testing purposes
# Public releases will not include a TAG
ifndef KRACKEN_BUILDTYPE
  KRACKEN_BUILD_VARIANT := DEV
else
  ifeq ($(KRACKEN_BUILDTYPE), ALPHA)
    KRACKEN_BUILD_VARIANT := Alpha
  else ifeq ($(KRACKEN_BUILDTYPE), BETA)
    KRACKEN_BUILD_VARIANT := Beta
  else ifeq ($(KRACKEN_BUILDTYPE), RELEASE)
    KRACKEN_BUILD_VARIANT := Release
  endif
endif

# Append date to pa zip name
ifeq ($(KRACKEN_VERSION_APPEND_TIME_OF_DAY),true)
  BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
  BUILD_DATE := $(shell date -u +%Y%m%d)
endif

ifneq ($(filter Release,$(KRACKEN_BUILD_VARIANT)),)
  KRACKEN_VERSION := $(shell echo $(KRACKEN_VERSION_FLAVOR) | tr A-Z a-z)-$(KRACKEN_VERSION_CODE)-$(KRACKEN_BUILD)-$(BUILD_DATE)
else ifneq ($(filter Alpha Beta,$(KRACKEN_BUILD_VARIANT)),)
  KRACKEN_VERSION := $(shell echo $(KRACKEN_VERSION_FLAVOR) | tr A-Z a-z)-$(shell echo $(KRACKEN_BUILD_VARIANT) | tr A-Z a-z)-$(KRACKEN_VERSION_CODE)-$(KRACKEN_BUILD)-$(BUILD_DATE)
else
  KRACKEN_VERSION := $(shell echo $(KRACKEN_VERSION_FLAVOR) | tr A-Z a-z)-$(KRACKEN_VERSION_CODE)-$(KRACKEN_BUILD)-$(BUILD_DATE)-$(shell echo $(KRACKEN_BUILD_VARIANT) | tr A-Z a-z)
endif

# KrackenROM System Version
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.kracken.version=$(KRACKEN_VERSION)

# Paranoid Android Platform Display Version
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.kracken.version.flavor=$(KRACKEN_VERSION_FLAVOR) \
    ro.kracken.version.code=$(KRACKEN_VERSION_CODE) \
    ro.kracken.build.variant=$(KRACKEN_BUILD_VARIANT)
