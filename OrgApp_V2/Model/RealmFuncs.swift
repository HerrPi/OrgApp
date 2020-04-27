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

		static func setParent(of toDo: ToDo, to project: Project) {
			let realm = try! Realm()
			do {
				try realm.write{
					project.toDos.append(toDo)
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
				print("Failed reanme Project -> \(error)")
			}
		}

		static func renameToDo(_ toDo: ToDo, newName: String) {
			let realm = try! Realm()
			do {
				try realm.write{
					toDo.name = newName
				}
			} catch {
				print("Failed rename toDo -> \(error)")
			}
		}

		static func switchToDoDone(_ toDo: ToDo, done: Bool) {
			let realm = try! Realm()
			do {
				try realm.write {
					toDo.done = done
				}
			} catch  {
				print("DoneSwitch failed -> \(error)")
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

		static func undDoneToDos(of project: Project) -> Results<ToDo> {
			let realm = try! Realm()
			return (realm.object(ofType: Project.self, forPrimaryKey: project.itemId)?.toDos.filter(NSPredicate(format: "done == false")))!
//			return realm.objects(ToDo.self).filter(NSPredicate(format: "done == false")).sorted(byKeyPath: "name")
		}


		static func doneToDos(of project: Project) -> Results<ToDo> {
			let realm = try! Realm()
			return (realm.object(ofType: Project.self, forPrimaryKey: project.itemId)?.toDos.filter(NSPredicate(format: "done == true")))!
//			return realm.objects(ToDo.self).filter(NSPredicate(format: "done == true")).sorted(byKeyPath: "name")
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
