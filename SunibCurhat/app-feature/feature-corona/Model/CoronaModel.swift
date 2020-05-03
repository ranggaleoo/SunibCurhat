//
//  CoronaModel.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/05/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import Foundation
import MapKit

struct SummaryCovidResponse: Codable {
    let name, value : String
    
    enum Keys: String, CodingKey {
        case name, value
    }
    
    init(from decoder: Decoder) throws {
        let container   = try decoder.container(keyedBy: Keys.self)
        self.name       = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.value      = try container.decodeIfPresent(String.self, forKey: .value) ?? ""
    }
}

struct SummaryCovidCountryResponse: Codable {
    let name        : String
    let positif     : String
    let sembuh      : String
    let meninggal   : String
    
    enum Keys: String, CodingKey {
        case name, positif, sembuh, meninggal
    }
    
    init(from decoder: Decoder) throws {
        let container   = try decoder.container(keyedBy: Keys.self)
        self.name       = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.positif    = try container.decodeIfPresent(String.self, forKey: .positif) ?? ""
        self.sembuh     = try container.decodeIfPresent(String.self, forKey: .sembuh) ?? ""
        self.meninggal  = try container.decodeIfPresent(String.self, forKey: .meninggal) ?? ""
    }
}

struct CovidDataResponse: Codable {
    let attributes: CovidDataItem
}

struct CovidDataItem: Codable {
    let Provinsi: String
    let FID, Kode_Provi, Kasus_Posi, Kasus_Semb, Kasus_Meni: Int
    
    enum Keys: String, CodingKey {
        case Provinsi, FID, Kode_Provi, Kasus_Posi, Kasus_Semb, Kasus_Meni
    }
    
    init(from decoder: Decoder) throws {
        let container   = try decoder.container(keyedBy: Keys.self)
        self.Provinsi   = try container.decodeIfPresent(String.self, forKey: .Provinsi) ?? ""
        self.FID        = try container.decodeIfPresent(Int.self, forKey: .FID) ?? 0
        self.Kode_Provi = try container.decodeIfPresent(Int.self, forKey: .Kode_Provi) ?? 0
        self.Kasus_Posi = try container.decodeIfPresent(Int.self, forKey: .Kasus_Posi) ?? 0
        self.Kasus_Semb = try container.decodeIfPresent(Int.self, forKey: .Kasus_Semb) ?? 0
        self.Kasus_Meni = try container.decodeIfPresent(Int.self, forKey: .Kasus_Meni) ?? 0
    }
}

struct CovidDataResponses: Codable {
    let attributes: CovidDataItems
}

struct CovidDataItems: Codable {
    let Country_Region: String
    let Lat, Long_: CLLocationDegrees
    let OBJECTID, Last_Update, Confirmed, Deaths, Recovered, Active: Int
    
    enum Keys: String, CodingKey {
        case Country_Region, OBJECTID, Last_Update, Lat, Long_, Confirmed, Deaths, Recovered, Active
    }
    
    init(from decoder: Decoder) throws {
        let container           = try decoder.container(keyedBy: Keys.self)
        self.Country_Region     = try container.decodeIfPresent(String.self, forKey: .Country_Region) ?? ""
        self.OBJECTID           = try container.decodeIfPresent(Int.self, forKey: .OBJECTID) ?? 0
        self.Last_Update        = try container.decodeIfPresent(Int.self, forKey: .Last_Update) ?? 0
        self.Lat                = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .Lat) ?? 0
        self.Long_              = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .Long_) ?? 0
        self.Confirmed          = try container.decodeIfPresent(Int.self, forKey: .Confirmed) ?? 0
        self.Deaths             = try container.decodeIfPresent(Int.self, forKey: .Deaths) ?? 0
        self.Recovered          = try container.decodeIfPresent(Int.self, forKey: .Recovered) ?? 0
        self.Active             = try container.decodeIfPresent(Int.self, forKey: .Active) ?? 0
    }
}
