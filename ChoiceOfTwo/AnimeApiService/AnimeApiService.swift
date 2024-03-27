//
//  AnimeApiService.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 14/03/2024.
//

import Foundation
import Apollo
import AnimeAPI


class AnimeApiService {
    
    var mediaSeason: [MediaSeason] = []
    private(set) var apollo = ApolloClient(url: URL(string: "https://graphql.anilist.co")!)

    
    public func fetchAnimeWith(currentPage: Int, genres: [Genre.RawValue], formats: [Format], completion: @escaping ([Anime]?, Error?) -> Void) {
        
        
        apollo.fetch(query: GetAnimeQuery(
            page: GraphQLNullable<Int>(integerLiteral: currentPage),
            perPage: 15,
            genreIn: genres.isEmpty ? .none : genres.count == Genre.allCases.count ? .none : .some(genres),
            sort:  .some([.case(.favouritesDesc)]),
//            formatIn: nil,
            formatIn: formats.isEmpty ? .none : formats.count == Format.allCases.count ? .none : .some(formats.convertToGraphQL()),
            asHtml: true)) { result in
                switch result {
                case .success(let success):
                    let anime = success.data?.page?.media?.compactMap({ $0 }) ?? []
                    var animeList: [Anime] = []
                    anime.forEach { anime in
                        let anime = Anime(
                            coverImage: CoverImage(
                                extraLarge: anime.coverImage?.extraLarge,
                                large: anime.coverImage?.large,
                                medium: anime.coverImage?.medium
                            ),
                            description: anime.description,
                            duration: anime.duration,
                            episodes: anime.episodes,
                            title: anime.title?.userPreferred,
                            startDay: FuzzyDate(
                                day: anime.startDate?.day,
                                month: anime.startDate?.month,
                                year: anime.startDate?.year
                            ),
                            meanScrore: anime.meanScore,
                            genres: anime.genres,
                            format: anime.format?.rawValue,
                            countryOfOrigin: anime.countryOfOrigin,
                            averageScore: anime.averageScore,
                            bannerImage: anime.bannerImage
                        )
                        animeList.append(anime)
                    }
                    completion(animeList, nil)
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
