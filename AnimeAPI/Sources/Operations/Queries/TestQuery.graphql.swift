// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class TestQuery: GraphQLQuery {
  public static let operationName: String = "Test"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Test($page: Int, $perPage: Int, $genre: String) { Page(page: $page, perPage: $perPage) { __typename media(genre: $genre) { __typename coverImage { __typename color extraLarge large medium } } } }"#
    ))

  public var page: GraphQLNullable<Int>
  public var perPage: GraphQLNullable<Int>
  public var genre: GraphQLNullable<String>

  public init(
    page: GraphQLNullable<Int>,
    perPage: GraphQLNullable<Int>,
    genre: GraphQLNullable<String>
  ) {
    self.page = page
    self.perPage = perPage
    self.genre = genre
  }

  public var __variables: Variables? { [
    "page": page,
    "perPage": perPage,
    "genre": genre
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
        .field("media", [Medium?]?.self, arguments: ["genre": .variable("genre")]),
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
        ] }

        /// The cover images of the media
        public var coverImage: CoverImage? { __data["coverImage"] }

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
      }
    }
  }
}
