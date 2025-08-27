//
//  Home.swift
//  IExpense App
//
//  Created by Mohsin khan on 18/08/2025.
//

import Foundation
import SwiftUI

struct Expenseitem : Identifiable , Codable{
    var id = UUID()
    let name : String
    let type : String
    let amount : Double
}
@Observable
class Expenses {
    var items = [Expenseitem](){
        didSet{
            if let encoded = try?  JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded , forKey: "Items")
            }
        }
    }
    init(){
        if let savedItem = UserDefaults.standard.data(forKey: "Items"){
            if let decodeItem = try? JSONDecoder().decode([Expenseitem].self , from: savedItem){
                items = decodeItem
                return
            }
        }
        items = []
    }
}

struct HomeView : View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    var body: some View {
        NavigationStack{
            List{
                Section("Personal Expenses"){
                    ForEach(expenses.items.filter { $0.type == "personal" }) { item in
                        HStack{
                            VStack(alignment: .leading){
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            
                            if item.amount < 1000 {
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.subheadline)
                                    .italic()
                                    .padding(6)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            } else if item.amount >= 1000 && item.amount < 10000 {
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.headline)
                                    .bold()
                                    .padding(6)
                                    .background(Color.yellow.opacity(0.3))
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                            } else {
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.title3)
                                    .fontWeight(.heavy)
                                    .padding(8)
                                    .background(
                                        LinearGradient(
                                            colors: [.purple, .blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .foregroundStyle(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 4)
                            }
                            
                        }
                    }
                    .onDelete { offsets in
                        removeItem(at: offsets, type: "personal")
                    }
                }
                Section("buisness Expense"){
                    ForEach(expenses.items.filter { $0.type == "business" }) { item in
                        HStack{
                            VStack(alignment: .leading){
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            
                            if item.amount < 1000 {
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.subheadline)
                                    .italic()
                                    .padding(6)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            } else if item.amount >= 1000 && item.amount < 10000 {
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.headline)
                                    .bold()
                                    .padding(6)
                                    .background(Color.yellow.opacity(0.3))
                                    .cornerRadius(8)
                                    .shadow(radius: 2)
                            } else {
                                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.title3)
                                    .fontWeight(.heavy)
                                    .padding(8)
                                    .background(
                                        LinearGradient(
                                            colors: [.purple, .blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .foregroundStyle(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 4)
                            }
                            
                        }
                    }
                    .onDelete { offsets in
                        removeItem(at: offsets, type: "business")
                    }
                }
            }
            .navigationTitle("IExpense")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Expense", systemImage: "plus"){
                        showingAddExpense = true
                    }
                }
                ToolbarItem(placement : .navigationBarLeading){
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddExpense){
                AddView(expenses: expenses)
            }
        }
    }
    func removeItem(at offsets: IndexSet, type: String) {
        let filteredItems = expenses.items.enumerated().filter { $0.element.type == type }
        for offset in offsets {
            let index = filteredItems[offset].offset
            expenses.items.remove(at: index)
        }
        
    }
}
