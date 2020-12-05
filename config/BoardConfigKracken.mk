# Kernel
include vendor/kracken/config/BoardConfigKernel.mk

# QCOM flags
ifeq ($(call is-vendor-board-platform,QCOM),true)
include vendor/kracken/config/BoardConfigQcom.mk
endif

# SEPolicy
BOARD_PLAT_PRIVATE_SEPOLICY_DIR += \
    vendor/kracken/sepolicy/private

BOARD_PLAT_PUBLIC_SEPOLICY_DIR += \
    vendor/kracken/sepolicy/public

# Soong
include vendor/kracken/config/BoardConfigSoong.mk
