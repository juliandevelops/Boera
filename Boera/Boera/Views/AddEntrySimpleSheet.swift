//
//  AddEntrySimpleSheet.swift
//  Boera
//
//  Created by Julian Schumacher on 19.01.26.
//

import CoreData
import SwiftUI

internal struct AddEntrySimpleSheet: View {

    @Environment(\.managedObjectContext) private var context

    @Environment(\.dismiss) private var dismiss

    @State private var amount : String = ""

    @State private var errSavingPresented : Bool = false

    @State private var errDataPresented : Bool = false

    var body: some View {
        NavigationStack {
            Section {
                Text("Enter the amount you drank in ml")
                    .foregroundStyle(.gray)
                HStack {
                    Group {
                        TextField("Amount in ml", text: $amount)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.numberPad)
                        Text("ml")
                    }
                }
                .padding(.vertical, 8)
                HStack {
                    Text("Drink")
                    Spacer()
                    Text("Water")
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 32)
            VStack {
                Text("Currently you can only add water")
                Text("Stay tuned for new drinks comming soon")
            }
            .foregroundStyle(.gray)
            .padding(.horizontal, 32)
            .navigationTitle("Add Entry")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "xmark")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(role: .confirm) {
                        done()
                    } label: {
                        Label("Done", systemImage: "checkmark")
                    }
                }
            }
            .alert("Error saving", isPresented: $errSavingPresented) {
                Button(role: .confirm) {
                    done()
                } label: {
                    Label("Try again", systemImage: "arrow.trianglehead.counterclockwise")
                }
            } message: {
                Text("There's been an error while trying to save your data, please try again")
            }
            .alert("Data error", isPresented: $errDataPresented) {
            } message: {
                Text("Your entered amount is invalid. Please enter a valid value greater than 0 and smaller than \(Int16.max)")
            }
        }
    }

    private func done() {
        guard let amountInt = Int(amount) else {
            return
        }
        guard amountInt > 0 && amountInt < Int16.max else {
            errDataPresented.toggle()
            return
        }
        let entry = DrinkEntry(context: context)
        entry.amount = Int16(amountInt)
        entry.timestamp = Date.now
        do {
            try context.save()
        } catch {
            errSavingPresented.toggle()
            return
        }
        dismiss()
    }
}

#Preview {
    AddEntrySimpleSheet()
}
