//
//  ViewModel2.swift
//  MVVM
//
//  Created by rasim rifat erken on 9.08.2022.
//

import Foundation

class SatViewModel {
    
    let url = URL(string: satModelUrl)
    
    var satSchoolModel = [SatSchool]()
    
    func getALLData2(completionHandler: @escaping () -> () ) {
        URLSession.shared.dataTask(with: url!) { ( data, response, error ) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            do {
                let finalData = try jsonDecoder.decode([SatSchool].self, from: data)
                self.satSchoolModel = finalData
                completionHandler()
            } catch  {
                print(error, "Couldn't be parsed correctly")
            }

        } .resume()
        
    }

    
    
    
}

