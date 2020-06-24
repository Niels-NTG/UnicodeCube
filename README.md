# UnicodeCube

3D cube visualisation of all code points in Unicode from `0x0000` till `0xFFFF`, which includes all 1 byte and 2 bytes long charachters of UTF16.

Out of the box Java 8 only seems to support UTF16 charachters, which is already a lot better than some of the other populair languages (looking at you C++). For anything beyond `0xFFFF` I need UTF32, which I haven't been able to get working in Java thus far. If anybody knows how, feel free to tell me.
