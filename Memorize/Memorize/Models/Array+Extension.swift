//
//  Array+Extension.swift
//  Array+Extension
//
//  Created by Nikita Rossik on 9/10/21.
//

extension Array {
	var oneAndOnly: Element? {
		switch count {
			case 1: return first
			default: return nil
		}
	}
}


extension Collection where Element: Identifiable {
	func index(matching element: Element) -> Self.Index? {
		firstIndex(where: { $0.id == element.id })
	}
}
