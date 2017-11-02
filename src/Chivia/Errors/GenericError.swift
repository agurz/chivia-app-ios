//
//  GenericError.swift
//  Chivia
//
//  Created by Agustín Rodríguez on 11/2/17.
//  Copyright © 2017 Agustín Rodríguez. All rights reserved.
//

import Foundation

class GenericError : Error, LocalizedError {

    private let message: String
    
    public var errorDescription: String? {
        return message
    }
    
    public var localizedDescription: String {
        return message
    }
    
    init(message: String) {
        self.message = message
    }
    
}
