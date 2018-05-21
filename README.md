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
    1              0          1            1            1            (binary, base 2)
2<<sup>4x1 + 2<<sup>3x0 + 2<<sup>2x1 + 2<<sup>1x1 + 2<<sup>0x1
   16x1    +      8x0   +    4x1     +    2x1     +    1x1     = 23  (decinal, base 10)
```

#### Physics

The only things in physics relevant for this story are:
- In storage, a *zero* and a *one* are distinguished by, for isntance but depending on the memory type, the existense or electrical current in the place where that position is.
- In communication (e.g., from a network device to and from CPU, there are 3 voltages corresponding to each of the comnicating states: *no data*, *zero* and *one*,

This means that, in terms of (any) memory, there will always be a value of either *zero* or *one*. In terms of communication, one needs to be very conscient of how hard it might be to know if all data (the whole sequence of *zero*s and *one*s has arrived already.

#### Notation

Notation is one of the great struggles of humanity. Writing things in a way that is efficient to store and immediate to read. TODO.

### 1.0 Before the Light

#### Let there be light

A (normal, everyday) computer is, in essence, a very simple machine that can only be told to do one thing. As such, when a computer starts or is rebooted, it can only go to a pre-defined place that will tell it what to do. This place is called **B**asic **I**nput/**O**utput **S**ystem. The *BIOS* is a software that is installed in the computer's **R**ead **O**nly **M**emory. 

The *BIOS* function, among other things out of the scope of this story (maybe I'll go there, someday), is to, after some hardware checks, choose from what device the computer should boot: there can be only one. There might be many bootable devices connected to the computer (e.g., floppy-disk, hard disk, USB stick, etc.) but, by whatever configuration, the *BIOS* can only choose what to boot. Normally, for a device to be chosen it needs 2 things:
- To be registered/configured in *BIOS* boot order;
- To be identifiable as bootable: on x86 architecture, this means the 511th Byte of it's memory has the value of 0xAA of it's memory and the 512th has the value of 0x55.


After a device is chosen, the boot sector on that device is loaded into memory and then sent for execusion to the CPU.
