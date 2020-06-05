import Foundation
import RealmSwift

class Project: Object {
	@objc dynamic var itemId: String = UUID().uuidString
	override static func primaryKey() -> String? {
		return "itemId"
	}
	@objc dynamic var name: String = ""
	var linkedParent = LinkingObjects(fromType: Category.self, property: "projects")
//	let toDos = List<ToDo>()
	let unDoneToDos = List<UnDoneToDo>()
	let doneToDos = List<DoneToDo>()
	let photos = List<Photo>()
	let notes = List<Note>()


}
