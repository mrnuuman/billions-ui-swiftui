//
//  ContentViewModel.swift
//  Billions
//
//  Created by Muhammad Nouman on 04/09/2024.
//

import SwiftUI
import Combine
import BillionAPI

class ContentViewModel: ObservableObject {
    @Published var episodes: [Episode] = []
    @Published var tvShow: TVShow?
    @Published var isLoading: Bool = false
    @Published var error: CustomError?

    private var cancellables = Set<AnyCancellable>()
    private var tvShowId = 62852

    init() {
        APIClient.configure(basePath: "https://api.themoviedb.org/3", apiKey: "3d0cda4466f269e793e9283f6ce0b75e")
        fetchTVShow()
        fetchSeasonDetails()
    }
    
    var seasonCount: Int {
        guard let count = tvShow?.seasons?.count else {return 0}
        return count
    }
    
    func episodeTitle(index: Int) -> String {
        let episode = episodes[index]
        return "E\(episode.episodeNumber ?? 1) \(episode.name ?? "")"
    }

    func fetchTVShow() {
        isLoading = true
        APIClient.getTvShowDetails(id: tvShowId) { [weak self] (result: Result<TVShow, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let tvShow):
                    self?.isLoading = false
                    self?.tvShow = tvShow
                case .failure(let error):
                    self?.error?.message = error.localizedDescription
                    self?.isLoading = false
                }
            }
        }
    }
    
    func fetchSeasonDetails(SeasonNum: Int = 1) {
        isLoading = true
        APIClient.getSeasonsDetails(seriesId: tvShowId, SeasonNumber: SeasonNum) { [weak self] (result: Result<Season, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let season):
                    self?.isLoading = false
                    guard let episode = season.episodes else {return}
                    self?.episodes = episode
                case .failure(let error):
                    self?.error?.message = error.localizedDescription
                    self?.isLoading = false
                }
            }
        }
    }
    
    func fetchEpisodeDetail() {
        isLoading = true
        APIClient.getEpisodeDetails(seriesId: tvShowId, SeasonNumber: 1, episode: 1) { [weak self] (result: Result<Episode, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let episode):
                    self?.isLoading = false
                case .failure(let error):
                    self?.error?.message = error.localizedDescription
                    self?.isLoading = false
                }
            }
        }
    }
}

struct CustomError: Identifiable, Error {
    let id = UUID()
    var message: String

    var localizedDescription: String {
        return message
    }
}
