//
//  Constants.swift
//  BleDemo
//
//  Created by Marcos Borges on 27/05/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import CoreBluetooth

let SERVICE_UUID: CBUUID = CBUUID(string: "06888CAA-C22C-4C9A-9EC1-E609997B3C2E")
let RX_UUID: CBUUID = CBUUID(string: "3B71112B-5D97-4332-BF45-B6B82227E19C")
let RX_PROPERTIES: CBCharacteristicProperties = .write
let RX_PERMISSIONS: CBAttributePermissions = .writeable
let userName = "<Name>"
