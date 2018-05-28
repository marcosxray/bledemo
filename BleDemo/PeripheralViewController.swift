//
//  PeripheralViewController.swift
//  BleDemo
//
//  Created by Marcos Borges on 27/05/2018.
//  Copyright © 2018 BLE. All rights reserved.
//

import UIKit
import CoreBluetooth

// MARK: - Class

class PeripheralViewController: UIViewController {
    
    private var peripheralManager: CBPeripheralManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralManager = CBPeripheralManager(delegate: self, queue: DispatchQueue.main)
    }
}

// MARK: - CB Peripheral Manager Delegate

extension PeripheralViewController: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("peripheral.state is .poweredOn")
            startAdvertising()
        default:
            print("Bluetooth needs to be powered on!")
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if let value = request.value {
                let messageText = String(data: value, encoding: String.Encoding.utf8) as String?
                debugPrint("Message received: \(messageText!)")
            }
            peripheralManager.respond(to: request, withResult: .success)
        }
    }
    
    private func startAdvertising() {
        createPeripheralService()
        let advertisementData = String(format: "%@", userName)
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[SERVICE_UUID],
                                            CBAdvertisementDataLocalNameKey: advertisementData])
        debugPrint("Sending broadcast messages.")
    }
    
    private func createPeripheralService() {
        let serialService = CBMutableService(type: SERVICE_UUID, primary: true)
        let writeCharacteristics = CBMutableCharacteristic(type: RX_UUID,
                                                           properties: RX_PROPERTIES, value: nil,
                                                           permissions: RX_PERMISSIONS)
        serialService.characteristics = [writeCharacteristics]
        peripheralManager.add(serialService)
    }
}
