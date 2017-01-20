GIT_VERSION := " $(shell git rev-parse --short HEAD)"
LOCAL_PATH := $(call my-dir)
DEBUG = 0
FRONTEND_SUPPORTS_RGB565 = 1
FAST = 1
HAVE_VULKAN=1

include $(CLEAR_VARS)

ifeq ($(TARGET_ARCH),arm)
ANDROID_FLAGS := -DANDROID_ARM
LOCAL_ARM_MODE := arm
endif

ifeq ($(TARGET_ARCH),x86)
ANDROID_FLAGS := -DANDROID_X86
IS_X86 = 1
endif

ifeq ($(TARGET_ARCH),mips)
ANDROID_FLAGS := -DANDROID_MIPS -D__mips__ -D__MIPSEL__
endif

LOCAL_CXXFLAGS += $(ANDROID_FLAGS)
LOCAL_CFLAGS   += $(ANDROID_FLAGS)

CORE_DIR        := ../..
LOCAL_MODULE    := libretro

PTHREAD_FLAGS = -pthread
NEED_CD = 1
NEED_BPP = 32
WANT_NEW_API = 1
NEED_DEINTERLACER = 1
NEED_THREADING = 1
NEED_TREMOR = 1
CORE_DEFINE := -DWANT_PSX_EMU

TARGET_NAME := mednafen_psx_hw_libretro

include $(CORE_DIR)/Makefile.common

LOCAL_SRC_FILES += $(SOURCES_CXX) $(SOURCES_C)
EXTRA_GCC_FLAGS := -funroll-loops

ifeq ($(DEBUG),0)
   FLAGS += -O3 $(EXTRA_GCC_FLAGS)
else
   FLAGS += -O0 -g
endif

LDFLAGS += $(fpic) $(SHARED)
FLAGS += $(fpic) $(NEW_GCC_FLAGS) $(INCFLAGS)

FLAGS += $(ENDIANNESS_DEFINES) -DSIZEOF_DOUBLE=8 $(WARNINGS) -DMEDNAFEN_VERSION=\"0.9.26\" -DPACKAGE=\"mednafen\" -DMEDNAFEN_VERSION_NUMERIC=926 -DPSS_STYLE=1 -DMPC_FIXED_POINT $(CORE_DEFINE) -DSTDC_HEADERS -D__STDC_LIMIT_MACROS -D__LIBRETRO__ -DNDEBUG -D_LOW_ACCURACY_ $(SOUND_DEFINE) -D__STDC_CONSTANT_MACROS -DGIT_VERSION=\"$(GIT_VERSION)\" $(INCFLAGS)
FLAGS += -DHAVE_VULKAN -DHAVE_HW

LOCAL_C_INCLUDES = $(CORE_DIR)/parallel-psx $(CORE_DIR)/parallel-psx/atlas $(CORE_DIR)/parallel-psx/vulkan $(CORE_DIR)/parallel-psx/renderer $(CORE_DIR)/parallel-psx/khronos/include $(CORE_DIR)/parallel-psx/glsl/prebuilt $(CORE_DIR)/parallel-psx/vulkan/SPIRV-Cross $(CORE_DIR)/parallel-psx/vulkan/SPIRV-Cross/include

LOCAL_CFLAGS =  $(FLAGS) 
LOCAL_CXXFLAGS = $(FLAGS) -fexceptions -std=c++11
LOCAL_LDLIBS += -lz

include $(BUILD_SHARED_LIBRARY)
