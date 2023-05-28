//
//  MenuViewVM.swift
//  browser
//
//  Created by Edgar Borovik on 24/05/2023.
//

import SwiftUI

protocol MenuViewVMProtocol: ObservableObject, AnyObject {
    var history: [String] { get }
}

final class MenuViewVM: MenuViewVMProtocol {
    @AppStorage(Constants.historyItemsKey) private var navigationURLs = ""
    @Published var history = [String]()

    init() {
        history = navigationURLs.components(separatedBy: Constants.historyItemsSeparator)
    }
}
