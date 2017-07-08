//
//  Resource.swift
//  OnTheMap
//
//  Created by Sujay Bhowmick on 7/1/17.
//  Copyright © 2017 Sujay Bhowmick. All rights reserved.
//

import UIKit
import Foundation

typealias  RequestParams = [String: AnyObject]

struct Resource<A> {
    let url: String
    let parse: (Data) -> A?
}
