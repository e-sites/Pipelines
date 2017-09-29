//  This file was automatically generated and should not be edited.

import Apollo

/// All the possible states a build can be in
public enum BuildStates: String {
  /// The build was skipped
  case skipped = "SKIPPED"
  /// The build has yet to start running jobs
  case scheduled = "SCHEDULED"
  /// The build is currently running jobs
  case running = "RUNNING"
  /// The build passed
  case passed = "PASSED"
  /// The build failed
  case failed = "FAILED"
  /// The build is currently being canceled
  case canceling = "CANCELING"
  /// The build was canceled
  case canceled = "CANCELED"
  /// The build is blocked
  case blocked = "BLOCKED"
  /// The build wasn't run
  case notRun = "NOT_RUN"
}

extension BuildStates: Apollo.JSONDecodable, Apollo.JSONEncodable {}

public final class LatestBuildsQuery: GraphQLQuery {
  public static let operationString =
    "query LatestBuilds($totalBuilds: Int!) {\n  viewer {\n    __typename\n    user {\n      __typename\n      builds(first: $totalBuilds) {\n        __typename\n        edges {\n          __typename\n          node {\n            __typename\n            id\n            state\n            number\n            branch\n            message\n            url\n            createdAt\n            finishedAt\n            pipeline {\n              __typename\n              name\n            }\n          }\n        }\n      }\n    }\n  }\n}"

  public var totalBuilds: Int

  public init(totalBuilds: Int) {
    self.totalBuilds = totalBuilds
  }

  public var variables: GraphQLMap? {
    return ["totalBuilds": totalBuilds]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("viewer", type: .object(Viewer.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(viewer: Viewer? = nil) {
      self.init(snapshot: ["__typename": "Query", "viewer": viewer.flatMap { $0.snapshot }])
    }

    public var viewer: Viewer? {
      get {
        return (snapshot["viewer"] as! Snapshot?).flatMap { Viewer(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes = ["Viewer"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("user", type: .object(User.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(user: User? = nil) {
        self.init(snapshot: ["__typename": "Viewer", "user": user.flatMap { $0.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The current user
      public var user: User? {
        get {
          return (snapshot["user"] as! Snapshot?).flatMap { User(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "user")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("builds", arguments: ["first": GraphQLVariable("totalBuilds")], type: .object(Build.selections)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(builds: Build? = nil) {
          self.init(snapshot: ["__typename": "User", "builds": builds.flatMap { $0.snapshot }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Returns builds that this user has created.
        public var builds: Build? {
          get {
            return (snapshot["builds"] as! Snapshot?).flatMap { Build(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "builds")
          }
        }

        public struct Build: GraphQLSelectionSet {
          public static let possibleTypes = ["BuildConnection"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("edges", type: .list(.object(Edge.selections))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(edges: [Edge?]? = nil) {
            self.init(snapshot: ["__typename": "BuildConnection", "edges": edges.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var edges: [Edge?]? {
            get {
              return (snapshot["edges"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Edge(snapshot: $0) } } }
            }
            set {
              snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "edges")
            }
          }

          public struct Edge: GraphQLSelectionSet {
            public static let possibleTypes = ["BuildEdge"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("node", type: .object(Node.selections)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(node: Node? = nil) {
              self.init(snapshot: ["__typename": "BuildEdge", "node": node.flatMap { $0.snapshot }])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            public var node: Node? {
              get {
                return (snapshot["node"] as! Snapshot?).flatMap { Node(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "node")
              }
            }

            public struct Node: GraphQLSelectionSet {
              public static let possibleTypes = ["Build"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("state", type: .nonNull(.scalar(BuildStates.self))),
                GraphQLField("number", type: .nonNull(.scalar(Int.self))),
                GraphQLField("branch", type: .nonNull(.scalar(String.self))),
                GraphQLField("message", type: .nonNull(.scalar(String.self))),
                GraphQLField("url", type: .nonNull(.scalar(String.self))),
                GraphQLField("createdAt", type: .scalar(String.self)),
                GraphQLField("finishedAt", type: .scalar(String.self)),
                GraphQLField("pipeline", type: .object(Pipeline.selections)),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(id: GraphQLID, state: BuildStates, number: Int, branch: String, message: String, url: String, createdAt: String? = nil, finishedAt: String? = nil, pipeline: Pipeline? = nil) {
                self.init(snapshot: ["__typename": "Build", "id": id, "state": state, "number": number, "branch": branch, "message": message, "url": url, "createdAt": createdAt, "finishedAt": finishedAt, "pipeline": pipeline.flatMap { $0.snapshot }])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var id: GraphQLID {
                get {
                  return snapshot["id"]! as! GraphQLID
                }
                set {
                  snapshot.updateValue(newValue, forKey: "id")
                }
              }

              /// The current state of the build
              public var state: BuildStates {
                get {
                  return snapshot["state"]! as! BuildStates
                }
                set {
                  snapshot.updateValue(newValue, forKey: "state")
                }
              }

              /// The number of the build
              public var number: Int {
                get {
                  return snapshot["number"]! as! Int
                }
                set {
                  snapshot.updateValue(newValue, forKey: "number")
                }
              }

              /// The branch for the build
              public var branch: String {
                get {
                  return snapshot["branch"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "branch")
                }
              }

              /// The message for the build
              public var message: String {
                get {
                  return snapshot["message"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "message")
                }
              }

              /// The URL for the build
              public var url: String {
                get {
                  return snapshot["url"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "url")
                }
              }

              /// The time when the build was created
              public var createdAt: String? {
                get {
                  return snapshot["createdAt"] as? String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "createdAt")
                }
              }

              /// The time when the build finished
              public var finishedAt: String? {
                get {
                  return snapshot["finishedAt"] as? String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "finishedAt")
                }
              }

              public var pipeline: Pipeline? {
                get {
                  return (snapshot["pipeline"] as! Snapshot?).flatMap { Pipeline(snapshot: $0) }
                }
                set {
                  snapshot.updateValue(newValue?.snapshot, forKey: "pipeline")
                }
              }

              public struct Pipeline: GraphQLSelectionSet {
                public static let possibleTypes = ["Pipeline"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(name: String) {
                  self.init(snapshot: ["__typename": "Pipeline", "name": name])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The name of the pipeline
                public var name: String {
                  get {
                    return snapshot["name"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "name")
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}