# ieeelib
Torbjorn Granlund's soft floating-point emulation library, which was posted on the [GCC mailing list in 1999](https://gcc.gnu.org/ml/gcc/1999-07n/msg00553.html) and donated to the GNU project. This repo is mainly a copy of the code with some help to build it.

When compiling x86 sources on GCC with `-msoft-float` (i.e. not using SSE or the X87 FPU), one must make arrangements to provide a soft-float library ([see gcc doc](https://gcc.gnu.org/onlinedocs/gcc/x86-Options.html) at `-msoft-float`). This library must provide [these soft-float routes](https://gcc.gnu.org/onlinedocs/gcc-4.0.4/gccint/Soft-float-library-routines.html).

GCC sort of provides it's own soft-float library, presumabley to support embedded systems without FPU (e.g. ARM), but it's not provided under x86. It's sort of possible to compile the GCC float library (see [this Stackoverflow response](https://stackoverflow.com/questions/1018638/using-software-floating-point-on-x86-linux/8227605#8227605), but there will be errors, and it won't result in a complete set of the required functions.

The ieeelib by Torbjorn provides a simple, self-contained, portable way to provide the required functions. Calling `make` should set up the library for 32-bit targets, and then it can be included for example in compilation of x86 programs with `gcc -msoft-float -mno-fp-ret-in-387 -L<directory of libsoft-fp.a> <other-params> -lsoft-fp` (Note the static ieee library has to be provided last).

(Rounding modes or exception bits appear to be missing according to [this discussion](http://gcc.1065356.n8.nabble.com/Torbjorn-s-ieeelib-c-td667693.html))

# License

The License is GPL v2 or later, with a special clause saying that linking with other executables is allowed without causing the resulting executable to be covered under GPL (This is similar to LGPL, which did not exist back in 1999).
