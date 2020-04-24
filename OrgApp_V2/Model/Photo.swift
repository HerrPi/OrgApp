import Foundation
import RealmSwift

class Photo: Object {
	@objc dynamic var itemId: String = UUID().uuidString
	override static func primaryKey() -> String? {
		return "itemId"
	}
	
//	@objc dynamic var image: Image
	@objc dynamic var image: String = ""
	var linkedParent = LinkingObjects(fromType: Project.self, property: "photos")
}
