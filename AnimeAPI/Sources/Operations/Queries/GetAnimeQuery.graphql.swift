// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetAnimeQuery: GraphQLQuery {
  public static let operationName: String = "getAnime"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query getAnime($page: Int, $perPage: Int, $genreIn: [String], $sort: [MediaSort], $formatIn: [MediaFormat], $asHtml: Boolean) { Page(page: $page, perPage: $perPage) { __typename media(genre_in: $genreIn, sort: $sort, format_in: $formatIn) { __typename coverImage { __typename color extraLarge large medium } description(asHtml: $asHtml) duration episodes startDate { __typename month day year } title { __typename userPreferred } meanScore genres format countryOfOrigin averageScore bannerImage } } }"#
    ))

  public var page: GraphQLNullable<Int>
  public var perPage: GraphQLNullable<Int>
  public var genreIn: GraphQLNullable<[String?]>
  public var sort: GraphQLNullable<[GraphQLEnum<MediaSort>?]>
  public var formatIn: GraphQLNullable<[GraphQLEnum<MediaFormat>?]>
  public var asHtml: GraphQLNullable<Bool>

  public init(
    page: GraphQLNullable<Int>,
    perPage: GraphQLNullable<Int>,
    genreIn: GraphQLNullable<[String?]>,
    sort: GraphQLNullable<[GraphQLEnum<MediaSort>?]>,
    formatIn: GraphQLNullable<[GraphQLEnum<MediaFormat>?]>,
    asHtml: GraphQLNullable<Bool>
  ) {
    self.page = page
    self.perPage = perPage
    self.genreIn = genreIn
    self.sort = sort
    self.formatIn = formatIn
    self.asHtml = asHtml
  }

  public var __variables: Variables? { [
    "page": page,
    "perPage": perPage,
    "genreIn": genreIn,
    "sort": sort,
    "formatIn": formatIn,
    "asHtml": asHtml
  ] }

  public struct Data: AnimeAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { AnimeAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("Page", Page?.self, arguments: [
        "page": .variable("page"),
        "perPage": .variable("perPage")
      ]),
    ] }

    public var page: Page? { __data["Page"] }

    /// Page
    ///
    /// Parent Type: `Page`
    public struct Page: AnimeAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { AnimeAPI.Objects.Page }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("media", [Medium?]?.self, arguments: [
          "genre_in": .variable("genreIn"),
          "sort": .variable("sort"),
          "format_in": .variable("formatIn")
        ]),
      ] }

      public var media: [Medium?]? { __data["media"] }

      /// Page.Medium
      ///
      /// Parent Type: `Media`
      public struct Medium: AnimeAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { AnimeAPI.Objects.Media }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("coverImage", CoverImage?.self),
          .field("description", String?.self, arguments: ["asHtml": .variable("asHtml")]),
          .field("duration", Int?.self),
          .field("episodes", Int?.self),
          .field("startDate", StartDate?.self),
          .field("title", Title?.self),
          .field("meanScore", Int?.self),
          .field("genres", [String?]?.self),
          .field("format", GraphQLEnum<AnimeAPI.MediaFormat>?.self),
          .field("countryOfOrigin", AnimeAPI.CountryCode?.self),
          .field("averageScore", Int?.self),
          .field("bannerImage", String?.self),
        ] }

        /// The cover images of the media
        public var coverImage: CoverImage? { __data["coverImage"] }
        /// Short description of the media's story and characters
        public var description: String? { __data["description"] }
        /// The general length of each anime episode in minutes
        public var duration: Int? { __data["duration"] }
        /// The amount of episodes the anime has when complete
        public var episodes: Int? { __data["episodes"] }
        /// The first official release date of the media
        public var startDate: StartDate? { __data["startDate"] }
        /// The official titles of the media in various languages
        public var title: Title? { __data["title"] }
        /// Mean score of all the user's scores of the media
        public var meanScore: Int? { __data["meanScore"] }
        /// The genres of the media
        public var genres: [String?]? { __data["genres"] }
        /// The format the media was released in
        public var format: GraphQLEnum<AnimeAPI.MediaFormat>? { __data["format"] }
        /// Where the media was created. (ISO 3166-1 alpha-2)
        public var countryOfOrigin: AnimeAPI.CountryCode? { __data["countryOfOrigin"] }
        /// A weighted average score of all the user's scores of the media
        public var averageScore: Int? { __data["averageScore"] }
        /// The banner image of the media
        public var bannerImage: String? { __data["bannerImage"] }

        /// Page.Medium.CoverImage
        ///
        /// Parent Type: `MediaCoverImage`
        public struct CoverImage: AnimeAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { AnimeAPI.Objects.MediaCoverImage }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("color", String?.self),
            .field("extraLarge", String?.self),
            .field("large", String?.self),
            .field("medium", String?.self),
          ] }

          /// Average #hex color of cover image
          public var color: String? { __data["color"] }
          /// The cover image url of the media at its largest size. If this size isn't available, large will be provided instead.
          public var extraLarge: String? { __data["extraLarge"] }
          /// The cover image url of the media at a large size
          public var large: String? { __data["large"] }
          /// The cover image url of the media at medium size
          public var medium: String? { __data["medium"] }
        }

        /// Page.Medium.StartDate
        ///
        /// Parent Type: `FuzzyDate`
        public struct StartDate: AnimeAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { AnimeAPI.Objects.FuzzyDate }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("month", Int?.self),
            .field("day", Int?.self),
            .field("year", Int?.self),
          ] }

          /// Numeric Month (3)
          public var month: Int? { __data["month"] }
          /// Numeric Day (24)
          public var day: Int? { __data["day"] }
          /// Numeric Year (2017)
          public var year: Int? { __data["year"] }
        }

        /// Page.Medium.Title
        ///
        /// Parent Type: `MediaTitle`
        public struct Title: AnimeAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { AnimeAPI.Objects.MediaTitle }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("userPreferred", String?.self),
          ] }

          /// The currently authenticated users preferred title language. Default romaji for non-authenticated
          public var userPreferred: String? { __data["userPreferred"] }
        }
      }
    }
  }
}
