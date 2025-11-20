//
//  AddDrinkSheet.swift
//  Boera
//
//  Created by Julian Schumacher on 14.05.25.
//

import SwiftUI

internal struct AddDrinkSheet: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var ingredients : [Ingredient] = []
    
    @State private var selectedIngredients : [Ingredient] = []
    
    @State private var name : String = ""
    
    @State private var currentlyDisplayedIngredient : Ingredient?
    
    @FetchRequest(sortDescriptors: []) private var customIngredients : FetchedResults<CD_Ingredient>
    
    @State private var ingredientsListPresented : Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.all, 24)
                Spacer()
                HStack {
                    Text("Most used")
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 12)
                    Spacer()
                }
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(ingredients, id: \.name) {
                            ingredient in
                            ingredientsContainer(ingredient)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                Spacer()
                Button {
                    ingredientsListPresented.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .sheet(isPresented: $ingredientsListPresented) {
                    IngredientsListSheet(ingredients: $ingredients)
                }
            }
            .navigationTitle("Create Drink")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        let drink = Drink(context: context)
                        drink.name = name
                        // TODO: enter rest of drink
                        do {
                            try context.save()
                        } catch {
                            // TODO: handle error
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
            .onAppear {
                do {
                    ingredients = try Storage.loadBuildInIngredients()
                } catch {
                    // TODO: catch error
                }
                for customIngredient in customIngredients {
                    ingredients.append(Ingredient(
                        name: customIngredient.name!,
                        description: customIngredient.ingredientDescription,
                        imageBytes: customIngredient.image,
                    ))
                }
            }
        }
    }
    
    @ViewBuilder
    private func ingredientsContainer(_ ingredient : Ingredient) -> some View {
        VStack {
            Text(ingredient.name)
                .font(.headline)
            if ingredient.isCustom() && ingredient.imageBytes != nil {
                Image(uiImage: UIImage(data: ingredient.imageBytes!)!)
            } else {
                Image(ingredient.imageName!)
                    .resizable()
                    .scaledToFit()
                    .padding(12)
            }
            if let desc = ingredient.description {
                Text(desc)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16))
                    .fontWeight(.light)
            }
        }
        .frame(
            width: ingredient == currentlyDisplayedIngredient ? 300 : 200,
            height: ingredient == currentlyDisplayedIngredient ? 500 : 400
        )
        .background(in: .rect(cornerRadius: 20), fillStyle: .init(eoFill: true, antialiased: true))
        .backgroundStyle(.blue)
        .padding(.horizontal, 12)
        .onTapGesture {
            if selectedIngredients.contains(where: { $0 == ingredient }) {
                selectedIngredients.removeAll(where: { $0 == ingredient })
            } else {
                selectedIngredients.append(ingredient)
            }
        }
        .onAppear {
            currentlyDisplayedIngredient = ingredient
        }
    }
}

#Preview {
    AddDrinkSheet()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
