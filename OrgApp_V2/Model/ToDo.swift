import Foundation
import RealmSwift

class ToDo: Object {
	@objc dynamic var itemId: String = UUID().uuidString
	override static func primaryKey() -> String? {
		return "itemId"
	}
	
	@objc dynamic var name: String = ""
	@objc dynamic var done: Bool = false
	@objc dynamic var toDoDescription: String = ""
	var linkedParent = LinkingObjects(fromType: Project.self, property: "toDos")

}
