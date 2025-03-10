//
//  CocktailsView.swift
//  CocktailBook
//
//  Created by SOHAM PAUL on 14/12/24.
//

import SwiftUI
import Combine

struct CocktailsView: View {
    @ObservedObject var viewModel: CocktailsViewModel
    @State private var isFavorite: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $viewModel.selectedIndex) {
                    Text("All").tag(CocktailFilter.all)
                    Text("Alcoholic").tag(CocktailFilter.alcoholic)
                    Text("Non-Alcoholic").tag(CocktailFilter.nonAlcoholic)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if viewModel.isLoading {
                    Spacer()
                    ActivityIndicator()
                        .frame(width: 50, height: 50)
                    Spacer()
                    
                } else if let error = viewModel.error {
                    Spacer()
                    VStack {
                        Text("Error: \(error.localizedDescription)")
                            .font(.title)
                        if viewModel.showRetryButton {
                            Button(action: {
                                viewModel.retryFetchCocktails()
                            }) {
                                Text("Retry")
                                    .font(.title)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    Spacer()
                } else {
                    List(viewModel.filteredCocktails) { cocktail in
                        NavigationLink(destination: CocktailDetailView(cocktail: cocktail, navigationTitle: navigationTitle, isFavorite: $isFavorite, onToggleFavorite: {
                            viewModel.toggleFavorite(for: cocktail)
                        })) {
                            CocktailRowView(cocktail: cocktail)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarItems(
                leading: Text(navigationTitle)
                    .font(.title.bold())
            )
            
            .onAppear {
                viewModel.fetchCocktailsResponse()
            }
        }
    }
    
    private var navigationTitle: String {
        switch viewModel.selectedIndex {
        case .all:
            return "All Cocktails"
        case .alcoholic:
            return "Alcoholic Cocktails"
        case .nonAlcoholic:
            return "Non-Alcoholic Cocktails"
        }
    }
}

struct ActivityIndicator: UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .gray
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        uiView.startAnimating()
    }
}
