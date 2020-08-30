//
//  cInterface.swift
//  printNii
//
//  Created by Humza Ahmed on 8/30/20.
//  Copyright © 2020 Humza Ahmed. All rights reserved.
//

import Foundation

enum CStorageSize {
    // Enum representing needed c type sizes in a convenient format
    // By default associated values repesent the storage size of the
    // respective type
    case cint(Int = MemoryLayout<CInt>.size)
    case cchar(Int = MemoryLayout<CChar>.size)
    case cshort(Int = MemoryLayout<CShort>.size)
    case cfloat(Int = MemoryLayout<CFloat>.size)
}

// Convenient names lowercased since they will be used essentially as a property
let cintsize = CStorageSize.cint()
let ccharsize = CStorageSize.cchar()
let cshortsize = CStorageSize.cshort()
let cfloatsize = CStorageSize.cfloat()

enum CStore {
    // An enum to store c types
    case cint(CInt)
    case cchar(CChar)
    case cshort(CShort)
    case cfloat(CFloat)
}

func readBytes(from file: String, nbytes: Int) -> [UInt8] {
    // function reads a specified number of bytes from file and returns an array
    // of UInt8 values
    
    let fid = fopen(file,"r")
    print(fid)
    // Read n bytes from file and refrence in pointer
    let pointer = UnsafeMutableRawPointer.allocate(byteCount: nbytes, alignment: 8)
    fread(pointer,nbytes,1, fid)
    // Convert byte pointer into a collection
    let buffer = UnsafeRawBufferPointer(start: pointer, count: nbytes)
    let byteArray = Array(buffer)
    defer {
        // Deallocate pointers and close file
        pointer.deallocate()
        fclose(fid)
    }
    // Converting buffer to an array results in a [UInt8]
    return byteArray
}

func makeBinaryArray(from arr: [UInt8]) -> [String] {
    var binArr = [String]()
    // Iterate over every byte
    for byte in arr {
        // Get a binary string representation
        var s = String(byte, radix: 2)
        // Preappend with any needed 0's to represent all 8 bits
        s = String(repeating: "0", count: 8 - s.count) + s
        binArr.append(s)
    }
    return binArr
}

func storeAsC(fromBinary str: String, representing: CStorageSize) -> CStore? {
    if case CStorageSize.cint(_) = representing {
        return CStore.cint(CInt(str, radix: 2)!)
    } else if case CStorageSize.cchar(_) = representing {
        return CStore.cchar(CChar(str,radix: 2)!)
    } else if case CStorageSize.cfloat(_) = representing {
        return CStore.cfloat(CFloat(bitPattern: CUnsignedInt(str,radix: 2)!))
    } else if case CStorageSize.cshort(_) = representing {
        return CStore.cshort(CShort(str,radix: 2)!)
    } else {
        return nil
    }
}

func printCStoreArray(_ arr: [CStore?]) -> String {
    let arrNoNil = arr.compactMap { $0 }
    var text = [String]()
    for (i,value) in arrNoNil.enumerated() {
        switch value {
        case CStore.cint(let x):
            if i > 0 { text.append(" ") }
            text.append(String(x))
        case CStore.cchar(let x):
            text.append(String(bytes: [UInt8(bitPattern: x)], encoding: .ascii)!)
        case CStore.cfloat(let x):
            if i > 0 { text.append(" ") }
            text.append(String(x))
        case CStore.cshort(let x):
            if i > 0 { text.append(" ") }
            text.append(String(x))
        }
    }
    return text.joined()
}

func mapBinaryHdr(from template: [String: (offset: Int,size: [CStorageSize])],
                  with binaryArray: [String]) -> [String: [CStore?]] {
    
    var hdr: [String: [CStore?]] = [:]
    
    for (key, value) in template {
        let nElem = value.size.count
        var output: [CStore?] = []
        var currOffset = value.offset
        for i in 0..<nElem {
            switch value.size[i] {
            case CStorageSize.cint(let nBytes):
                let str = binaryArray[currOffset..<currOffset + nBytes].reversed().joined()
                currOffset += nBytes
                let t = storeAsC(fromBinary: str, representing: cintsize)
                output.append(t)
            case CStorageSize.cchar(let nBytes):
                let str = binaryArray[currOffset..<currOffset + nBytes].reversed().joined()
                currOffset += nBytes
                let t = storeAsC(fromBinary: str, representing: ccharsize)
                output.append(t)
            case CStorageSize.cfloat(let nBytes):
                let str = binaryArray[currOffset..<currOffset + nBytes].reversed().joined()
                currOffset += nBytes
                let t = storeAsC(fromBinary: str, representing: cfloatsize)
                output.append(t)
            case CStorageSize.cshort(let nBytes):
                let str = binaryArray[currOffset..<currOffset + nBytes].reversed().joined()
                currOffset += nBytes
                let t = storeAsC(fromBinary: str, representing: cshortsize)
                output.append(t)
             }
        }
        hdr[key] = output
    }
    return hdr
}
