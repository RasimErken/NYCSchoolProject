//
//  ViewModel.swift
//  MVVM
//
//  Created by rasim rifat erken on 30.07.2022.
//

import Foundation

class NYCViewModel {
    
    let url = URL(string: nycModelUrl)
    
    var schoolModel = [School]()
    
    func getALLData(completionHandler: @escaping () -> () ) {
        URLSession.shared.dataTask(with: url!) { ( data, response, error ) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            do {
                let finalData = try jsonDecoder.decode([School].self, from: data)
                self.schoolModel = finalData
                completionHandler()
            } catch  {
                print(error, "Couldn't be parsed correctly")
            }

        } .resume()
        
    }

    
    
    
}
