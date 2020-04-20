import Foundation
import RealmSwift

class Project: Object {
	var linkedParent = LinkingObjects(fromType: Category.self, property: "projects")
	let toDos = List<ToDo>()
	let photos = List<Photo>()
	let notes = List<Note>()


}
