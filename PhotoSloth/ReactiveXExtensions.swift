//
//  ReactiveXExtensions.swift
//  PhotoSloth
//
//  Created by Adam Rothberg on 4/8/16.
//  Copyright © 2016 StingrayDev. All rights reserved.
//

import RxSwift

extension ObservableType {
    public func filterNil() -> RxSwift.Observable<E> {
        return self.filter{ $0 != nil }
    }
}

