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
    func didAppendMovie()
    func didRemoveMovie()
}

/// MovieFileSaver deals with saving json file to the document directory
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
    
    func appendJsonFile(filename fileName:String, movie: Movie){
        var favouriteList = loadJsonData(filename: fileName)
        favouriteList.append(movie)
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(favouriteList)
            saveJsonToFile(filename: fileName, data: jsonData)
            self.delegate?.didAppendMovie()
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func removeFromJsonFile(filename fileName:String,id: Int){
        var favouriteList: [Movie] = loadJsonData(filename: fileName)
        let index = favouriteList.firstIndex(where: { movie in movie.id == id})
        favouriteList.remove(at: index!)
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(favouriteList)
            saveJsonToFile(filename: fileName, data: jsonData)
            self.delegate?.didRemoveMovie()
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    /// Save the list of movies to a json
    ///
    /// - Parameter fileName: json file name
    /// - Parameter data: ist of movies to save
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
    
    /// Fetch movie from a json file
    ///
    /// - Parameter fileName: json file name
    /// - Returns: list of movie inside json file
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
    
    
    /// Fetch movie from a json file
    ///
    /// - Parameter fileName: json file name
    /// - Returns: list of movie inside json file
    func loadJsonData(filename fileName: String) -> [Movie]{
        let fileToReadUrl = getDocumentsDirectory().appendingPathComponent(fileName).appendingPathExtension("json")
        do{
            let data = try Data(contentsOf: fileToReadUrl)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode([Movie].self, from: data)
            return decoded
        }catch let error{
            fatalError(error.localizedDescription)
        }
    }
}
