//
//  fertilizerBar.swift
//  Nano1ShakeFeature
//
//  Created by Bryan Vernanda on 29/04/24.
//

import SwiftUI

struct fertilizerBar: View {
    @Binding var current:CGFloat
    var width: CGFloat = 189.0
    var height: CGFloat = 20.0
    
    var body: some View {
        let multiplier = width/100
        
        ZStack(alignment: .leading) {
            
            RoundedRectangle(cornerRadius: 100, style: .continuous)
                .frame(width: width + 11, height: height)
                .foregroundColor(Color(UIColor(red: 135/255, green: 119/255, blue: 18/255, alpha: 1)))
                .padding(.leading, 2)
            
            RoundedRectangle(cornerRadius: 100, style: .continuous)
                .frame(width: width + 5, height: height - 6)
                .foregroundColor(Color.white)
                .padding(.leading, 5)
            
            RoundedRectangle(cornerRadius: 100, style: .continuous)
                .frame(width: (current * 5) * multiplier, height: height - 10)
                .background(
                    Color(UIColor(red: 135/255, green: 119/255, blue: 18/255, alpha: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                )
                .foregroundColor(.clear)
                .padding(.leading, 8)
            Image("fertilizerLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
        }
    }
}

#Preview {
    fertilizerBar(current: .constant(9))
}

