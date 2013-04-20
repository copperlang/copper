Copper
======

  - Version 1.6

Copper is a simple imperative language statically typed with type inference and genericity.

Example Code
------------

A simple function:

``` copper
function full_name (first, last)
    first + last
```

A simple struct:

``` copper
struct Profile
    attr name : Char16
    attr age : Int16

    method initialize (x, y)
        self name = name
        self age = age
        return self
```


Building From Source
--------------------

The makefile requires the GNU make and Microsoft Visual Studio as it uses its linker.
The LLVM version requires the LLVM libraries version 3.2.

To build the COFF version on Windows:

    $ make -f Makefile.windows

To build the LLVM version on Windows:

    $ set LLVMLIB=<path to LLVM libs>
    $ make -f Makefile.windows BACKEND=llvm

To build the ELF version on Linux:

    $ make
    $ make install

To build the LLVM version on Linux:

    $ make BACKEND=llvm
    $ make BACKEND=llvm install

To build the LLVM version on a 64 bit Unix:

    $ make boot64
    $ make BACKEND=llvm install


License
-------

All the source code of the compiler is released in the public domain. Anyone
is free to copy, modify or redistribute it without restrictions.


Contact
-------

Marc Kerbiquet
mkerbiquet@tibleiz.net
