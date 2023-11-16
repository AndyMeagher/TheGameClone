//
//  ContentView.swift
//  TheGameClone
//
//  Created by Andy M on 5/18/23.
//

import SwiftUI

enum Direction{
    case up, down
}

struct DiscardPile {
    let direction: Direction
    var cards: [Card]
}



struct ContentView: View {
    @State var remainingDeck : [Card] = Array(2...99).map{Card(number: $0)}
    @State var playerHand : [Card?] = [nil, nil, nil, nil, nil]
    
    @State var upPileA : DiscardPile = DiscardPile(direction: .up,
                                                   cards: [])
    @State var upPileB : DiscardPile = DiscardPile(direction: .up,
                                                   cards: [])
    @State var downPileA : DiscardPile = DiscardPile(direction: .down,
                                                     cards: [])
    @State var downPileB : DiscardPile = DiscardPile(direction: .down,
                                                     cards: [])
    
    @State private var showingNotAllowedAlert = false
    @State private var show2MovesAlert = false

    
    var body: some View {
        VStack{
            Text("Cards Left in Deck: \(remainingDeck.count)").font(.title)
            HStack{
                Spacer()
                
                CardView(card: Card(number: 1))
                
                Spacer()
                
                CardView(card: Card(number: 1))
                
                Spacer()
                
                CardView(card: Card(number: 100))
                
                Spacer()
                
                CardView(card: Card(number: 100))
                
                Spacer()
            }
            
            HStack{
                Spacer()
                CardView(card: upPileA.cards.last)
                    .dropDestination(for: Card.self){ items, location in
                        if let card = items.first{
                            add(card: card, to: &upPileA)
                        }
                        return true
                    } 
                Spacer()
                
                CardView(card: upPileB.cards.last)
                    .dropDestination(for: Card.self){ items, location in
                        if let card = items.first{
                            add(card: card, to: &upPileB)
                        }
                        return true
                    }
                Spacer()
                
                CardView(card: downPileA.cards.last)
                    .dropDestination(for: Card.self){ items, location in
                        if let card = items.first{
                            add(card: card, to: &downPileA)
                        }
                        return true
                    }
                Spacer()
                
                CardView(card: downPileB.cards.last)
                    .dropDestination(for: Card.self){ items, location in
                        if let card = items.first{
                            add(card: card, to: &downPileB)
                        }
                        return true
                    }
                Spacer()
                
            }
            
            Spacer()
            
            
            let columns = Array(repeating: GridItem(spacing: 10), count: 4)
            LazyVGrid(columns: columns, spacing: 10, content:{
                ForEach(0...4, id: \.self) { index in
                    if let card = playerHand[index]{
                        CardView(card: card).draggable(card)
                    }else{
                        EmptySlot()
                    }
                    
                }
            })
            Spacer()
            
            Button("Deal Cards", action: {
                dealCards()
            })
        }
        .padding()
        .alert("That move is not allowed", isPresented: $showingNotAllowedAlert) {
            Button("OK", role: .cancel) {
                showingNotAllowedAlert = false
            }
        }
        .alert("You must play at least 2 Cards", isPresented: $show2MovesAlert) {
            Button("OK", role: .cancel) {
                show2MovesAlert = false
            }
        }
    }
    
    
    func add(card: Card, to discardPile: inout DiscardPile) {
        if moveAllowed(discardPile: discardPile, card: card){
            discardPile.cards.append(card)
            removePlayerCard(card: card)
        }else{
            showingNotAllowedAlert = true
        }
    }
    
    func moveAllowed(discardPile: DiscardPile, card: Card) -> Bool{
        if discardPile.cards.isEmpty{
            return true
        }
        
        switch discardPile.direction {
        case .up:
            return card.number > discardPile.cards.last!.number || (discardPile.cards.last!.number - 10) == card.number
        case .down:
            return card.number < discardPile.cards.last!.number || (discardPile.cards.last!.number + 10) == card.number
        }
    }
    
    func removePlayerCard(card: Card){
        if let index = playerHand.firstIndex(where: { c in
            c?.id == card.id
        }){
            playerHand[index] = nil
        }
    }
    
    func dealCards(){
        let amt = 5 - playerHand.filter{$0 != nil}.count
        if amt < 2{
            show2MovesAlert = true
            return
        }
        remainingDeck.shuffle()
        for (index, item) in playerHand.enumerated(){
            if item == nil{
                playerHand[index] = remainingDeck.removeLast()
            }
        }
    }
}
