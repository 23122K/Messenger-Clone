//
//  Created by Patryk Maciąg on 18/05/2023.
//

#if canImport(Combine) && swift(>=5.0)
    import Combine
    import FirebaseAuth

    @available(iOS 16.0, *)

    public extension Auth {
        @discardableResult
        func deauthorize() -> Future<Void, Error> {
            Future<Void, Error> { promise in
                switch(Result(catching: self.signOut)) {
                case .success(_):
                    promise(.success(()))
                case.failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }

#endif
