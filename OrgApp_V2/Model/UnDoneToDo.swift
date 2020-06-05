import Foundation
import RealmSwift

class UnDoneToDo: ToDo {
	@objc dynamic var itemId: String = UUID().uuidString
	override static func primaryKey() -> String? {
		return "itemId"
	}
	var linkedParent = LinkingObjects(fromType: Project.self, property: "unDoneToDos")

}
