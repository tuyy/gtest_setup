CUR_DIR   = $(shell pwd)
INC_DIR = $(CUR_DIR)/include
INC_DIR_OPTION = $(addprefix -I, $(INC_DIR))
CFLAGS = -std=c++11 -g -Wall -Werror -Wextra $(INC_DIR_OPTION) -isystem $(GTEST_DIR)/include #-pthread
BUILD_DIR = $(abspath $(CUR_DIR)/build)

SRCS := $(sort $(shell find src -name '*.cpp'))
OBJS := $(notdir $(SRCS:%cpp=%o))
TEST_CPP  = $(shell find test -name '*.cpp')
TEST_OBJS = $(notdir $(TEST_CPP:.cpp=.o))

GTEST_DIR = ./externals/gtest
GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
                $(GTEST_DIR)/include/gtest/internal/*.h
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

$(BUILD_DIR)/gtest-all.o : $(GTEST_SRCS_)
	$(shell $(CXX) $(CFLAGS) -I$(GTEST_DIR) -o $@ -c $(GTEST_DIR)/src/gtest-all.cc)

$(BUILD_DIR)/gtest_main.o : $(GTEST_SRCS_)
	$(shell $(CXX) $(CFLAGS) -I$(GTEST_DIR) -o $@ -c $(GTEST_DIR)/src/gtest_main.cc)

$(BUILD_DIR)/gtest.a : $(BUILD_DIR)/gtest-all.o
	$(AR) $(ARFLAGS) $@ $^

$(BUILD_DIR)/gtest_main.a : $(BUILD_DIR)/gtest-all.o $(BUILD_DIR)/gtest_main.o
	$(AR) $(ARFLAGS) $@ $^

all : 

clean :
	$(shell rm -rf *.o $(BUILD_DIR))

mk :
	$(shell mkdir -p $(BUILD_DIR)/include $(BUILD_DIR)/src $(BUILD_DIR)/test)

check : clean mk $(BUILD_DIR)/unittest
	$(BUILD_DIR)/unittest #--gtest_filter=SampleTest.*
	$(shell rm -rf *.o)

$(BUILD_DIR)/unittest : $(OBJS) $(TEST_OBJS) $(BUILD_DIR)/gtest_main.a
	$(CXX) $(CFLAGS) $^ -o $(BUILD_DIR)/unittest

$(OBJS) :
	$(shell $(CXX) $(CFLAGS) -c $(SRCS))

$(TEST_OBJS) :
	$(shell $(CXX) $(CFLAGS) -c $(TEST_CPP))
