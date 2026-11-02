//
//  RootView.swift
//  ProductCatalog
//
//  Created by João Murta on 02/11/2026.
//

import SwiftUI

struct RootView: View {

    let dependencies: AppDependencies

    var body: some View {
        #if FORM_ENABLED
        OrderFormView()
        #else
        ProductListView(viewModel: dependencies.makeProductListViewModel())
        #endif
    }
}
