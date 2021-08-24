//
//  Pie.swift
//  Memorize
//
//  Created by Nikita Rossik on 8/24/21.
//

import SwiftUI

struct Pie: Shape {
	var startAngle: Angle
	var endAngle: Angle
	var clockwise = false
	
	func path(in rect: CGRect) -> Path {
		let center = CGPoint(x: rect.midX, y: rect.midY)
		let radius = min(rect.width, rect.height) / 2
		let start = CGPoint(
			x: center.x + radius * CGFloat(cos(startAngle.radians)),
			y: center.y + radius * CGFloat(sin(startAngle.radians))
		)
		
		return Path { path in
			path.move(to: center)
			path.addLine(to: start)
			path.addArc(
				center: center,
				radius: radius,
				startAngle: startAngle,
				endAngle: endAngle,
				clockwise: !clockwise
			)
			path.addLine(to: center)
		}
	}
}
