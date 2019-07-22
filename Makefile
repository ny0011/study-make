.PHONY : clean
.SILENT: add.o mul.o sub.o clear lib
.SUFFIXES: .c .o

VPATH   = add mul sub
OBJECT  = $(addsuffix .o, $(VPATH))

TYPE ?= shared
EXE = calculator
STATIC_LIB = lib$(EXE).a
SYMBOLIC_LINK = lib$(EXE).so
SHARED_LIB = $(SYMBOLIC_LINK).1.0.1
INCLUDE_DIR = $(foreach DIR, $(VPATH), -I./$(DIR))

app: lib calculator.o
        gcc calculator.o -L./ -l$(EXE) -o calculator

ifeq ($(TYPE),shared)
CFLAGS = -fPIC -g

calculator.o:
        gcc -DCONFIG_SUB -DCONFIG_MUL=EXT $(INCLUDE_DIR) -c -g -o $@ $*.c -L./ -l$(EXE)

lib : $(OBJECT)
        gcc -shared -Wl,-soname,$(SYMBOLIC_LINK) -o $(SHARED_LIB) $^
        ln -sf $(SHARED_LIB) $(SYMBOLIC_LINK)
else
CFLAGS = -g
calculator.o:
        gcc -DCONFIG_SUB -DCONFIG_MUL -static $(INCLUDE_DIR) -c -g -o  $@ $*.c -L./ -l$(EXE)

lib : $(OBJECT)
        ar rsc $(STATIC_LIB) $^
endif

%.o : %.c %.h

clean:
        rm *.o lib$(EXE)* $(EXE)

