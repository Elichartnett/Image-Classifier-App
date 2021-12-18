//
//  ClassifiedObjectModel.swift
//  MobileNetV2
//
//  Created by Eli Hartnett on 12/17/21.
//

import Foundation
import Vision
import CoreML

class ClassifiedObjectModel: ObservableObject {
    
    @Published var objectToClassify = ClassifiedObject()
    
    init() {
        getImage()
    }
    
    func getImage() {
        let urlString = "https://picsum.photos/400"
        
        let url = URL(string: urlString)
        
        guard url != nil else {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.objectToClassify.image = data!
                    self.classifyImage()
                }
            }
            else {
                print(error!.localizedDescription)
            }
        }
        
        dataTask.resume()
    }
    
    func classifyImage() {
        do {
            let modelFile = try MobileNetV2(configuration: MLModelConfiguration())
            
            let model = try VNCoreMLModel(for: modelFile.model)
            
            let handler = VNImageRequestHandler(data: objectToClassify.image)

            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else {
                    print("Could not classify")
                    return
                }
                
                for classification in results {
                    var identifier = classification.identifier
                    let confidence = classification.confidence
                    identifier = identifier.prefix(1).capitalized + identifier.dropFirst()
                    DispatchQueue.main.async {
                        self.objectToClassify.results.append(Result(identifier: identifier, confidence: confidence))
                    }
                }
            }
            
            do {
                try handler.perform([request])
            }
            catch {
                print(error.localizedDescription)
            }
        }
        catch {
            print(error.localizedDescription)
        }

        
    }
}
