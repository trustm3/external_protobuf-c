# from build/core/config.mk:
PROTOC_C := $(HOST_OUT_EXECUTABLES)/aprotoc-c$(HOST_EXECUTABLE_SUFFIX)

# from build/core/definitions.mk:
#########################################################################
## Commands for running protoc to compile .proto into .pb-c.c and .pb-c.h
#########################################################################
define transform-proto-to-c
@mkdir -p $(dir $@)
@echo "Protoc-c: $@ <= $<"
$(hide) $(PROTOC_C) \
	$(addprefix --proto_path=, $(PRIVATE_PROTO_INCLUDES)) \
	$(PRIVATE_PROTOC_FLAGS) \
	--c_out=$(PRIVATE_PROTO_C_OUTPUT_DIR) $<
endef

# prematurely get intermediates path
intermediates := $(call local-intermediates-dir)

# from build/core/binary.mk:
###########################################################
## Compile the .proto files to .c and then to .o
###########################################################
proto_sources := $(filter %.proto,$(LOCAL_SRC_FILES))
LOCAL_SRC_FILES := $(filter-out %.proto,$(LOCAL_SRC_FILES))
proto_generated_objects :=
proto_generated_headers :=
ifneq ($(proto_sources),)
proto_sources_fullpath := $(addprefix $(LOCAL_PATH)/, $(proto_sources))
proto_generated_c_sources_dir := $(intermediates)/proto
proto_generated_c_sources := $(addprefix $(proto_generated_c_sources_dir)/, \
    $(patsubst %.proto,%.pb-c.c,$(proto_sources_fullpath)))
proto_generated_objects := $(patsubst %.c,%.o, $(proto_generated_c_sources))

$(proto_generated_c_sources): PRIVATE_PROTO_INCLUDES := $(TOP) $(LOCAL_PATH)
$(proto_generated_c_sources): PRIVATE_PROTO_C_OUTPUT_DIR := $(proto_generated_c_sources_dir)
$(proto_generated_c_sources): PRIVATE_PROTOC_FLAGS := $(LOCAL_PROTOC_FLAGS)
$(proto_generated_c_sources): $(proto_generated_c_sources_dir)/%.pb-c.c: %.proto $(PROTOC_C)
	$(transform-proto-to-c)

proto_generated_headers := $(patsubst %.pb-c.c,%.pb-c.h, $(proto_generated_c_sources))
$(proto_generated_headers): $(proto_generated_c_sources_dir)/%.pb-c.h: $(proto_generated_c_sources_dir)/%.pb-c.c

$(proto_generated_objects): PRIVATE_ARM_MODE := $(normal_objects_mode)
$(proto_generated_objects): PRIVATE_ARM_CFLAGS := $(normal_objects_cflags)
$(proto_generated_objects): $(proto_generated_c_sources_dir)/%.o: $(proto_generated_c_sources_dir)/%.c $(proto_generated_headers)
	$(transform-$(PRIVATE_HOST)c-to-o)
-include $(proto_generated_objects:%.o=%.P)

LOCAL_GENERATED_SOURCES += $(proto_generated_objects)
LOCAL_ADDITIONAL_DEPENDENCIES += $(proto_generated_headers)
#LOCAL_C_INCLUDES += external/protobuf/src
LOCAL_C_INCLUDES += $(proto_generated_c_sources_dir)
#LOCAL_CFLAGS += -DGOOGLE_PROTOBUF_NO_RTTI
ifdef LOCAL_IS_HOST_MODULE
LOCAL_STATIC_LIBRARIES += libprotobuf-c-host
else
LOCAL_STATIC_LIBRARIES += libprotobuf-c
endif
endif

