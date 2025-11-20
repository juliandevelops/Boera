//
//  AddIngredientSheet.swift
//  Boera
//
//  Created by Julian Schumacher on 19.05.25.
//

import SwiftUI
import PhotosUI

internal struct AddIngredientSheet: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name : String = ""
    
    @State private var description : String = ""
    
    @State private var addImagePresented : Bool = false
    
    @State private var selectedImage : PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                } header: {
                    Text("Details")
                } footer: {
                    Text("Describe your Ingredient")
                }
                Section {
                    Button {
                        addImagePresented.toggle()
                    } label: {
                        Label("Add image", systemImage: "photo")
                    }
                } header: {
                    Text("Representation")
                } footer: {
                    Text("Add an image to qickly identify your ingredient in the list of all ingredients")
                }
                .photosPicker(isPresented: $addImagePresented, selection: $selectedImage)
            }
            .navigationTitle("New ingredient")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        let ingredient = CD_Ingredient(context: context)
                        ingredient.name = name
                        ingredient.ingredientDescription = description
                        do {
                            try context.save()
                        } catch {
                            // TODO: throw error
                        }
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddIngredientSheet()
}
