//
//  ContentView.swift
//  Memorize2
//
//  Created by Curtis DeGidio on 8/26/23.
//

import SwiftUI

struct ContentView: View {
    var emojis: Array<String> = []
    let vehicles: Array<String> = [
        "✈️", "✈️", "🛻", "🛻", "🚜", "🚜", "🚗", "🚗",
        "🚛", "🚛", "🚔", "🚔", "⛵️", "⛵️", "🚎", "🚎"
    ]
    
    var body: some View {
        HStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
                ForEach(0..<vehicles.count, id: \.self) { index in
                    CardView(content: vehicles[index])
                        .aspectRatio(2/3, contentMode: .fit)
                }
            }
        }
        .foregroundColor(.orange)
        .padding()
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp = true
    
    var body: some View {
        let base = RoundedRectangle(cornerRadius: 12)
        
        ZStack {
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 5)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
