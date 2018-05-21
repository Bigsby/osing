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

### 1.0 Nothing


