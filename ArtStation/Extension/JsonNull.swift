//
//  JsonNull.swift
//  ArtStation
//
//  Created by MamooN_ on 6/7/21.
//

import Foundation

// MARK: - Encode/decode helpers

import Foundation

// MARK: Encode/decode helpers
class JSONNull: Codable {
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
