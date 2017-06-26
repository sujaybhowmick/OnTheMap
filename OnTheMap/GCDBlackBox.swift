//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Sujay Bhowmick on 6/25/17.
//  Copyright © 2017 Sujay Bhowmick. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
