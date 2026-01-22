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
                Text("\(entry.amount) ml")
                    .foregroundStyle(.gray)
            }
            HStack {
                Text("Time")
                Spacer()
                Group {
                    Text(entry.timestamp!, style: .date)
                    Text(entry.timestamp!, style: .time)
                }
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
