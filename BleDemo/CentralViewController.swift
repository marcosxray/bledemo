//
//  CentralViewController.swift
//  BleDemo
//
//  Created by Marcos Borges on 27/05/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import UIKit
import CoreBluetooth

// MARK: - Class

class CentralViewController: UIViewController {
    
    private var centralManager: CBCentralManager!
    private var discoveredPeripherals: Set<CBPeripheral> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
}

// MARK: - CB Central Manager Delegate

extension CentralViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            debugPrint("Bluetooth powered on, scanning for peripherals.")
            centralManager.scanForPeripherals(withServices: [SERVICE_UUID], options: nil)
        default:
            print("Bluetooth needs to be powered on!")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        debugPrint("\(peripheral.name ?? "")")
        discoveredPeripherals.insert(peripheral)
        debugPrint("Trying to connect to peripheral....: \(peripheral)")
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected: \(peripheral.identifier)")
        peripheral.delegate = self
        peripheral.discoverServices([SERVICE_UUID])
    }
}

// MARK: - Peripheral Delegate

extension CentralViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            debugPrint("Service found: \(service)")
            peripheral.discoverCharacteristics([RX_UUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            debugPrint("Characteristic found: \(characteristic)")
            if characteristic.properties.contains(.write) {
                guard let data = "Test message though Bluetooth".data(using: .utf8) else { return }
                peripheral.writeValue(data, for: characteristic, type: .withResponse)
            }
        }
    }
}
