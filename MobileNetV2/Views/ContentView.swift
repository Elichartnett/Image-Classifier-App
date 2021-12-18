//
//  ContentView.swift
//  MobileNetV2
//
//  Created by Eli Hartnett on 12/17/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ClassifiedObjectModel
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                Image(uiImage: UIImage(data: model.objectToClassify.image) ?? UIImage())
                    .resizable()
                    .frame(width: geo.size.width, height: geo.size.width)
                
                HStack {
                    Text("Classifications:")
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        model.getImage()
                        model.objectToClassify.results.removeAll()
                    } label: {
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .frame(width: 100, height: 40)
                                .shadow(radius: 5)
                            Text("Next")
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                
                if model.objectToClassify.results.count != 0 {
                    ScrollView {
                        ForEach(0..<3) { index in
                            VStack {
                                ResultCard(identifier: model.objectToClassify.results[index].identifier, confidence: Double(model.objectToClassify.results[index].confidence), geo: geo)
                            }
                            .padding(.top)
                        }
                    }
                }
                else {
                    ProgressView()
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ClassifiedObjectModel())
    }
}
