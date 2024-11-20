package build

import std.process.Process
import std.collection.ArrayList
import glob.{globWith, MatchOptions}

main(): Int64 {
    match (Process.current.arguments[0]) {
        case "pre-build" => stagePreBuild()
        case _ => 0
    }
}

@When[os == "Linux" || os == "macOS"]
const DLL_PREFIX = "lib"

@When[os == "Windows"]
const DLL_PREFIX = ""

@When[os == "Linux"]
const DLL_SUFFIX = ".so"

@When[os == "macOS"]
const DLL_SUFFIX = ".dylib"

@When[os == "Windows"]
const DLL_SUFFIX = ".dll"


@When[os == "Linux"]
const OS = "Linux"

@When[os == "macOS"]
const OS = "macOS"

@When[os == "Windows"]
const OS = "Windows"

func stagePreBuild(): Int64 {
    let files = ArrayList<String>("${DLL_PREFIX}clang${DLL_SUFFIX}")
    
    match(OS) {
        case "Linux" => 
            files.append("libclang-*.so")
            files.append("libclang.so.*")
            files.append("libclang-*.so.*")
        case "Windows" => 
            files.append("libclang.dll")
        case _ => ()
    }

    let search = { d: String => 
        var options = MatchOptions()
        options.requireLiteralSeparator = true
        for (f in files) {
            let p = globWith("${d}/${f}", options)
            if (let Some(bin) <- p.next()) {
                return bin;
            }
        }
        throw Exception("Cannot find required files")
    }

    
    return 0
}