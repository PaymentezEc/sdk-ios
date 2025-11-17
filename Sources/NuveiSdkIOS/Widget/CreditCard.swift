//
//  SwiftUIView 2.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 11/11/25.
//

import SwiftUI


struct CreditCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            content
        }
    }
}


struct CreditCardFront: View {
    let cardNumber: String
    let name: String
    let expires: String
    let cardTypeImage: String
    let colors: [Color]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .top) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.white)
            
                Spacer()
                Image(cardTypeImage, bundle: .nuvei)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 30)
                    .foregroundColor(.white)
               
            
            }
            
            Spacer()
            
            Text(cardNumber.isEmpty ? "**** **** **** ****" : cardNumber)
                           .foregroundColor(.white)
                           .font(.system(size: 20, weight: .bold, design: .monospaced))
            
            Spacer()
            
            HStack {
                
                VStack(alignment: .leading) {
                    Text("CARD HOLDER")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gray)
                    
                    Text(name.isEmpty ? "FULL NAME" : name.uppercased())
                                            .foregroundColor(.white)
                                            .font(.caption)
                    
                }
                
                Spacer()
                
                VStack {
                    Text("EXPIRES")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gray)
                    Text(expires.isEmpty ? "MM/YY" : expires)
                                            .foregroundColor(.white)
                                            .font(.caption)
                }
                
            }
            
            
            
        }.frame(width: 300, height: 200)
        .padding()
        .background(
                   LinearGradient(
                       colors: colors,
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing
                   )
               )
        .cornerRadius(10)
    }
}


struct CreditCardBack: View {
    
    let cvv:String
    let colors: [Color]
    
    var body: some View {
        VStack {
           
            Rectangle()
                            .frame(height: 40)
                            .foregroundColor(.black.opacity(0.8))
                            .padding(.top, 20)
                            .cornerRadius(10)
            Spacer()
            
            HStack {
                
                Text(cvv.isEmpty ? "" : cvv)
                    .font(.headline)
                    .foregroundColor(Color.black)
                    .padding(5)
                    .frame(width: 100, height: 30)
                    .background(Color.white)
                    .cornerRadius(20)
                    .rotation3DEffect(
                        .degrees(180),
                        axis: (x: 0.0, y: 1.0, z: 0.0))
                
                
                Spacer()
            }.padding()
            
        }.frame(width: 300, height: 200)
        .padding()
        .background(
                       LinearGradient(
                           colors: colors,
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing
                       )
                   )
        .cornerRadius(10)
    }
}


struct CreditCard_Previews: PreviewProvider {
    static var previews: some View {
        CreditCard<CreditCardFront>(content: { CreditCardFront(cardNumber: "541", name: "Mohammad Azam", expires: "02/06", cardTypeImage: "stp_card_unknown", colors: [Color.blue, Color.black], ) })
    }
}
