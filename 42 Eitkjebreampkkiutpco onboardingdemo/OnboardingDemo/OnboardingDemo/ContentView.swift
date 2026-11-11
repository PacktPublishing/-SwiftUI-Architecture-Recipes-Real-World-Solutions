//
//  OnboardingRootView.swift
//  MBAFinancialPlanner
//
//  Created by Mohammad Azam on 6/1/25.
//

import SwiftUI

enum OnboardingStep: Int, CaseIterable, Identifiable {
    case graduation
    case income
    case expenses
    case review
    
    var id: Int { rawValue }
}

struct Onboarding {
    
    var graduation = Graduation()
    var income = Income()
    var expense = Expense()
    
    struct Graduation {
        var graduated: Bool = false
    }
    
    struct Income {
        var total: Double = 0.0
    }
    
    struct Expense {
        var total: Double = 0.0
    }
    
}


struct ReviewScreen: View {
    let onboarding: Onboarding

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Review Your Information")
                .font(.title2)
                .bold()

            Divider()

            Group {
                Text("🎓 Graduated: \(onboarding.graduation.graduated ? "Yes" : "No")")
                Text("💰 Income: \(String(format: "$%.2f", onboarding.income.total))")
                Text("💸 Expenses: \(String(format: "$%.2f", onboarding.expense.total))")
            }
            .font(.headline)

            Spacer()
        }
        .padding()
    }
}

struct GraduationView: View {
    @Binding var graduation: Onboarding.Graduation

    var body: some View {
        Toggle("Graduated?", isOn: $graduation.graduated)
            .padding()
    }
}

struct IncomeView: View {
    @Binding var income: Onboarding.Income

    var body: some View {
        VStack {
            Text("Enter your total income:")
            TextField("Income", value: $income.total, format: .number)
                .keyboardType(.decimalPad)
                .padding()
        }
    }
}

struct ExpensesView: View {
    @Binding var expense: Onboarding.Expense

    var body: some View {
        VStack {
            Text("Enter your total expenses:")
            TextField("Expenses", value: $expense.total, format: .number)
                .keyboardType(.decimalPad)
                .padding()
        }
    }
}

struct OnboardingRootView: View {
    
    @State private var onboarding = Onboarding()
    @State private var currentStepIndex = 0
    
    var steps: [OnboardingStep] {
        OnboardingStep.allCases
    }
    
    var body: some View {
        VStack {
            TabView(selection: $currentStepIndex) {
                ForEach(steps) { step in
                    stepView(for: step)
                        .tag(step.id)
                }
            }.tabViewStyle(.page(indexDisplayMode: .always))
            
            
            Button {
                if currentStepIndex < steps.count - 1 {
                    withAnimation {
                        currentStepIndex += 1
                    }
                }
            } label: {
                Text(currentStepIndex == steps.count - 1 ? "Get started": "Next")
            }
            .buttonStyle(.borderedProminent)
            .padding([.horizontal, .bottom])

            
        }
        .foregroundStyle(.white)
        .background(.blue)
    }
    
    @ViewBuilder
    private func stepView(for step: OnboardingStep) -> some View {
        switch step {
            case .graduation:
                GraduationView(graduation: $onboarding.graduation)
            case .income:
                IncomeView(income: $onboarding.income)
            case .expenses:
                ExpensesView(expense: $onboarding.expense)
            case .review:
                ReviewScreen(onboarding: onboarding)
        }
    }
}


#Preview {
    OnboardingRootView()
}




