# Zero-based Kernel

I've always been interested in how things work and, when working as a developer, what is done for me, that "simplifies" my job, by tools and frameworks. Here I'll share findings and tests in the process of understanding the whole kernel (Operating System) business.

## The Story

### 0.0 - Intro

I, mostly, work in very high level language and environemnts. For instance, I, mostly, make a living programming for [.Net](https://www.microsoft.com/net) in [C#](https://docs.microsoft.com/en-us/dotnet/csharp/). But even in *.Net* there are lower levels as I took the time to [find out](http://babil.bigsbyspot.org/). Eventually and inevitably, I would find myself all the way down to kerneling and operating systems. 

First I found [this great tutorial](https://github.com/cfenollosa/os-tutorial); and, in it, the reference to [OSDev.org](https://www.osdev.org/).

Then, I found Eric Steven Raymond's great book, from 2003, [The Art of Unix Programming](http://www.catb.org/esr/writings/taoup/html/index.html) ([epub](https://github.com/bjut-hz/E-Books/blob/master/linux/Eric%20S.%20Raymond-The%20Art%20of%20UNIX%20Programming-Addison-Wesley%20Professional%20%282003%29.epub)).

Then, I wanted to have a look at the [Linux kernel](https://github.com/torvalds/linux) source code and, all of a sudden, things that made sense, didn't make that much sense anymore. It was time to start understanding what is actually going on. Here I go from (almost) nothing...

### 0.1 - The Tools

I work, almost exclusively, on Windows environments, but want to have the lowest, and closes to the original, journey and, for that, I'll be using:

- *Bash* - CLI - (on Windows 10 - [link](https://tutorials.ubuntu.com/tutorial/tutorial-ubuntu-on-windows#0))
- *DHex* - Hexadecimal File Editor - [link](http://www.dettus.net/dhex/)
- *QEMU* - Virtual Machine Emulator - [link](https://www.qemu.org/)
- *GDB* - GNU Debugger - [link](https://www.gnu.org/software/gdb/)
- *Vim* - Code Editor - [link](https://www.vim.org/)
- *GAS* - GNU Assembler - [link](http://tigcc.ticalc.org/doc/gnuasm.html)
- *Nasm* - Assembly Compiler - [link](https://www.nasm.us/)
- *GCC* - GNU Compiler Collection (*C* and *C++* compiler and linker) - [link](https://gcc.gnu.org/)


### 0.2 Computing Basics

#### Base 2

We, intelligent humans, learn from a young age to, do math in base 10, i.e., having 10 distinct digits. The computer is a very basic and limitted machine that "knows" very little. In fact, it only knows two things: 0 (zeros) and 1 (ones), i.e., 2 digits, i.e., it works in base 2.

Every thing that is communicated to a from a computer is nothing more than sequences of *zeros* and *ones*. This means the computer can not count *1, 2, 3, 4, ...*, it has to count *1, 10, 11, 100, ...*., i.e., where the *zeros* and *ones* represent powers of 2, from right to left (but not mandatorily ...). For the binary value:
```
10111
```
the decimal convertion could be, if right to left:
```
    1       1       0       1       1       (binary, base 2)
2^4x1 + 2^3x1 + 2^2x0 + 2^1x1 + 2^0x1
 16x1 +   8x1 +   4x0 +   2x1 +   1x1 = 27  (decinal, base 10)
```
> In many (there I say most) programming languages, *^* symbol mean *powered by*

Playing with different base arithmetics is fun and a great exercise. You''ll find out why programmers mix up Christmas and Halloween. It's because:
```
25 Dec = 31 Oct
```
I.e., 25 in base 10 is equal to 31 in base 8.


#### Physics

The only things in physics relevant to this story are:
- In storage, a *zero* and a *one* are distinguished by, for isntance but depending on the memory type, the existense or electrical current in the place where that position is.
- In communication (e.g., to and from a network device, or to and from CPU), there are 3 voltages corresponding to each of the communicating states: *no data*, *zero* and *one*,

This means that, in terms of (any) memory, there will always be a value of either *zero* or *one*, i.e., there is no *empty* value. In terms of communication, from whatever device (including memory) one needs to be very conscient of how hard it might be to know if all data (the whole sequence of *zero*s and *one*s) has arrived already.

#### Units,Conventions

The unit of computer is the **bit**,  that is either a *zero* or a *one*.

Notation is one of the great struggles of humanity: writing things in a way that is efficient to store and immediate to read. Although storing *zero*s and *one*s is what is physically optimial (not entering the discussion otherwise) reading and writing sequences of *zero*s and *one*s gets very confusing and error prone real fast. After some back and forth, [ISO/IEC 2382-1:1993](https://www.iso.org/obp/ui/#iso:std:iso-iec:2382:-1:ed-3:v1:en) defined 8 bits as the minimal communicable set of data and it's called a **Byte**. I.e.:
```
1 Byte = 8 bit
1B = 1b
```

This means 1 Byte can represent the values from 0 (zero), i.e., all bits as *zero*; all the way to 255, when all bits are *one*:
```
2^0 + 2^1 + 2^2 + 2^3 + 2^4 + 2^5 + 2^6 + 2^7
  1 +   2 +   4 +   8 +  16 +  32 +  64 + 128 = 255
```
I.e., 256 distinct values.

> There are no negative numbers in computer memory or communication.

> There are no fractions or decimal points in computer memory or communication.

Since writing values, for instance, in a memory matrix that can have 1 to 3 digits is not that convinient (back in the day, full memories were dumped to printers understand what was going on, i.e., debug) and not so easy to memorize, hexadecimal, although not at all mandatory, became a standard for representing *Bytes* where 2 hexadecimal digits represent 1 single Byte because:
```
16 * 16 = 256
```

And since our (more common) decimal system only has 10 digits, 6 letters form *A* (or *a*) to *F* (or *f*) are used as the remaining digits. The decimal *27*, from before, would be represented like so:
```
0001 1011
```
the hexadecimal convertion could be, if right to left:
```
(     0       0       0       1 ) x 16 + (     1       0       1       1 )     => binary      =>  base 2
( 2^3x0 + 2^2x0 + 2^1x0 + 2^0x1 ) x 16 + ( 2^3x1 + 2^2x0 + 2^1x1 + 2^0x1 )
                1              ( x 16 )                11                      => decimal,    =>  base 10
                1              ( x 16 )                 B
                                1B                                             => hexadecimal =>  base 16
```

To avoid confusion with other based values (e.g., decimal, binary, etc.), hexadecimal values are, usually, either prefixed with *0x* or sufixed with *h*. The number above would be written either:
```
0x1B
```
or
```
1Bh
```

> *Hexadecimal* notation means nothing to the computer. It's strictly a human readabilty helper notation, thus, the irrelevance of casing.

More units will be used, further on, that the computer is aware of but, since it is only aware of them because we tell it to be aware, we'll address them then.


### 1.0 Before the Light

#### Let there be light

A (normal, everyday) computer is, in essence, a very simple machine that can only be told to do one thing. As such, when a computer starts or is rebooted, it can only go to a pre-defined place that will tell it what to do. This place is called **B**asic **I**nput/**O**utput **S**ystem. The *BIOS* is a software that is installed in the computer's **R**ead **O**nly **M**emory. 

The *BIOS* function, among other things out of the scope of this story (maybe I'll go there, someday), is, after some hardware checks, to: 
- choose from what device the computer should boot from: there can be only one. There might be many bootable devices connected to the computer (e.g., floppy-disk, hard disk, USB stick, etc.) but, by whatever configuration, the *BIOS* can only choose one to boot from. Normally, for a device to be chosen it needs 2 things:
-- To be registered/configured in *BIOS* boot order;
-- To be identifiable as bootable. On x86 architecture, this means the device has the **magic number**, i.e., the Byte in position 510 of it's memory has the value of 0x55 of it's memory and the one in position 511 has the value of 0xAA. Note that indexes (like memory) is zero-based, i.e., the first position is index *0* (zero), the second *1*, and so on.
- after a device is chosen, the boot sector on that device is loaded into the computer's **R**andom **A**ccess **M**emory and then sent for execusion to the computer's **C**entral **P**rocessing **U**nit, from it's first *Byte* onwards.
- from here on, the *BIOS* is the in-between the computer components and the programs (softwares) that run on the computer.

### 1.1 Empty kernel

#### No magic

A boot sector is, then, a device whose 510 and 511 memory indexes return 0x55 and 0xAA. But what happens if no magic number is provided? Let's try it.

1. Create a file, in *Bash*:
   ```bash
   $ touch os1.1nomagic.hex
   ```
2. Fill it up with 512 *zero*s in *DHex*, until position *0x1FF*, running the command in *Bash*:
   ```bash
   $ dhex os1.1nomagic.hex
   ```
   And then in *DHex*:
   ```
[     1E0/     200][os1.1nomagic.hex]
       0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
      20     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
      40     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
      60     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
      80     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
      A0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
      C0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
      E0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
     100     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
     120     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
     140     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
     160     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
     180     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
     1A0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
     1C0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
     1E0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00      ................................
     200
   ```
   
3. Use it in *QEMU*, running the command in *Bash*: 
   ```bash
   $ qemu-system-x86_64 -curses -drive format=raw,file=os1.1nomagic.hex
   ```
   The result, after a bunch of *QEMU* initializations, should be:
   ```
   No bootable device.
   ```

