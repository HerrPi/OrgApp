import Foundation
import RealmSwift

class Category: Object {
	@objc dynamic var itemId: String = UUID().uuidString
	override static func primaryKey() -> String? {
		return "itemId"
	}

	@objc dynamic var name: String = ""

	let projects = List<Project>()
}
