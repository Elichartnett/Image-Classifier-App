//
//  ContentView.swift
//  MobileNetV2
//
//  Created by Eli Hartnett on 12/17/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ClassifiedObjectModel
    @State var pos = CGPoint(x: 1, y: 1)
    var animation: Animation {
        .spring(response: 0.5, dampingFraction: 0.8)
    }
    
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
                        
                        pos = CGPoint(x: geo.size.width/2, y: geo.size.height)
                        
                        withAnimation(animation) {
                            pos = CGPoint(x: geo.size.width/2, y: 40)
                        }
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
                            ResultCard(identifier: model.objectToClassify.results[index].identifier, confidence: Double(model.objectToClassify.results[index].confidence), geo: geo)
                                .padding(.top, 10)
                                .position(pos)
                        }
                    }
                    .onAppear {
                        pos = CGPoint(x: geo.size.width/2, y: geo.size.height)
                        
                        withAnimation(animation) {
                            pos = CGPoint(x: geo.size.width/2, y: 40)
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
