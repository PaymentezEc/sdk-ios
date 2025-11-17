//
//  SwiftUIView.swift
//  NuveiSdkIOS
//
//  Created by Jorge on 7/11/25.
//

import SwiftUI

public struct NuveiLogoView: View {
    public init() {}
    @State private var fullText: String = "textEditable"
    public var body: some View {
       
        VStack{
            Image("nuvei", bundle: .module)
                .resizable().scaledToFit()
            Text("holaaaaaaa")
            TextEditor(text: $fullText)
                .foregroundColor(Color.gray)
                           .font(.custom("HelveticaNeue", size: 13))
                           .lineSpacing(5)
            
        }
    }
}

#Preview {
    NuveiLogoView()
}
