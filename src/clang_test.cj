package clang_cj

import std.unittest.*
import std.unittest.testmacro.*

@Test
func simpleTest() {
    unsafe {
        var index = clang_createIndex(0, 0)
        var unit = clang_parseTranslationUnit(
            index,
            LibC.mallocCString("testdata/test.cpp"),
            CPointer<CString>(),
            0,
            CPointer<CXUnsavedFile>(),
            0,
            UInt32(CXTranslationUnit_None)
        )

        @Assert(unit.isNull(), false)

        var cursor = clang_getTranslationUnitCursor(unit)
    }
}
