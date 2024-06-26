# Choose the output directory
OUTPUT ?= ./stubs

# Choose the target language.
LANGUAGE ?= cpp

# Choose grpc plugin
GRPCPLUGIN ?= /usr/local/bin/grpc_$(LANGUAGE)_plugin

# Choose the proto include directory.
PROTOINCLUDE ?= ./protos

# Choose protoc binary
PROTOC ?= protoc

# Compile the entire repository
#
# NOTE: if "protoc" command is not in the PATH, you need to modify this file.
#

FLAGS+= --proto_path=/usr/local/include:$(PROTOINCLUDE)
FLAGS+= --$(LANGUAGE)_out=$(OUTPUT) --grpc_out=$(OUTPUT)
FLAGS+= --plugin=protoc-gen-grpc=$(GRPCPLUGIN)

SUFFIX:= pb.cc

DEPS:= $(shell find $(PROTOINCLUDE) -type f -name '*.proto' | sed "s/proto$$/$(SUFFIX)/")

all: $(DEPS)

%.$(SUFFIX):  %.proto
	 mkdir -p $(OUTPUT)
	$(PROTOC) $(FLAGS) $*.proto

clean:
	rm $(patsubst %,$(OUTPUT)/%,$(DEPS)) 2> /dev/null
	rm -rd $(OUTPUT)
