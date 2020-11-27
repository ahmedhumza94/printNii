//
//  niiInterface.swift
//  printNii
//
//  Created by Humza Ahmed on 8/30/20.
//  Copyright © 2020 Humza Ahmed. All rights reserved.
//

import Foundation

let niiMap: [String: (offset: Int,size: [CStorageSize])] = [
    // Dictionary map of nifti spec
    // Keys are fields,
    // Values are a tuple of byte offsets and an array of CStorageSizes enums
    
    // key substruct
    "sizeof_hdr": (0,[cintsize]),
    "dataType": (4,Array(repeating: ccharsize, count: 10)),
    "dbName": (14,Array(repeating: ccharsize, count: 18)),
    "extents": (32,[cintsize]),
    "sessionError": (36,[cshortsize]),
    "regular": (38,[ccharsize]),
    "dimInfo": (39,[ccharsize]),
    // dim substruct
    "dim": (40,Array(repeating: cshortsize, count: 8)),
    "intent_p1": (56,[cfloatsize]),
    "intent_p2": (60,[cfloatsize]),
    "intent_p3": (64,[cfloatsize]),
    "intent_code": (68,[cshortsize]),
    "datatype": (70,[cshortsize]),
    "bitpix": (72,[cshortsize]),
    "slice_start": (74,[cshortsize]),
    "pixdim": (76,Array(repeating: cfloatsize, count: 8)),
    "vox_offset": (108,[cfloatsize]),
    "scl_slope": (112,[cfloatsize]),
    "scl_inter": (116,[cfloatsize]),
    "slice_end": (120,[cshortsize]),
    "slice_code": (122,[ccharsize]),
    "xyzt_units": (123,[ccharsize]),
    "cal_max": (124,[cfloatsize]),
    "cal_min": (128,[cfloatsize]),
    "slice_duration": (132,[cfloatsize]),
    "toffset": (136,[cfloatsize]),
    // data history substruct
    "glmax": (140,[cintsize]),
    "glmin": (144,[cintsize]),
    "descrip": (148,Array(repeating: ccharsize, count: 80)),
    "aux_file": (228,Array(repeating: ccharsize, count: 24)),
    "qform_code": (252,[cshortsize]),
    "sform_code": (254,[cshortsize]),
    "quatern_b": (256,[cfloatsize]),
    "quatern_c": (260,[cfloatsize]),
    "quatern_d": (264,[cfloatsize]),
    "qoffset_x": (268,[cfloatsize]),
    "qoffset_y": (272,[cfloatsize]),
    "qoffset_z": (276,[cfloatsize]),
    "srow_x": (280,Array(repeating: cfloatsize, count: 4)),
    "srow_y": (296,Array(repeating: cfloatsize, count: 4)),
    "srow_z": (312,Array(repeating: cfloatsize, count: 4)),
    "intent_name": (328,Array(repeating: ccharsize, count: 16)),
    "magic": (344,Array(repeating: ccharsize, count: 4))
]

public struct NiiHdr {
    public let hdr: [String: [CStore?]]
    public init(_ file: String) {
        let data = readBytes(from: file, nbytes: 348)
        let barr = makeBinaryArray(from: data)
        self.hdr = mapBinaryHdr(from: niiMap, with: barr)
    }
}
