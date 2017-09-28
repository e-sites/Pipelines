//
//  APIClient.swift
//  Pipelines
//
//  Created by Bas van Kuijck on 28/09/2017.
//  Copyright © 2017 E-sites. All rights reserved.
//

import Foundation
import Apollo

class GraphQLClient {
    private(set) var isFetching = false
    
    private let apollo: ApolloClient = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Authorization": "Bearer \(Constants.token)"
        ]

        let url = URL(string: "https://graphql.buildkite.com/v1")!
        return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
    }()

    func getLatestBuilds(completion: @escaping ([LatestBuildsQuery.Data.Viewer.User.Build.Edge.Node]?) -> Void) {
        if isFetching {
            completion(nil)
            return
        }
        isFetching = true
        let query = LatestBuildsQuery(totalBuilds: Constants.totalBuilds)
        apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { [weak self] (result, error) in
            self?.isFetching = false
            guard let data = result?.data else {
                completion(nil)
                return
            }
            guard let builds = data.viewer?.user?.builds?.edges else {
                completion(nil)
                return
            }
            let nodes = builds.flatMap { $0?.node }
            completion(nodes)
        }
    }
}
