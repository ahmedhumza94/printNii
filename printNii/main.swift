//
//  main.swift
//  printNii
//
//  Created by Humza Ahmed on 8/30/20.
//  Copyright © 2020 Humza Ahmed. All rights reserved.
//

import Foundation

let testHdr = niiHdr()
for (field, value) in testHdr.hdr {
    print(field)
    print(printCStoreArray(value))
}
