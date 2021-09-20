//
//  Model.Background.swift
//  Model.Background
//
//  Created by Nikita Rossik on 9/14/21.
//

import Foundation


extension Model {
	enum Background: Equatable {
		case blank
		case url(URL)
		case imageData(Data)
		
		var url: URL? {
			switch self {
				case .url(let url): return url
				default: return nil
			}
		}
		
		var imageData: Data? {
			switch self {
				case .imageData(let data): return data
				default: return nil
			}
		}
		
	}
}
