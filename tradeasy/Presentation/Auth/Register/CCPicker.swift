//
//  CCPicker.swift
//  tradeasy
//
//  Created by abdelkader seif eddine on 14/3/2023.
//
import SwiftUI
import CountryPickerView

struct CountryPickerViewWrapper: UIViewRepresentable {
    @Binding var selectedCountry: Country?

    func makeUIView(context: Context) -> CountryPickerView {
        let countryPickerView = CountryPickerView(frame: .zero)
        countryPickerView.delegate = context.coordinator
        countryPickerView.dataSource = context.coordinator
        countryPickerView.showPhoneCodeInView = false
        countryPickerView.showCountryCodeInView = false
        return countryPickerView
    }

    func updateUIView(_ uiView: CountryPickerView, context: Context) {
        uiView.setCountryByName(selectedCountry?.name ?? "")
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CountryPickerViewDelegate, CountryPickerViewDataSource {
        let parent: CountryPickerViewWrapper

        init(_ parent: CountryPickerViewWrapper) {
            self.parent = parent
        }

        func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
            parent.selectedCountry = country
        }

     
        func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
            "Preferred"
        }

        func sectionTitleForAllCountries(in countryPickerView: CountryPickerView) -> String? {
            "All"
        }
    }
}

