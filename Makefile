TARGET_EXEC ?= main
CC = g++
BUILD_DIR ?= bin
SRC_DIRS ?= src

SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.s)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
# DEPS := $(OBJS:.o=.d)

INC_DIRS := include
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

LIBRARIES	:= -lSDL2 -lGLEW -lGL

CPPFLAGS ?= $(INC_FLAGS) -MMD -MP -fPIC -Llib


SOFOLDER := solib
SOLIB := hazel.so

$(SOFOLDER)/$(SOLIB): $(OBJS)
	$(MKDIR_P) $(dir $@)
	$(CC) -shared $(OBJS) -o $@

$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS) $(LIBRARIES)

# assembly
$(BUILD_DIR)/%.s.o: %.s
	$(MKDIR_P) $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

# c source
$(BUILD_DIR)/%.c.o: %.c
	$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


.PHONY: clean
.PHONY: all

clean:
	$(RM) -r $(BUILD_DIR)

all: $(BUILD_DIR)/$(TARGET_EXEC)

sharedlib: clean all
	clear
	$(SOFOLDER)/$(SOLIB)


# -include $(DEPS)

run: clean all
	clear
	./$(BUILD_DIR)/$(TARGET_EXEC)

MKDIR_P ?= mkdir -p
