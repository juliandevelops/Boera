//
//  IngredientsListSheet.swift
//  Boera
//
//  Created by Julian Schumacher on 20.05.25.
//

import SwiftUI

internal struct IngredientsListSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding internal var ingredients : [Ingredient]
    
    @State private var searchResults : [Ingredient] = []
    
    @State private var searchInput : String = ""
    
    var body: some View {
        NavigationStack {
            TextField("Search", text: $searchInput)
                .textFieldStyle(.roundedBorder)
                .padding(.all, 16)
                .onChange(of: searchInput) { search() }
            List(searchResults, id: \.name) {
                ingredient in
                HStack {
                    Text(ingredient.name)
                    Spacer()
                    if ingredient.isCustom() {
                        Image(uiImage: UIImage(data: ingredient.imageBytes!)!)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(ingredient.imageName!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .onAppear {
                searchResults = ingredients
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func search() -> Void {
        guard !searchInput.isEmpty else {
            searchResults = ingredients
            return
        }
        searchResults = ingredients
            .filter({ $0.name.contains(searchInput) || $0.description != nil && $0.description!.contains(searchInput) })
        print("Searched")
        print("Results: \(searchResults)")
        print("All ingredients: \(ingredients)")
    }
}

#Preview {
    IngredientsListSheet(ingredients: .constant([]))
}
