//
//  EntryDetails.swift
//  Boera
//
//  Created by Julian Schumacher on 20.05.25.
//

import SwiftUI

internal struct EntryDetails: View {
    
    internal var entry : DrinkEntry
    
    var body: some View {
        List {
            HStack {
                Text("Amount")
                Spacer()
                Text("\(entry.amount)")
                    .foregroundStyle(.gray)
            }
            HStack {
                Text("Time")
                Spacer()
                Text(entry.timestamp!, style: .date)
                    .foregroundStyle(.gray)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.automatic)
    }
}

//#Preview {
//    EntryDetails()
//}
