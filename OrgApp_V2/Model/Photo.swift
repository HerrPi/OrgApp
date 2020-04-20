import Foundation
import RealmSwift

class Photo: Object {
//	@objc dynamic var image: Image
	@objc dynamic var image: String = ""
	var linkedParent = LinkingObjects(fromType: Project.self, property: "photos")
}
