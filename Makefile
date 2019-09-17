GEN_DIR := gen
SRC_DIR := src
BIN_DIR := bin

CC      := gcc
C_FLAGS := -c -O2 -msoft-float 
INCLUDE :=
AR      := ar
OUTPUT  := libsoft-fp.a

FILES     := sfieeelib dfieeelib sfdfcvt
SRC_FILES := $(patsubst %, $(GEN_DIR)/%.c, $(FILES))
OBJ_FILES := $(patsubst %, $(BIN_DIR)/%.o, $(FILES))

# defintions
BIG_ENDIAN    := 0

# Definitions for float types and operations
F_COMPUTE_TYPE      := unsigned long
F_COMPUTE_STYPE     := signed long
F_COMPUTE_TYPE_BITS := 32
F_MANTISSA_WORDS    := 1 

D_COMPUTE_TYPE      := unsigned long
D_COMPUTE_STYPE     := signed long
D_COMPUTE_TYPE_BITS := 32
D_MANTISSA_WORDS    := 2

# Definitions for float conversions
FD_COMPUTE_TYPE     := unsigned long
FD_COMPUTE_STYPE    := signed long
FD_COMPUTE_TYPE_BITS := 32
FD_F_MANTISSA_WORDS := 1
FD_D_MANTISSA_WORDS := 2




.PHONY: default all clean
default: $(OUTPUT)
all: default


$(OUTPUT): $(OBJ_FILES)
	$(AR) -crv $(OUTPUT) $(OBJ_FILES)

$(BIN_DIR)/%.o : $(GEN_DIR)/%.c
	$(CC) $(C_FLAGS) $(INCLUDE) $< -o $@

# Compile SFmode routines
$(GEN_DIR)/sfieeelib.c: $(SRC_DIR)/ieeelib.c
	echo '#define COMPUTE_TYPE $(F_COMPUTE_TYPE)'     >$(GEN_DIR)/sfieeelib.c
	echo '#define COMPUTE_STYPE  $(F_COMPUTE_STYPE)'  >>$(GEN_DIR)/sfieeelib.c
	echo '#define COMPUTE_TYPE_BITS $(F_COMPUTE_TYPE_BITS)'>>$(GEN_DIR)/sfieeelib.c
	echo '#define MANTISSA_NWORDS $(F_MANTISSA_WORDS)'>>$(GEN_DIR)/sfieeelib.c
	echo '#define MANTISSA_BITS 24'                   >>$(GEN_DIR)/sfieeelib.c
	echo '#define EXP_BITS 8'                         >>$(GEN_DIR)/sfieeelib.c
	echo '#define FLOATING_TYPE float'                >>$(GEN_DIR)/sfieeelib.c
	echo '#define SFmode'                             >>$(GEN_DIR)/sfieeelib.c
	echo '#define MSB_IMPLICIT true'                  >>$(GEN_DIR)/sfieeelib.c
ifeq ($(BIG_ENDIAN),1)
	echo '#define FLOAT_WORDS_BIG_ENDIAN'             >>$(GEN_DIR)/sfieeelib.c
endif
	cat $(SRC_DIR)/ieeelib.c                          >>$(GEN_DIR)/sfieeelib.c

# Compile DFmode routines
$(GEN_DIR)/dfieeelib.c: $(SRC_DIR)/ieeelib.c
	echo '#define COMPUTE_TYPE $(D_COMPUTE_TYPE)'     >$(GEN_DIR)/dfieeelib.c
	echo '#define COMPUTE_STYPE $(D_COMPUTE_STYPE)'   >>$(GEN_DIR)/dfieeelib.c
	echo '#define COMPUTE_TYPE_BITS $(D_COMPUTE_TYPE_BITS)'>>$(GEN_DIR)/dfieeelib.c
	echo '#define MANTISSA_NWORDS $(D_MANTISSA_WORDS)'>>$(GEN_DIR)/dfieeelib.c
	echo '#define MANTISSA_BITS 53'                   >>$(GEN_DIR)/dfieeelib.c
	echo '#define EXP_BITS 11'                        >>$(GEN_DIR)/dfieeelib.c
	echo '#define FLOATING_TYPE double'               >>$(GEN_DIR)/dfieeelib.c
	echo '#define DFmode'                             >>$(GEN_DIR)/dfieeelib.c
	echo '#define MSB_IMPLICIT true'                  >>$(GEN_DIR)/dfieeelib.c
ifeq ($(BIG_ENDIAN),1)
	echo '#define FLOAT_WORDS_BIG_ENDIAN'             >>$(GEN_DIR)/sfieeelib.c
endif
	cat $(SRC_DIR)/ieeelib.c                          >>$(GEN_DIR)/dfieeelib.c

# Compile conversion routines between DFmode and SFmode
$(GEN_DIR)/sfdfcvt.c: $(SRC_DIR)/ieeecvt.c
	echo '#define S_FLOATING_TYPE float'            >$(GEN_DIR)/sfdfcvt.c
	echo '#define S_MANTISSA_BITS 24'               >>$(GEN_DIR)/sfdfcvt.c
	echo '#define S_EXP_BITS 8'                     >>$(GEN_DIR)/sfdfcvt.c
	echo '#define B_FLOATING_TYPE double'           >>$(GEN_DIR)/sfdfcvt.c
	echo '#define B_MANTISSA_BITS 53'               >>$(GEN_DIR)/sfdfcvt.c
	echo '#define B_EXP_BITS 11'                    >>$(GEN_DIR)/sfdfcvt.c
	echo '#define INTEGER_TYPE $(FD_COMPUTE_TYPE)'  >>$(GEN_DIR)/sfdfcvt.c
	echo '#define INTEGER_STYPE $(FD_COMPUTE_STYPE)'>>$(GEN_DIR)/sfdfcvt.c
	echo '#define INTEGER_TYPE_BITS $(FD_COMPUTE_TYPE_BITS)'>>$(GEN_DIR)/sfdfcvt.c
	echo '#define S_MANTISSA_NWORDS $(FD_F_MANTISSA_WORDS)' >>$(GEN_DIR)/sfdfcvt.c
	echo '#define B_MANTISSA_NWORDS $(FD_D_MANTISSA_WODRS)' >>$(GEN_DIR)/sfdfcvt.c
ifeq ($(BIG_ENDIAN),1)
	echo '#define FLOAT_WORDS_BIG_ENDIAN'           >>$(GEN_DIR)/sfieeelib.c
endif
	echo '#define extend_fname __extendsfdf2'       >>$(GEN_DIR)/sfdfcvt.c
	echo '#define truncate_fname __truncdfsf2'      >>$(GEN_DIR)/sfdfcvt.c
	cat $(SRC_DIR)/ieeecvt.c                        >>$(GEN_DIR)/sfdfcvt.c


clean:
	rm -f $(BIN_DIR)/*.o $(GEN_DIR)/*.c $(OUTPUT) 
