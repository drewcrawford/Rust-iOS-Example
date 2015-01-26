rustc --target=x86_64-apple-ios hello.rs --crate-type=staticlib -O -o libhello-x64.a
rustc --target=i386-apple-ios hello.rs --crate-type=staticlib -O -o libhello-x32.a
rustc --target=aarch64-apple-ios hello.rs --crate-type=staticlib -O -o libhello-a64.a
rustc --target=armv7s-apple-ios hello.rs --crate-type=staticlib -O -o libhello-a7s.a
rustc --target=armv7-apple-ios hello.rs --crate-type=staticlib -O -o libhello-a7.a

lipo -create libhello-x64.a libhello-x32.a libhello-a64.a libhello-a7s.a libhello-a7.a -o libhello.a