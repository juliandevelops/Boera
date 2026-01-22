//
//  ContentView.swift
//  Boera
//
//  Created by Julian Schumacher on 06.05.25.
//

import SwiftUI
import CoreData

internal struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    /// All drink entries sorted by timestamp
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \DrinkEntry.timestamp, ascending: true)],
        animation: .default
    )
    private var entries: FetchedResults<DrinkEntry>
    
    /// Whether or not the sheet to add a new entry is shown
    @State private var addEntryShown : Bool = false
    
    /// Set true to present the new drink sheet
    @State private var addDrinkPresented : Bool = false
    
    @State private var addIngredientPresented : Bool = false

    @State private var errSavingPresented : Bool = false

    var body: some View {
        NavigationStack {
            // TODO: add image of bo
            homeBody()
                .sheet(isPresented: $addEntryShown) {
//                    AddEntrySheet()
                    AddEntrySimpleSheet()
                }
//                .sheet(isPresented: $addDrinkPresented) {
//                    AddDrinkSheet()
//                }
//                .sheet(isPresented: $addIngredientPresented) {
//                    AddIngredientSheet()
//                }
                .toolbar {
//                    ToolbarItem(placement: .automatic) {
//                        Menu {
//                            Button {
//                                addIngredientPresented.toggle()
//                            } label: {
//                                Label("Add new ingredient", systemImage: "carrot")
//                            }
//                            Divider()
//                            Button {
//                                addDrinkPresented.toggle()
//                            } label: {
//                                Label("Add new drink", systemImage: "waterbottle")
//                            }
//                        } label: {
//                            Image(systemName: "ellipsis.circle")
//                        }
//                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            addEntryShown.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .alert("Error saving", isPresented: $errSavingPresented) {

                } message: {
                    Text("There's been an error saving your data. Please try again")
                }
                .navigationTitle("Hi👋")
        }
    }
    
    @ViewBuilder
    private func homeBody() -> some View {
        if entries.isEmpty {
            VStack(alignment: .center) {
                Text("No entries added yet - drink something to start🚰")
                    .multilineTextAlignment(.center)
                    .padding(.all, 24)
            }
        } else {
            List {
                ForEach(getDatesArray().sorted(by: { $0 > $1 }), id: \.self) {
                    date in
                    Section(DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)) {
                        ForEach(entries.filter({ getDateComponents($0.timestamp!) == getDateComponents(date) }).sorted(by: { $0.timestamp! > $1.timestamp! })) {
                            entry in
                            entryContainer(entry)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        viewContext.delete(entry)
                                        do {
                                            try viewContext.save()
                                        } catch {
                                            // TODO: error handling
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
    
    /// Returns an array of unique dates (in terms of days) of the entries array
    private func getDatesArray() -> [Date] {
        let dates : [Date] = entries.map(\.timestamp!)
        var uniques : Set<Date> = Set()
        dates.forEach {
            date in
            if !uniques.contains(where: { getDateComponents($0) == getDateComponents(date) }) {
                uniques.insert(date)
            }
        }
        return Array(uniques)
    }
    
    /// Returns the date components: day, month and year of the given date
    private func getDateComponents(_ date: Date) -> DateComponents {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return comps
    }
    
    /// Builds a single line of the list for a single entry in the list of drink entries
    @ViewBuilder
    private func entryContainer(_ entry : DrinkEntry) -> some View {
        // TODO: Navigation Link or also sheet?
        NavigationLink {
            EntryDetails(entry: entry)
        } label: {
            HStack {
                Text("\(entry.amount) ml")
                Spacer()
                Text(DateFormatter.localizedString(from: entry.timestamp!, dateStyle: .short, timeStyle: .short))
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
