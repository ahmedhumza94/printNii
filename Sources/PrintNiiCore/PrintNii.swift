//
//  File.swift
//  
//
//  Created by Humza Ahmed on 11/14/20.
//

import NiiHdrCore
import ArgumentParser

public struct PrintNii: ParsableCommand {
    @Argument(help: "Nii filename")
    var file: String
    
    public init() {}

    public mutating func run() throws {
        let niiHdr = NiiHdr(file)
        let fieldOrder: [String] = [
            //key substruct
            "sizeof_hdr","dataType","dbName",
            "extents","sessionError","regular",
            "dimInfo","dim",
            //dim substruct
            "intent_p1","intent_p2","intent_p3",
            "intent_code","datatype","bitpix",
            "slice_start","pixdim","vox_offset",
            "scl_slope","scl_inter","slice_end",
            "slice_code","xyzt_units","cal_max",
            "cal_min","slice_duration","toffset",
            //data history substruct
            "glmax","glmin","descrip",
            "aux_file","qform_code","sform_code",
            "quatern_b","quatern_c","quatern_d",
            "qoffset_x","qoffset_y","qoffset_z",
            "srow_x","srow_y","srow_z",
            "intent_name","magic"
            
        ]
        
        var text: String
        for currField in fieldOrder {
            text = currField + ": " + printCStoreArray(niiHdr.hdr[currField]!)
            print(text)
        }
    }
}
