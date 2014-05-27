LOCAL_PATH:= $(call my-dir)

# hardcode autotools crap
MY_AUTOMAKE_CFLAGS = -DPACKAGE_STRING="\"protobuf-c 1.2.1\"" \
	-DHAVE_PROTOBUF_C_MESSAGE_CHECK

include $(CLEAR_VARS)

LOCAL_MODULE := libprotobuf-c
LOCAL_MODULE_TAGS := optional
#LOCAL_PRELINK_MODULE := false
LOCAL_MODULE_CLASS := STATIC_LIBRARIES

#LOCAL_STATIC_LIBRARIES := libc

LOCAL_SRC_FILES := $(call all-c-files-under,protobuf-c)

LOCAL_C_INCLUDES += $(LOCAL_PATH)/protobuf-c

LOCAL_CFLAGS := -std=c99 -pedantic -Wall
LOCAL_CFLAGS += $(MY_AUTOMAKE_CFLAGS)

# Use this variable when building with NDK out of tree
#LOCAL_EXPORT_C_INCLUDES += $(LOCAL_PATH)
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)
LOCAL_COPY_HEADERS_TO := google/protobuf-c
LOCAL_COPY_HEADERS := protobuf-c/protobuf-c.h

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE := libprotobuf-c-host
LOCAL_MODULE_TAGS := optional
#LOCAL_PRELINK_MODULE := false
#LOCAL_MODULE_CLASS := STATIC_LIBRARIES

#LOCAL_STATIC_LIBRARIES := libc

LOCAL_SRC_FILES := $(call all-c-files-under,protobuf-c)

LOCAL_C_INCLUDES += $(LOCAL_PATH)/protobuf-c

LOCAL_CFLAGS := -std=c99 -pedantic -Wall
LOCAL_CFLAGS += $(MY_AUTOMAKE_CFLAGS)

# Use this variable when building with NDK out of tree
#LOCAL_EXPORT_C_INCLUDES += $(LOCAL_PATH)
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)
LOCAL_COPY_HEADERS_TO := google/protobuf-c
LOCAL_COPY_HEADERS := protobuf-c/protobuf-c.h

include $(BUILD_HOST_STATIC_LIBRARY)


include $(CLEAR_VARS)

LOCAL_MODULE := aprotoc-c
LOCAL_MODULE_TAGS := optional
#LOCAL_PRELINK_MODULE := false
LOCAL_MODULE_CLASS := EXECUTABLES

LOCAL_CXX_STL := libstdc++

LOCAL_CPP_EXTENSION := .cc
LOCAL_SRC_FILES := $(call find-subdir-subdir-files, "protoc-c", "*.cc")

LOCAL_C_INCLUDES += $(LOCAL_PATH)
LOCAL_C_INCLUDES += $(LOCAL_PATH)/protobuf-c
LOCAL_C_INCLUDES += external/protobuf/src

LOCAL_CFLAGS += $(MY_AUTOMAKE_CFLAGS) -Wno-sign-compare
LOCAL_STATIC_LIBRARIES := libprotobuf-cpp-2.3.0-compiler-host

#LOCAL_FORCE_STATIC_EXECUTABLE := true
#LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
#LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)

# From external/protobuf/Android.mk (Google protobuf in build system)
#LOCAL_STATIC_LIBRARIES += libz
LOCAL_LDLIBS := -lpthread

include $(BUILD_HOST_EXECUTABLE)

