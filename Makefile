# GNU Makefile to build copper
#
# Usage:
#	make	-- Build the ELF version
#	make BACKEND=coff	-- Build the COFF version
#	make BACKEND=llvm	-- Build the LLVM version
#
# Required Variables
#	LLVMLIB	-- the path to the LLVM lib files
#
# OPTIONS
# Debug:
#	DEBUG=1
#
# Building with a specified ELF compiler:
#	COPPER=<path to copper-elf>
#
# Building with a specified LLVM compiler:
#	COPPERLLVM=<path to copper-llvm>

srcdir = .
prefix = /usr/local
exec_prefix = ${prefix}
bindir = ${exec_prefix}/bin

OUTDIR=.
COPPER=boot/copper-elf
CFLAGS=
CC=gcc
LFLAGS=
OS=unix
BACKEND=elf
INSTALL=install

ifndef TARGET
	ifeq ($(shell uname -m), x86_64)
		TARGET=64
	else
		TARGET=32
	endif
endif


ifdef DEBUG
  CFLAGS += -debug
  LFLAGS += /debug
endif

.SILENT:
.PHONY: init

all: $(OUTDIR)/copper-$(BACKEND)

boot64: $(OUTDIR)/io.o
	@echo Compiling obj...
	llc -filetype=obj boot/copper-llvm-unix-64.bc -o $(OUTDIR)/copper-llvm.o
	@echo Linking...
	g++ $(LFLAGS) $(OUTDIR)/copper-llvm.o $(OUTDIR)/io.o -lLLVMBitWriter -lLLVMCore -lLLVMSupport -lpthread -ldl -lm -o $(OUTDIR)/copper-llvm
	
$(OUTDIR)/copper-coff: $(OUTDIR)/copper-coff.o $(OUTDIR)/io.o
	@echo Linking...
	$(CC) $(LFLAGS) $^ -o $@

$(OUTDIR)/copper-elf: $(OUTDIR)/copper-elf.o $(OUTDIR)/io.o
	@echo Linking...
	$(CC) $(LFLAGS) $^ -o $@

$(OUTDIR)/copper-llvm: $(OUTDIR)/copper-llvm.o $(OUTDIR)/io.o
	@echo Linking...
	g++ $(LFLAGS) $^ -lLLVMBitWriter -lLLVMCore -lLLVMSupport -lpthread -ldl -lm -o $@

$(OUTDIR)/copper-$(BACKEND).o: init \
	src/elf/elf.co \
	src/builder.co \
	src/generator-llvm.co \
	src/generator-coff.co \
	src/generator-elf.co \
	src/generator-x86.co \
	src/object-file-coff.co \
	src/object-file-elf.co \
	src/commons.co \
	src/core.co \
	src/file.co \
	src/file-windows.co \
	src/lexer.co \
	src/parser.co \
	src/p-code-builder.co \
	src/p-code.co \
	src/syntax-tree.co \
	src/x86.co \
	src/target-32.co \
	src/target-64.co \
	src/main.co
ifdef COPPERLLVM
	@echo Compiling bc...
	$(COPPERLLVM) -I src -D backend=$(BACKEND) -D os=$(OS) -D target=$(TARGET) $(CFLAGS) -o $(OUTDIR)/copper-$(BACKEND).bc src/main.co
	@echo Compiling obj...
	llc -filetype=obj $(OUTDIR)/copper-$(BACKEND).bc -o $@
else
	@echo Compiling...
	$(COPPER) -I src -D backend=$(BACKEND) -D os=$(OS) -D target=$(TARGET) $(CFLAGS) -o $@ src/main.co
endif

$(OUTDIR)/io.o: src/os/io.c
	@echo io.c
	$(CC) $(CFLAGS) -c -o $@ $?

init:
	chmod +x boot/copper-elf
	
install:
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(INSTALL) -s $(OUTDIR)/copper-$(BACKEND) $(DESTDIR)$(bindir)

clean: 
	rm -f $(OUTDIR)/*.o $(OUTDIR)/*.bc $(OUTDIR)/copper-coff $(OUTDIR)/copper-elf $(OUTDIR)/copper-llvm

