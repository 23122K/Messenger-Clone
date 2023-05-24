//
//  FirestorageManager.swift
//  Messenger
//
//  Created by Patryk Maciąg on 19/05/2023.
//

import Foundation
import SwiftUI
import Combine
import FirebaseStorage
import Firebase
import FirebaseStorageCombineSwift

class FirebaseStorageManager: ObservableObject {
    private var storage: Storage
    private var cancellables = Set<AnyCancellable>()
    @Published var imageURL: String?
    
    func persistImage(image: UIImage, uid: String) -> AnyPublisher<URL, Error>{
        let referance = storage.reference(withPath: uid)
        return Future<URL, Error> { promise in
            guard let image = image.jpegData(compressionQuality: 0.5) else {
                return
            }
            
            referance.putData(image, metadata: nil){ metadata, error in
                if let error = error {
                    promise(.failure(error))
                }

                referance.downloadURL()
                    .sink(receiveCompletion: { completion in
                        switch(completion) {
                        case .failure(let error):
                            promise(.failure(error))
                        case .finished:
                            print("Finished")
                        }
                    }, receiveValue: { url in
                        print("URL fetched")
                        promise(.success(url))
                        
                    })
                    .store(in: &self.cancellables)
            }
            
        }
        .eraseToAnyPublisher()
        
    }
    init() {
        self.storage = Storage.storage()
    }
}
