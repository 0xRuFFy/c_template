# directories
SRC_DIR = src
OBJ_DIR = build
LIB_DIR = lib
BIN_DIR = bin

# Compiler and flags
CC = clang
CFLAGS = -Wall
CFLAGS += -Wextra
CFLAGS += -Werror
CFLAGS += -pedantic
CFLAGS += -std=c17
CFLAGS += -I./include


# Source files and object files
SRCS = $(shell find $(SRC_DIR) -type f -name '*.c')
OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRCS))
LIBS = $(shell find $(LIB_DIR) -type f -name '*.a')

# Formatter
FORMATTER = clang-format-16
FORMAT_STYLE = {BasedOnStyle: google, IndentWidth: 4, ColumnLimit: 120, InsertNewlineAtEOF: true}
FORMAT_FILES = $(shell find . -iname *.h -o -iname *.c)

# TARGET names
TARGET = run

.PHONY: all exec fmt clean bear

all: fmt $(TARGET)

$(TARGET): $(OBJS)
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) -o $(BIN_DIR)/$(TARGET) $(OBJS) $(LIBS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

exec: $(TARGET)
	./$(BIN_DIR)/$(TARGET)

fmt:
	$(FORMATTER) -style="$(FORMAT_STYLE)" -i $(FORMAT_FILES)

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

clean-files:
	rm -rf $(OBJS) $(BIN_DIR)/$(TARGET)

bear: clean
	bear -- make all