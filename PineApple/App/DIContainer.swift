
//
//  DIContainer.swift
//  PineApple
//
//  Created by seongjun cho on 8/4/25.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()

    private var services: [String: Any] = [:]

    // 타입명과 객체를 딕셔너리에 등록
    func register<T>(_ service: T) {
        let key = String(describing: T.self)

        services[key] = service
    }

    // 저장된 객체를 타입명으로 불러오기
    func resolve<T>() -> T {
        let key = String(describing: T.self)

        guard let service = services[key] as? T else {
            fatalError("DIContainer error")
        }

        return service
    }
}
