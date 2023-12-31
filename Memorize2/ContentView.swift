//
//  ContentView.swift
//  Memorize2
//
//  Created by Curtis DeGidio on 8/26/23.
//

import SwiftUI

struct ContentView: View {
    let vehicles: Array<String> = [
        "✈️", "✈️", "🛻", "🛻", "🚜", "🚜", "🚗", "🚗",
        "🚛", "🚛", "🚔", "🚔", "⛵️", "⛵️", "🚎", "🚎"
    ]
    let people: Array<String> = [
        "🦹‍♀️", "🦹‍♀️", "🤷🏽‍♂️", "🤷🏽‍♂️", "💃🏿", "💃🏿", "🕺🏻", "🕺🏻",
        "🏋️‍♂️", "🏋️‍♂️", "🤸‍♀️", "🤸‍♀️", "👨🏼‍🦳", "👨🏼‍🦳", "💂🏻‍♀️", "💂🏻‍♀️",
        "👩‍🦽", "👩‍🦽", "🦸🏻‍♀️", "🦸🏻‍♀️", "🧑🏽‍🔧", "🧑🏽‍🔧", "🏃🏿‍♀️", "🏃🏿‍♀️",
        "🤹🏻‍♂️", "🤹🏻‍♂️", "🚴🏻‍♀️", "🚴🏻‍♀️", "🥷", "🥷", "🧙🏼‍♂️", "🧙🏼‍♂️"
    ]
    let techs: Array<String> = [
        "💻", "💻", "📱", "📱", "⌚️", "⌚️", "🖥️", "🖥️",
        "🖨️", "🖨️", "☎️", "☎️", "📀", "📀", "💾", "💾",
        "📡", "📡", "🕹️", "🕹️", "📷", "📷", "📻", "📻"
    ]
    
    @State var emojis: Array<String>
    @State var cardCount: Int
    @State var themeColor: Color
    
    init() {
        self.emojis = self.vehicles.shuffled()
        self.cardCount = self.vehicles.count
        self.themeColor = .red
    }
    
    var body: some View {
        VStack {
            title
            ScrollView {
                cards
            }
            Spacer()
            themeSelector
        }
        .padding()
    }
    
    var title: some View {
        Text("Memorize!")
            .font(.largeTitle)
            .fontWeight(.bold)
    }
    
    var cards: some View {
        HStack {
            GeometryReader { geometry in
                let cardWidth = widthThatBestFits(cardCount: emojis.count, screenWidth: geometry.size.width)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: cardWidth))]) {
                    ForEach(0..<emojis.count, id: \.self) { index in
                        CardView(content: emojis[index])
                            .aspectRatio(2/3, contentMode: .fill)
                    }
                }
            }
        }
        .foregroundColor(themeColor)
    }
    
    var themeSelector: some View {
        HStack {
            themeSelector(theme: "Vehicles", symbol: "car.fill")
            themeSelector(theme: "People", symbol: "person.crop.circle.fill")
            themeSelector(theme: "Tech", symbol: "desktopcomputer")
        }
    }
    
    func themeSelector(theme: String, symbol: String) -> some View {
        Button(action: {
            switch theme {
            case "People":
                let bounds = randomCardCount(from: people)
                emojis = people[bounds.lbound..<bounds.ubound].shuffled()
                themeColor = .purple
            case "Tech":
                let bounds = randomCardCount(from: techs)
                emojis = techs[bounds.0..<bounds.1].shuffled()
                themeColor = .blue
            default:
                let bounds = randomCardCount(from: vehicles)
                emojis = vehicles[bounds.0..<bounds.1].shuffled()
                themeColor = .red
            }
            
            cardCount = emojis.count
        }, label: {
            VStack {
                Image(systemName: symbol)
                Text(theme)
            }
        })
        .imageScale(.large)
        .font(.callout)
    }
    
    func randomCardCount(from array: Array<String>) -> (lbound: Int, ubound: Int) {
        let size = array.count
        let mid = (floor(Double(size) / 2) - 1)
        
        var lowerBound = Int.random(in: 0...Int(mid))
        if lowerBound % 2 != 0 {
            lowerBound = lowerBound + 1
        }
        
        var upperBound: Int = Int.random(in: lowerBound...size)
        if upperBound - lowerBound < 4 {
            upperBound = lowerBound + 4
        }
        
        if upperBound % 2 != 0 {
            upperBound = upperBound + 1
        }
        
        print("lowerBound: \(lowerBound), upperBound: \(upperBound)")
        
        return (lbound: lowerBound, ubound: upperBound)
    }
    
    func widthThatBestFits(cardCount: Int, screenWidth: CGFloat) -> CGFloat {
        var cardWidth: CGFloat = 0
        
        if cardCount >= 30 {
            cardWidth = screenWidth / 8
        } else if cardCount >= 24 {
            cardWidth = screenWidth / 6
        } else if cardCount >= 16 {
            cardWidth = screenWidth / 4
        } else if cardCount >= 8 {
            cardWidth = screenWidth / 3
        } else {
            cardWidth = screenWidth / 2
        }
        
        print("cardWidth: \(cardWidth)")
        
//        @Environment(\.displayScale) var displayScale
//        print("displayScale: \(displayScale)")
        
        return cardWidth - 20
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
