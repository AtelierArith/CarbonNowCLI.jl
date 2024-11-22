# Makefile

# Detect operating system
OS_TYPE := $(shell uname -s)

# Set shared library extension based on OS
ifeq ($(OS_TYPE),Linux)
    SHARED_LIB_EXT := .so
else ifeq ($(OS_TYPE),Darwin)
    SHARED_LIB_EXT := .dylib
else
    $(error Unsupported operating system: $(OS_TYPE))
endif


# Variables
JULIA=julia +nightly
JULIA_SCRIPT=juliac.jl
OUTPUT_EXE=carbonjl
CC=gcc
CFLAGS=-L./ -lcalcpi
MAIN_C=main.c

# Default target
all: $(OUTPUT_EXE)

setup:
	juliaup add nightly
	juliaup update nightly
	julia +nightly --version
ifeq ($(wildcard ./juliac.jl),)
	@echo "Downloading juliac.jl..."
	wget https://raw.githubusercontent.com/JuliaLang/julia/refs/heads/master/contrib/juliac.jl
else
	@echo "juliac.jl already exists"
endif

ifeq ($(wildcard ./juliac-buildscript.jl),)
	@echo "Downloading juliac-buildscript.jl..."
	wget https://raw.githubusercontent.com/JuliaLang/julia/refs/heads/master/contrib/juliac-buildscript.jl
else
	@echo "juliac-buildscript.jl already exists"
endif

# Build the shared library
$(OUTPUT_EXE): main.jl setup
	@echo "Building executable..."
	$(JULIA) $(JULIA_SCRIPT) --output-exe $(OUTPUT_EXE) src/CarbonNowCLI.jl
	@echo "Done"

# Run the executable
run: $(OUTPUT_EXE)
	./$(OUTPUT_EXE))

# Clean up generated files
clean:
	$(RM) $(OUTPUT_EXE)

distcleanall: clean
	$(RM) juliac.jl juliac-buildscript.jl
# Phony targets
.PHONY: all run clean setup
