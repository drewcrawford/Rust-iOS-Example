# Rust-based iOS framework

This is a proof-of-concept for writing an iOS framework in Rust.  

This might be interesting if you want to use a Rust library in your iOS application, or as part of your iOS Framework.  For example to have cross-platform Linux/iOS code, but you don't want to use C/C++.

In general,

1.  Define your externally-visible rust functions with
    1. pub
    2. extern
    3. #[no_mangle]
2.  build with make.sh.  Todo: convert this to a real build system
3.  link the built libhello.a into a framework
4.  You need one header file with "Public" visibility (`MyExportTEsts.h` in this project, cause I have shift key issues)
5.  Into this header you write prototypes for your Rust functions.  Todo: write a tool that generates this
6.  You need the special "export symbols" file.  See below.
7.  Import the header file from the master framework header file
8.  Framework can then be linked into project

In this project, iOSHostApp runs "Hello world" function inside the rust library.  There's also a benchmark() function.

# The case of the missing symbols.

What seems to happen is Xcode strips some symbols from a framework when it's built.  So if you have libhello.a inside a framework, and the framework doesn't call anything inside libhello.a, all of libhello.a is striped.  If you only call one function, the others are stripped etc.

So what you have to do is declare an exported_symbols.txt like

```
_hello
_benchmark
```

And then set that file as the framework's `Exported Symbols File` in the framework's build settings.

I tried doing it the other way, having a blank file and setting that as "Unexported symbols", which in theory should export everything.  But it doesn't work.

# FAQ

## Why do this?

Rust seems interesting.  Swift isn't cross-platform to Linux, so if you have problems that require writing the same code on two platforms it's hard.  C/C++ would work, but who wants to use that?

## How big is it?

The actual fully-loaded contribution of a "hello world" rust function seems to be 500-600kb.  The addition of some random benchmark I found on the web did not appreciably change this size.

The fat library is 22MB, but A) simulator slices get stripped during archive and B) Xcode seems to be quite agressive about eliminating unused symbols from the build.  It's hard to say what the damage is for a library that uses more Rust features--it could be as high as 13MB I guess, but I don't have much evidence of that.

## How fast is it?

That's a good question.   To answer it, I grabbed a random benchmark from the benchmarks game that built for both Rust and Clang.

With clang -Os, I got these timings:

```
2.23557704687119, 2.23559999465942, 2.26020604372025, 2.24301099777222, 2.23816096782684, 2.22583699226379, 2.23869597911835, 2.23592603206635, 2.22462803125381
```

For a 95% confidence interval between 2.231s and 2.244s.

On the Rust side, I got these timings:

```
7.64557099342346, 6.85503703355789, 7.723208963871, 6.32498902082443, 10.3305470347404, 5.84855103492737, 8.71086305379868, 6.51861500740051, 5.52227300405502
```

For a 95% confidence interval between 6.282 and 8.269.  Overall this is vaguely around 2.8-3.6x performance hit vs C in this benchmark.

I got similar results on the x64 simulator, suggesting that the x64 and arm64 stories are similar.  This runs against what I expected, as I thought that Rust's a64 would not be a focus area, but perhaps LLVM is doing the heavy lifting here.

This "about 3X" performance hit compares similarly to e.g. Mono and V8, but at considerably less memory overhead, [something like 1/6th for this particular benchmark.](http://benchmarksgame.alioth.debian.org/u32/performance.php?test=fasta)

So the result is, if you need a reasonably-fast cross-platform language, Rust isn't a bad choice, especially if you have memory problems.