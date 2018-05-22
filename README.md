# Zero-based Kernel

I've always been interested in how things work and, when working as a developer, what is done for me, that "simplify" my job, by the tools and frameworks. Here I'll share what I found out, tried and tested in understanding the whole kernel (Operating System) business.

## The Story

### 0.0 - Intro

I, mostly, work in very high level language and environemnts. For instance, I, mostly, make a living programming for [.Net](https://www.microsoft.com/net) in [C#](https://docs.microsoft.com/en-us/dotnet/csharp/). But even in *.Net* thare lower levels as I took the time to [find out](http://babil.bigsbyspot.org/). Eventually and inevitably, I would find myself all the way down to kerneling and Operating Systems. 

First I found [this great tutorial](https://github.com/cfenollosa/os-tutorial);

Then, I found Eric Steven Raymond's great book, from 2003, [The Art of Unix Programming](http://www.catb.org/esr/writings/taoup/html/index.html) ([epub](https://github.com/bjut-hz/E-Books/blob/master/linux/Eric%20S.%20Raymond-The%20Art%20of%20UNIX%20Programming-Addison-Wesley%20Professional%20(2003).epub)).

Then, I wanted to have a look at the [Linux kernel code](https://github.com/torvalds/linux) and, all of a sudden so things that make sense, didn't make that much sense anymore. I was time to start understanding what is actually going on. Here I go.

### 0.1 - The Tools

I work, almost exclusively, on Windows environments, but want to have the lowest and closes to the metal journey and, for that, I'll be using:

- *Bash* - The CLI - (on Windows 10 - [link](https://tutorials.ubuntu.com/tutorial/tutorial-ubuntu-on-windows#0))
- *DHex* - The Hexadecimal file editor - [link](http://www.dettus.net/dhex/)
- *QEMU* - Virtual Machine Emulator - [link](https://www.qemu.org/)
- *GDB* - GNU Debugger - [link](https://www.gnu.org/software/gdb/)
- *Vim* - Code Editor - [link](https://www.vim.org/)
- *GAS* - GNU Assembler - [link](http://tigcc.ticalc.org/doc/gnuasm.html)
- *Nasm* - Assembly Compiler - [link](https://www.nasm.us/)
- *GCC* - GNU Compiler Collection (*C* and *C++* compiler and linker) - [link](https://gcc.gnu.org/)
- *Visual Studio Code* - The IDE - [link](https://code.visualstudio.com/)
- *VirtualBox* - The Graphical Virtual Machine Host - [link](https://www.virtualbox.org/)

### 0.2 Computing Basics

#### Base 2

We intelligent humans, learn from a young age to, do math in base 10, i.e., having 10 diffent digits. The computer is a very basic and limitted machine with that "knows" very little. In fact, it only knows two things: 0 (zeros) and 1 (ones), i.e., 2 digits, i.e., it works in base 2.

Every thing that is communicated to a from a computer is nothing more than sequences of *zeros* and *ones*. This means the computer does not count *1, 2, 3, 4, ...*, it counts *1, 10, 11, 100, ...*., i.e., where the *zeros* and *ones* represent powers of 2, from right to left. For the binary value:
```
10111
```
the decimal convertion would be:

```
    1       0       1       1       1       (binary, base 2)
2^4x1 + 2^3x0 + 2^2x1 + 2^1x1 + 2^0x1
 16x1 +   8x0 +   4x1 +   2x1 +   1x1 = 23  (decinal, base 10)

```

Playing with different base arithmetics is fun and a great exercise. You''ll find out why programmer mix up Christmas and Halloween. It's because:
```
25 Dec = 31 Oct
```
I.e., 25 is base 10 is equal to 31 in base 8.


#### Physics

The only things in physics relevant for this story are:
- In storage, a *zero* and a *one* are distinguished by, for isntance but depending on the memory type, the existense or electrical current in the place where that position is.
- In communication (e.g., from a network device to and from CPU, there are 3 voltages corresponding to each of the comnicating states: *no data*, *zero* and *one*,

This means that, in terms of (any) memory, there will always be a value of either *zero* or *one*. In terms of communication, one needs to be very conscient of how hard it might be to know if all data (the whole sequence of *zero*s and *one*s has arrived already.

#### Units,Conventions

The unit of computer is the **bit**,  that is either a *zero* or a *one*.

Notation is one of the great struggles of humanity. Writing things in a way that is efficient to store and immediate to read. Although storing *zero*s and *one*s is what is physically optimial (not entering the discussion otherwise) reading and writing sequences of *zero*s and *one*s gets very hard real fast. After some back and forth, [ISO/IEC 2382-1:1993(https://www.iso.org/obp/ui/#iso:std:iso-iec:2382:-1:ed-3:v1:en) defined 8 bits as the minimal representation of data that is know as a **Byte**. I.e.:
```
1 Byte = 8 bit
1B = 1b
```

This means 1 Byte can represent the values for 0 (zero), i.e., all bits as *zero*; all the way to, when all bits are *one*:
```
2^0 + 2^1 + 2^2 + 2^3 + 2^4 + 2^5 + 2^6 + 2^7
  1 +   2 +   4 +   8 +  16 +  32 +  64 + 128 = 255
```
I.e., 256 distinct values.

Since writing valuee, for instance, in a memory matrix that can have 1 to 3 digits is not that convinient (back in the day, full memories were dump to printers for debubbing) and not so easy to memorize, hexadecimal, although not at all mandatory, became a standard for representing Bytes where 2 hexadecimal digits represent 1 single Byte because:
```
16 * 16 = 256
```

And since our (more common) decimal system only has 10 digits, 6 letters form *A* (or *a*) to *F* (or *f*) are used as the remaining digits. 
> *Hexadecimal* notation means nothing to the computer. It's strictly a human readabilty helper notation.


### 1.0 Before the Light

#### Let there be light

A (normal, everyday) computer is, in essence, a very simple machine that can only be told to do one thing. As such, when a computer starts or is rebooted, it can only go to a pre-defined place that will tell it what to do. This place is called **B**asic **I**nput/**O**utput **S**ystem. The *BIOS* is a software that is installed in the computer's **R**ead **O**nly **M**emory. 

The *BIOS* function, among other things out of the scope of this story (maybe I'll go there, someday), is to, after some hardware checks, choose from what device the computer should boot: there can be only one. There might be many bootable devices connected to the computer (e.g., floppy-disk, hard disk, USB stick, etc.) but, by whatever configuration, the *BIOS* can only choose what to boot. Normally, for a device to be chosen it needs 2 things:
- To be registered/configured in *BIOS* boot order;
- To be identifiable as bootable: on x86 architecture, this means the 511th Byte of it's memory has the value of 0xAA of it's memory and the 512th has the value of 0x55.


After a device is chosen, the boot sector on that device is loaded into memory and then sent for execusion to the CPU.
