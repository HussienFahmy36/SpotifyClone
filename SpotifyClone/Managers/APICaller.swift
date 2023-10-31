//
//  APICaller.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import Foundation

class APICaller {
    static let shared = APICaller()
    private init() {}
    
    struct Constants {
        static let base_API_Url = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    public func getAlbumDetails(for album: Album, fromMocks: Bool = false, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        if fromMocks {
            do {
                let data = try Data(contentsOf: Bundle.main.url(forResource: "AlbumDetails", withExtension: "json")!)
                let result = self.jsonDecode(data: data, to: AlbumDetailsResponse.self)
                completion(result)
            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        } else {
            createRequest(
                with: URL(string: Constants.base_API_Url + "/albums/\(album.id)"),
                type: .GET
            ) { request in
                let task = URLSession.shared.dataTask(with: request) {[unowned self] data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    let result = self.jsonDecode(data: data, to: AlbumDetailsResponse.self)
                    completion(result)
                }
                task.resume()
            }
        }
    }
    
    public func getPlaylistDetails(for playlist: Playlist, fromMocks: Bool = false, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        if fromMocks {
            do {
                let data = try Data(contentsOf: Bundle.main.url(forResource: "PlaylistDetails", withExtension: "json")!)
                let result = self.jsonDecode(data: data, to: PlaylistDetailsResponse.self)
                completion(result)
            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        } else {
            createRequest(
                with: URL(string: Constants.base_API_Url + "/playlists/\(playlist.id)"),
                type: .GET
            ) { request in
                let task = URLSession.shared.dataTask(with: request) {[unowned self] data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    let result = self.jsonDecode(data: data, to: PlaylistDetailsResponse.self)
                    completion(result)
                }
                task.resume()
            }
        }
    }
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.base_API_Url + "/me"),
            type: .GET
        ) { request in
            let task = URLSession.shared.dataTask(with: request) {[unowned self] data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                let result = self.jsonDecode(data: data, to: UserProfile.self)
                completion(result)
            }
            task.resume()
        }
    }
    
    // MARK: - private
    enum HTTPMethod: String {
        case GET
        case POST
        
    }

    public func getNewReleases(fromMocks: Bool = false, completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void) {
        if fromMocks {
            do {
                let data = try Data(contentsOf: Bundle.main.url(forResource: "NewReleases", withExtension: "json")!)
                let result = self.jsonDecode(data: data, to: NewReleasesResponse.self)
                completion(result)
            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        } else {
            createRequest(with: URL(string: Constants.base_API_Url + "/browse/new-releases?limit=50"), type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) {[unowned self] data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    
                    let result = self.jsonDecode(data: data, to: NewReleasesResponse.self)
                    completion(result)
                    
                }
                
                task.resume()
            }
        }
    }
    
    public func getFeaturedPlaylists(fromMocks: Bool = false, completion: @escaping(Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        if fromMocks {
            do {
                let data = try Data(contentsOf: Bundle.main.url(forResource: "FeaturedPlaylists", withExtension: "json")!)
                let result = self.jsonDecode(data: data, to: FeaturedPlaylistsResponse.self)
                completion(result)
            } catch {
                completion(.failure(APIError.failedToGetData))
            }

        } else {
            createRequest(
                with: URL(string: Constants.base_API_Url + "/browse/featured-playlists"),
                type: .GET) { request in
                    let task = URLSession.shared.dataTask(with: request) {[unowned self] data, _, error in
                        guard let data = data, error == nil else {
                            completion(.failure(APIError.failedToGetData))
                            return
                        }
                        
                        let result = self.jsonDecode(data: data, to: FeaturedPlaylistsResponse.self)
                        completion(result)
                        
                    }
                    
                    task.resume()
                }
        }
    }
    
    public func getRecommendation(fromMocks: Bool = false, genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void)) {
        if fromMocks {
            do {
                let data = try Data(contentsOf: Bundle.main.url(forResource: "Recommendations", withExtension: "json")!)
                let result = self.jsonDecode(data: data, to: RecommendationsResponse.self)
                completion(result)
                
            } catch {
                completion(.failure(APIError.failedToGetData))
                return
                
            }
        } else {
            let seeds = genres.joined(separator: ",")
            createRequest(
                with: URL(string: Constants.base_API_Url + "/recommendations?&seed_genres=\(seeds)"),
                type: .GET)
            {request in
                let task = URLSession.shared.dataTask(with: request) {[unowned self] data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    let result = self.jsonDecode(data: data, to: RecommendationsResponse.self)
                    completion(result)
                }
                task.resume()
                
            }
        }
    }
    
    public func getRecommendedGenres(fromMocks: Bool = false, completion: @escaping ((Result<RecommendedGenresResponse, Error>) -> Void)) {
        if fromMocks {
            if fromMocks {
                do {
                    let data = try Data(contentsOf: Bundle.main.url(forResource: "Genres", withExtension: "json")!)
                    let result = self.jsonDecode(data: data, to: RecommendedGenresResponse.self)
                    completion(result)
                    
                } catch {
                    completion(.failure(APIError.failedToGetData))
                    return
                    
                }
            }
        } else {
            createRequest(
                with: URL(string: Constants.base_API_Url + "/recommendations/available-genre-seeds"),
                type: .GET)
            { request in
                let task = URLSession.shared.dataTask(with: request) {[unowned self] data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    let result = self.jsonDecode(data: data, to: RecommendedGenresResponse.self)
                    completion(result)
                }
                
                task.resume()

            }
        }
    }
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.base_API_Url + "/browse/categories?limit=50" ),
            type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) {[unowned self] data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    let result = self.jsonDecode(data: data, to: AllCategoriesResponse.self)
                    
                    switch result {
                    case .success(let model):
                        completion(.success(model.categories.items))
                    case .failure(_):
                        completion(.failure(APIError.failedToGetData))
                    }
                    
                }
                
                task.resume()
                
            }
    }
    
    public func getCategoryPlaylists(categoryId: String, completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.base_API_Url + "/browse/categories/\(categoryId)/playlists/?limit=50" ),
            type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) {[unowned self] data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    let result = self.jsonDecode(data: data, to: FeaturedPlaylistsResponse.self)
                    switch result {
                    case .success(let response):
                        completion(.success(response.playlists.items))
                    case .failure(_):
                        completion(.failure(APIError.failedToGetData))
                    }

                }
                task.resume()
            }
    }
    
    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        let queryURLAsString = Constants.base_API_Url + "/search?limit=10&type=album,artist,playlist,track&q=\(String(describing: query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
        createRequest(
            with: URL(string: queryURLAsString),
            type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data , _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    let result = self.jsonDecode(data: data, to: SearchResultsResponse.self)
                    switch result {
                    case .success(let response):
                        var searchResults: [SearchResult] = []
                        searchResults.append(contentsOf: response.albums.items.map { SearchResult.album(album: $0)})
                        searchResults.append(contentsOf: response.tracks.items.map { SearchResult.track(audioTrack: $0)})
                        searchResults.append(contentsOf: response.playlists.items.map { SearchResult.playlist(playlist: $0)})
                        searchResults.append(contentsOf: response.artists.items.map { SearchResult.artist(artist: $0)})
                        completion(.success(searchResults))
                    case .failure(let error):
                        completion(.failure(error))
                    }

                }
                task.resume()
            }
    }
    
    private func jsonDecode<T: Decodable>(data: Data, to objectType: T.Type) -> Result<T, Error> {
        do {
            let result = try JSONDecoder().decode(objectType, from: data)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    private func createRequest(with url: URL?,
                               type: HTTPMethod,
                               completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let url else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            completion(request)
        }
    }

    
}
