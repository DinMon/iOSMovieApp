//
//  MovieFileSaver.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 22/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import Foundation

protocol MovieFileSaverDelegate{
    func didFetchMovies(data: [Movie])
}

class MovieFileSaver{
    
    var delegate: MovieFileSaverDelegate?
    
    func getDocumentsDirectory() -> URL {
        guard let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{
            fatalError("Cannot get Documents directory.")
        }
        return documentsUrl
    }
    
    func copyFileToDocuments(filename fileName:String) -> Bool{
        let documentsUrl = getDocumentsDirectory()
        let destFile = documentsUrl.appendingPathComponent(fileName).appendingPathExtension("json")
        if !FileManager.default.fileExists(atPath: destFile.path)
        {
            // Copy file
            guard let srcFileUrl = Bundle.main.url(forResource: fileName, withExtension: "json") else{
                print("Cannot find filename \(fileName)")
                return false
            }
            
            do {
                try FileManager.default.copyItem(at: srcFileUrl, to: destFile)
            } catch{
                print("Cannot copy filename \(fileName) to documents directory")
                return false
            }
        } else{
            return true
        }
        return true
    }
    
    func saveJsonToFile(filename fileName:String, data: Data){
        let documentsUrl = getDocumentsDirectory()
        let destFile = documentsUrl.appendingPathComponent(fileName).appendingPathExtension("json")
        if FileManager.default.fileExists(atPath: destFile.path)
        {
            do {
                try data.write(to: destFile, options: .atomic)
            } catch let error{
                print(error.localizedDescription)
            }
        }else{
            do{
                try "".write(to: destFile, atomically: true, encoding: .utf8)
            } catch let error{
                print(error.localizedDescription)
            }
        }
    }
    
    func loadJson(filename fileName: String){
        if copyFileToDocuments(filename: fileName){
            let fileToReadUrl = getDocumentsDirectory().appendingPathComponent(fileName).appendingPathExtension("json")
            do{
                let data = try Data(contentsOf: fileToReadUrl)
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([Movie].self, from: data)
                self.delegate?.didFetchMovies(data: decoded)
            }catch let error{
                fatalError(error.localizedDescription)
            }
        }else{
            fatalError("Cannot access the filename \(fileName)")
        }
    }
}
