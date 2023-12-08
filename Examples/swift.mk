HEAP_SIZE      = 8388208
STACK_SIZE     = 61800

# Locate the Playdate SDK
SDK = ${PLAYDATE_SDK_PATH}
ifeq ($(SDK),)
SDK = $(shell egrep '^\s*SDKRoot' ~/.Playdate/config | head -n 1 | cut -c9-)
endif

ifeq ($(SDK),)
$(error SDK path not found; set ENV value PLAYDATE_SDK_PATH)
endif

include $(SDK)/C_API/buildsupport/common.mk

ifeq ($(TOOLCHAINS),)
$(error Swift nightly toolchain not found; set ENV value TOOLCHAINS)
endif

GCC_INCLUDE_PATHS := $(shell $(CC) -E -Wp,-v -xc /dev/null 2>&1 | egrep '^ ' | xargs echo )
SWIFT_EXEC := $(shell TOOLCHAINS=$(TOOLCHAINS) xcrun -f swiftc)

C_FLAGS := \
	$(addprefix -I ,$(GCC_INCLUDE_PATHS)) \

SWIFT_FLAGS := \
	$(addprefix -Xcc , $(C_FLAGS)) \
	-Osize \
	-wmo -enable-experimental-feature Embedded \
	-Xfrontend -disable-stack-protector \
	-Xfrontend -function-sections \
	-swift-version 6 \
	-Xcc -DTARGET_EXTENSION \
	-module-cache-path build/module-cache \
	-I $(SDK)/C_API \
	-I build/Modules \
	-I $(REPO_ROOT)/Sources/CPlaydate/include \

C_FLAGS_DEVICE := \
	-mthumb \
	-mcpu=cortex-m7 \
	-mfloat-abi=hard \
	-mfpu=fpv5-sp-d16 \
	-D__FPU_USED=1 \
	-falign-functions=16 \
	-fshort-enums \

SWIFT_FLAGS_DEVICE := \
	$(addprefix -Xcc , $(C_FLAGS_DEVICE)) \
	-target armv7em-none-none-eabi \
	-Xfrontend -experimental-platform-c-calling-convention=arm_aapcs_vfp \
	-module-alias Playdate=playdate_device \

C_FLAGS_SIMULATOR := \

SWIFT_FLAGS_SIMULATOR := \
	$(addprefix -Xcc , $(C_FLAGS_SIMULATOR)) \
	-module-alias Playdate=playdate_simulator \

SIMCOMPILER += \
	-nostdlib \
	-dead_strip \
	-Wl,-exported_symbol,_eventHandlerShim \
	-Wl,-exported_symbol,_eventHandler \
