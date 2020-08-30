//
//  main.swift
//  printNii
//
//  Created by Humza Ahmed on 8/30/20.
//  Copyright © 2020 Humza Ahmed. All rights reserved.
//

import ArgumentParser

struct printNii: ParsableCommand {
    @Argument(help: "Nii filename")
    var file: String
    
    mutating func run() throws {
        let niiHdr = NiiHdr(file)
        var text: String
        for (field, value) in niiHdr.hdr {
            text = field + ": " + printCStoreArray(value)
            print(text)
        }
    }
}

printNii.main()
