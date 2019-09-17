GEN_DIR := gen
SRC_DIR := src

CC      := gcc
C_FLAGS := -c -O2 -msoft-float 
INCLUDE :=
AR      := ar
OUTPUT  := libsoft-fp.a

FILES     := sfieeelib dfieeelib sfdfcvt
SRC_FILES := $(patsubst %, $(GEN_DIR)/%.c, $(FILES))
OBJ_FILES := $(patsubst %, $(GEN_DIR)/%.o, $(FILES))


.PHONY: default all clean

default: $(OUTPUT)
all: default


$(OUTPUT): $(OBJ_FILES)
	$(AR) -crv $(OUTPUT) $(OBJ_FILES)

%.o : %.c
	$(CC) $(C_FLAGS) $(INCLUDE) $< -o $@

# Compile SFmode routines
$(GEN_DIR)/sfieeelib.c: $(SRC_DIR)/ieeelib.c
	echo '#define COMPUTE_TYPE unsigned long'       >$(GEN_DIR)/sfieeelib.c
	echo '#define COMPUTE_STYPE signed long'        >>$(GEN_DIR)/sfieeelib.c
	echo '#define COMPUTE_TYPE_BITS 32'             >>$(GEN_DIR)/sfieeelib.c
	echo '#define MANTISSA_NWORDS 1'                >>$(GEN_DIR)/sfieeelib.c
	echo '#define MANTISSA_BITS 24'                 >>$(GEN_DIR)/sfieeelib.c
	echo '#define EXP_BITS 8'                       >>$(GEN_DIR)/sfieeelib.c
	echo '#define FLOATING_TYPE float'              >>$(GEN_DIR)/sfieeelib.c
	echo '#define SFmode'                           >>$(GEN_DIR)/sfieeelib.c
	echo '#define MSB_IMPLICIT true'                >>$(GEN_DIR)/sfieeelib.c
	echo '#define FLOAT_WORDS_BIG_ENDIAN'           >>$(GEN_DIR)/sfieeelib.c
	cat $(SRC_DIR)/ieeelib.c                        >>$(GEN_DIR)/sfieeelib.c

# Compile DFmode routines
$(GEN_DIR)/dfieeelib.c: $(SRC_DIR)/ieeelib.c
	echo '#define COMPUTE_TYPE unsigned long'       >$(GEN_DIR)/dfieeelib.c
	echo '#define COMPUTE_STYPE signed long'        >>$(GEN_DIR)/dfieeelib.c
	echo '#define COMPUTE_TYPE_BITS 32'             >>$(GEN_DIR)/dfieeelib.c
	echo '#define MANTISSA_NWORDS 2'                >>$(GEN_DIR)/dfieeelib.c
	echo '#define MANTISSA_BITS 53'                 >>$(GEN_DIR)/dfieeelib.c
	echo '#define EXP_BITS 11'                      >>$(GEN_DIR)/dfieeelib.c
	echo '#define FLOATING_TYPE double'             >>$(GEN_DIR)/dfieeelib.c
	echo '#define DFmode'                           >>$(GEN_DIR)/dfieeelib.c
	echo '#define MSB_IMPLICIT true'                >>$(GEN_DIR)/dfieeelib.c
	echo '#define FLOAT_WORDS_BIG_ENDIAN'           >>$(GEN_DIR)/dfieeelib.c
	cat $(SRC_DIR)/ieeelib.c                        >>$(GEN_DIR)/dfieeelib.c

# Compile conversion routines between DFmode and SFmode
$(GEN_DIR)/sfdfcvt.c: $(SRC_DIR)/ieeecvt.c
	echo '#define S_FLOATING_TYPE float'            >$(GEN_DIR)/sfdfcvt.c
	echo '#define S_MANTISSA_BITS 24'               >>$(GEN_DIR)/sfdfcvt.c
	echo '#define S_EXP_BITS 8'                     >>$(GEN_DIR)/sfdfcvt.c
	echo '#define B_FLOATING_TYPE double'           >>$(GEN_DIR)/sfdfcvt.c
	echo '#define B_MANTISSA_BITS 53'               >>$(GEN_DIR)/sfdfcvt.c
	echo '#define B_EXP_BITS 11'                    >>$(GEN_DIR)/sfdfcvt.c
	echo '#define INTEGER_TYPE unsigned long int'   >>$(GEN_DIR)/sfdfcvt.c
	echo '#define INTEGER_STYPE signed long int'    >>$(GEN_DIR)/sfdfcvt.c
	echo '#define INTEGER_TYPE_BITS 32'             >>$(GEN_DIR)/sfdfcvt.c
	echo '#define S_MANTISSA_NWORDS 1'              >>$(GEN_DIR)/sfdfcvt.c
	echo '#define B_MANTISSA_NWORDS 2'              >>$(GEN_DIR)/sfdfcvt.c
	echo '#define FLOAT_WORDS_BIG_ENDIAN'           >>$(GEN_DIR)/sfdfcvt.c
	echo '#define extend_fname __extendsfdf2'       >>$(GEN_DIR)/sfdfcvt.c
	echo '#define truncate_fname __truncdfsf2'      >>$(GEN_DIR)/sfdfcvt.c
	cat $(SRC_DIR)/ieeecvt.c                        >>$(GEN_DIR)/sfdfcvt.c


clean:
	rm -f $(GEN_DIR)/*.o $(GEN_DIR)/*.c $(OUTPUT) 
