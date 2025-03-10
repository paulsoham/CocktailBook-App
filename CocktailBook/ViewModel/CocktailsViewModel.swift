//
//  CocktailsViewModel.swift
//  CocktailBook
//
//  Created by SOHAM PAUL on 14/12/24.
//

import Foundation
import Combine
import CocktailsAPI

class CocktailsViewModel: ObservableObject {
    @Published var cocktails: [Cocktail] = []
    @Published var dbCocktails: [CocktailDBEntity] = []
    @Published var filteredCocktails: [Cocktail] = []
    @Published var error: CocktailsAPIError?
    @Published var isLoading: Bool = false
    @Published var retryCount: Int = 0
    @Published var showRetryButton: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let api: CocktailsAPI
    private let coreDataManager = CoreDataManager.shared
    
    @Published var selectedIndex: CocktailFilter = .all {
        didSet {
            filterCocktails(by: selectedIndex)
        }
    }
    
    init(api: CocktailsAPI) {
        self.api = api
        fetchCocktailsResponse()
    }
    
    func fetchCocktailsFromCoreData() {
        if let fetchedCocktails = coreDataManager.fetchAllCocktails() {
            self.dbCocktails = fetchedCocktails
        }
    }
    
    func fetchCocktailsResponse() {
        isLoading = true
        error = nil
        showRetryButton = false
        retryCount = 0
        
        api.cocktailsPublisher
            .decode(type: [Cocktail].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.handleAPIError(error as? CocktailsAPIError)
                    }
                },
                receiveValue: { [weak self] cocktails in
                    guard let self = self else { return }
                    self.fetchCocktailsFromCoreData()
                    self.cocktails = cocktails.map { apiCocktail in
                        var updatedCocktail = apiCocktail
                        if let dbCocktail = self.dbCocktails.first(where: { $0.id == apiCocktail.id }) {
                            updatedCocktail.isFavorite = dbCocktail.isFavorite
                        }
                        return updatedCocktail
                    }
                    self.filterCocktails(by: self.selectedIndex)
                    self.isLoading = false
                }
            )
            .store(in: &cancellables)
    }
    
    func retryFetchCocktails() {
        guard retryCount < 3 else {
            showRetryButton = false
            return
        }
        retryCount += 1
        fetchCocktailsResponse()
    }
    
    func handleAPIError(_ error: CocktailsAPIError?) {
        self.error = error
        self.isLoading = false
        self.showRetryButton = true
    }
    
    func toggleFavorite(for cocktail: Cocktail) {
        if let index = cocktails.firstIndex(where: { $0.id == cocktail.id }) {
            cocktails[index].isFavorite.toggle()
            coreDataManager.updateFavoriteStatus(cocktailId: cocktail.id, isFavorite: cocktails[index].isFavorite)
        }
    }
    
    func filterCocktails(by filter: CocktailFilter) {
        let filteredCocktails = cocktails.filter { cocktail in
            switch filter {
            case .all:
                return true
            case .alcoholic:
                return cocktail.type.lowercased() == "alcoholic"
            case .nonAlcoholic:
                return cocktail.type.lowercased() == "non-alcoholic"
            }
        }
        let favoriteCocktails = filteredCocktails.filter { $0.isFavorite }.sorted { $0.name < $1.name }
        let nonFavoriteCocktails = filteredCocktails.filter { !$0.isFavorite }.sorted { $0.name < $1.name }
        self.filteredCocktails = favoriteCocktails + nonFavoriteCocktails
    }
}
