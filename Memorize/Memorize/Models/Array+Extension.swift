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
