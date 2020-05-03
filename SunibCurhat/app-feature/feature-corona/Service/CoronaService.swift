//
//  CoronaService.swift
//  SunibCurhat
//
//  Created by Rangga Leo on 02/05/20.
//  Copyright © 2020 Rangga Leo. All rights reserved.
//

import Foundation

class CoronaService {
    static let shared: CoronaService = CoronaService()
    
    func getTotalPositif(completion: @escaping (Result<SummaryCovidResponse, Error>) -> Void) {
        let url = URLConst.api_corona + "/positif"
        HTTPRequest.shared.connect(url: url, params: nil, model: SummaryCovidResponse.self) { (result) in
            completion(result)
        }
    }
    
    func getTotalSembuh(completion: @escaping (Result<SummaryCovidResponse, Error>) -> Void) {
        let url = URLConst.api_corona + "/sembuh"
        HTTPRequest.shared.connect(url: url, params: nil, model: SummaryCovidResponse.self) { (result) in
            completion(result)
        }
    }
    
    func getTotalMeninggal(completion: @escaping (Result<SummaryCovidResponse, Error>) -> Void) {
        let url = URLConst.api_corona + "/meninggal"
        HTTPRequest.shared.connect(url: url, params: nil, model: SummaryCovidResponse.self) { (result) in
            completion(result)
        }
    }
    
    func getSummaryCountry(completion: @escaping (Result<[SummaryCovidCountryResponse], Error>) -> Void) {
        let url = URLConst.api_corona + "/indonesia"
        HTTPRequest.shared.connect(url: url, params: nil, model: [SummaryCovidCountryResponse].self) { (result) in
            completion(result)
        }
    }
    
    func getCovidData(completion: @escaping (Result<[CovidDataResponse], Error>) -> Void) {
        let url = URLConst.api_corona + "/indonesia/provinsi"
        HTTPRequest.shared.connect(url: url, params: nil, model: [CovidDataResponse].self) { (result) in
            completion(result)
        }
    }
    
    func getCovidDataGlobal(completion: @escaping (Result<[CovidDataResponses], Error>) -> Void) {
        let url = URLConst.api_corona
        HTTPRequest.shared.connect(url: url, params: nil, model: [CovidDataResponses].self) { (result) in
            completion(result)
        }
    }
}
