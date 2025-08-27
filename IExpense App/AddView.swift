//
//  AddView.swift
//  IExpense App
//
//  Created by Mohsin khan on 15/08/2025.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var type = "personal"
    @State private var amount = 0.0
    let types = ["personal", "business"]
    
    var expenses = Expenses()
    
    var body: some View {
        NavigationStack{
            Form{
                TextField("Enter expense name" , text: $name)
                Picker("Select type" , selection: $type){
                    ForEach(types , id: \.self){
                        Text($0)
                    }
                }
                TextField("Enter Amount" , value: $amount , format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new Expense")
            .toolbar{
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel"){
                        dismiss()
                    }
                    .foregroundStyle(.red)
                }
                ToolbarItem(placement: .confirmationAction){
                    Button("Save"){
                        let item =  Expenseitem(name: name, type: type, amount: amount)
                        expenses.items.append(item)
                        dismiss()
                    }
                    .disabled(name.isEmpty || amount <= 0 || type.isEmpty)
                }
               
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
