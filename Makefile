SHELL := bash
export PATH := /rsusr/cobol/6.2/bin:/rsusr/pli/bin:$(PATH)

# directory with sources
SRCDIR := .
# directory with generated object files
OBJDIR := obj
# directory with generated executable files
BINDIR := bin

SRC := $(wildcard $(SRCDIR)/hello.*)
OBJ := $(SRC:$(SRCDIR)/hello.%=$(OBJDIR)/hello-%.o)
BIN := $(OBJ:$(OBJDIR)/%.o=$(BINDIR)/%)

########################################################################
# Default target if 'make' is used without args
########################################################################
.PHONY: all clean

all: prepare $(BIN)

########################################################################
# Conditional variables (value depends on the name of the target file)
########################################################################

# Compilation command
COMPILE_CMD =
$(OBJDIR)/%-c.o  : COMPILE_CMD = xlc -c
$(OBJDIR)/%-cbl.o: COMPILE_CMD = STEPLIB=RSRTE.COBOL.V6R2.SIGYCOMP cob2 -c
$(OBJDIR)/%-pli.o: COMPILE_CMD = STEPLIB=RSRTE.PLI.SIBMZCMP pli -qrent -c

# Linker options
LINK_OPT =
$(BINDIR)/%-cbl: LINK_OPT = -e //

########################################################################
# Targets
########################################################################

# Compiling
$(OBJDIR)/hello-%.o: $(SRCDIR)/hello.%
	$(info $< --> $@)
	$(COMPILE_CMD) $<
	@mv -f hello.o $@
	@mv -f hello.lst $(@:.o=.lst) 2>/dev/null; true

# Linking
$(BINDIR)/%: $(OBJDIR)/%.o
	$(info $< --> $@)
	c89 $(LINK_OPT) -o $@ $<

# Prepare work directories
prepare: $(OBJDIR) $(BINDIR)

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(BINDIR):
	mkdir -p $(BINDIR)

# Remove work directories
clean:
	@rm -rf $(OBJDIR) $(BINDIR)
