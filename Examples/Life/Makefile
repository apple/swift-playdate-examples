REPO_ROOT := $(shell git rev-parse --show-toplevel)
PRODUCT := Life.pdx
include $(REPO_ROOT)/Examples/swift.mk

# MARK: - Build Game Swift Object
build/device_lib.o: Sources/*.swift
	$(SWIFT_EXEC) $(SWIFT_FLAGS) $(SWIFT_FLAGS_DEVICE) -c $^ -o $@
$(OBJDIR)/pdex.elf: build/device_lib.o
OBJS += build/device_lib.o

build/simulator_lib.o: Sources/*.swift
	$(SWIFT_EXEC) $(SWIFT_FLAGS) $(SWIFT_FLAGS_SIMULATOR) -c $^ -o $@
$(OBJDIR)/pdex.${DYLIB_EXT}: build/simulator_lib.o
SIMCOMPILER += build/simulator_lib.o
