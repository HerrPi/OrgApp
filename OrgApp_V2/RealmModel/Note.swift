import Foundation
import RealmSwift

class Note: Object {
	@objc dynamic var itemId: String = UUID().uuidString
	override static func primaryKey() -> String? {
		return "itemId"
	}
	
	@objc dynamic var name: String = ""
	@objc dynamic var content: String = ""
	var linkedParent = LinkingObjects(fromType: Project.self, property: "notes")
}
