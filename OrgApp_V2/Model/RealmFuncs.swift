import Foundation
import RealmSwift

struct RealmFuncs {
	struct Save {
		static func object(object: Object) -> Bool {
			let realm = try! Realm()
			do {
				try realm.write {
					realm.add(object)
				}
				return true
			} catch {
				print("Cant Add -> \(error)")
				return false
			}
		}
	}

	struct Edit {
		static func setParent(of project: Project, to category: Category) {
			let realm = try! Realm()
			do {
				try realm.write{
					category.projects.append(project)
				}
			} catch {
				print("Failed parenting -> \(error)")
			}
		}

		static func renameProject(_ project: Project, newName: String) {
			let realm = try! Realm()
			do {
				try realm.write{
					project.name = newName
				}
			} catch {
				print("Failed parenting -> \(error)")
			}
		}

		static func deleteObject(_ object: Object) {
			let realm = try! Realm()
			do {
				try realm.write{
					realm.delete(object)
				}
			} catch {
				print("Failed parenting -> \(error)")
			}
		}
	}

	struct Load {
		static func categorys() -> Results<Category> {
			let realm = try! Realm()
			return realm.objects(Category.self).sorted(byKeyPath: "name")
		}

		static func projects() -> Results<Project> {
			let realm = try! Realm()
			return realm.objects(Project.self).sorted(byKeyPath: "name")
		}

		static func toDos() -> Results<ToDo> {
			let realm = try! Realm()
			return realm.objects(ToDo.self)
		}

		static func photos() -> Results<Photo> {
			let realm = try! Realm()
			return realm.objects(Photo.self)
		}

		static func notes() -> Results<Note> {
			let realm = try! Realm()
			return realm.objects(Note.self)
		}
	}

	struct Search {
		static func categorys(contains: String) -> Results<Category> {
			let searchPredicate = NSPredicate(format: "name CONTAINS[cd] %@", contains)
			let realm = try! Realm()
			return realm.objects(Category.self).filter(searchPredicate)
		}

		static func category(name: String) -> Category {
			let searchPredicate = NSPredicate(format: "name == %@", name)
			let realm = try! Realm()
			let tempCat = realm.objects(Category.self).filter(searchPredicate)
			return tempCat.first!


		}
	}

}
