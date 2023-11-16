//
//  Card.swift
//  TheGameClone
//
//  Created by Andy M on 5/19/23.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var card = UTType(exportedAs: "andymeagher.TheGameClone.card")
}

struct Card: Identifiable, Codable, Hashable, Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .card)
    }
    
    let number: Int
    var text: String { String(number) }
    var id: Int { number }
    var color: Color { Color(hue: .random(in: 0.8...1), saturation: 1, brightness: 1) }
}
let cardWidth = UIScreen.main.bounds.width / 5 - 8

struct EmptySlot:View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(.white)
                .frame(width: cardWidth, height: 100)
                .cornerRadius(15)
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(style: StrokeStyle(lineWidth: 4, dash: [10], dashPhase: 0))
                .frame(width: cardWidth, height: 100)
                .cornerRadius(15)
        }
    }
}

struct CardView: View {
    var card: Card?
    @State var isDragging: Bool = false
    
    var body: some View {
        if isDragging{
            EmptySlot()
        }else if let card = card{
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(SwiftUI.Color.black, lineWidth: 3)
                    .frame(width: cardWidth, height: 100)
                    .background(card.color)
                    .cornerRadius(15)
                VStack{
                    Text(card.text)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            }
        }else{
            EmptySlot()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: nil)
    }
}
