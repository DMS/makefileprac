CXX = g++

SRC_PATH = src
BUILD_PATH = build
INCLUDE_PATH = include
BIN_PATH = $(BUILD_PATH)/bin

BIN_NAME = app

SRC_EXT = cpp

SOURCES = $(shell find $(SRC_PATH) -name '*.$(SRC_EXT)' | sort -k 1nr | cut -f2-)

OBJECTS = $(SOURCES:$(SRC_PATH)/%.$(SRC_EXT)=$(BUILD_PATH)/%.o)

DEPS = $(OBJECTS:.o=.d)

COMPILE_FLAGS = -std=c++11 -Wall -Wextra -g

INCLUDES = -I include/ -I /usr/local/include

LIBS = 

.PHONY: default_target
default_target: release

.PHONY: release
release: export CXXFLAGS := $(CXXFLAGS) $(COMPILE_FLAGS)

release: dirs
	@$(MAKE) all

.PHONY: dirs
dirs: 
	@echo "Creating Dirs"
	@mkdir -p $(dir $(OBJECTS))
	@mkdir -p $(BIN_PATH)

.PHONY: clean
clean: 
	@echo "DELETE $(BIN_NAME) symlink"
	@$(RM) $(BIN_NAME)
	@echo "Deleting directories"
	@$(RM) -r $(BUILD_PATH)
	@$(RM) -r $(BIN_PATH)

.PHONY: all
all: $(BIN_PATH)/$(BIN_NAME)
	@echo "Making symlink $(BIN_NAME) -> $<"
	@$(RM) $(BIN_NAME)
	@ln -s $(BIN_PATH)/$(BIN_NAME) $(BIN_NAME)

$(BIN_PATH)/$(BIN_NAME): $(OBJECTS)
	@echo "Linking : $@"
	$(CXX) $(OBJECTS) -o $@

-include $(DEPS)

$(BUILD_PATH)/%.o: $(SRC_PATH)/%.$(SRC_EXT)
	@echo "Compiling: $< -> $@"
	$(CXX) $(CXXFLAGS) $(INCLUDES) -MP -MMD -c $< -o $@