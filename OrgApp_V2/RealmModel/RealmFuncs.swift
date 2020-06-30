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
					if type(of: toDo) == UnDoneToDo.self {
						project.unDoneToDos.append(toDo as! UnDoneToDo)
					}else if type(of: toDo) == DoneToDo.self {
						project.doneToDos.append(toDo as! DoneToDo)
					}
				}
			} catch {
				print("Failed parenting -> \(error)")
			}
		}

		static func setParent(of note: Note, to project: Project) {
			let realm = try! Realm()
			do {
				try realm.write{
					project.notes.append(note)
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


		static func changeToDoDescription(_ toDo: ToDo, description: String) {
			let realm = try! Realm()
			do {
				try realm.write{
					toDo.toDoDescription = description
				}
			} catch {
				print("Failed rename toDo -> \(error)")
			}
		}


		static func switchToDoDone(_ toDo: ToDo, in project: Project) {
			let realm = try! Realm()
			do {
				try realm.write {
					if type(of: toDo) == UnDoneToDo.self {
						let newToDo = DoneToDo()
						newToDo.name = toDo.name
						realm.delete(toDo)

						project.doneToDos.append(newToDo)
//						realm.add(newToDo)
					}else if type(of: toDo) == DoneToDo.self {
						let newToDo = UnDoneToDo()
						newToDo.name = toDo.name
						realm.delete(toDo)

						project.unDoneToDos.append(newToDo)
//						realm.add(newToDo)
					}

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

		static func renameNote(_ note: Note, newName: String) {
			let realm = try! Realm()
			do {
				try realm.write{
					note.name = newName
				}
			} catch {
				print("Failed renameNote -> \(error)")
			}
		}

		static func changeNoteContent(_ note: Note, newContent: String) {
			let realm = try! Realm()
			do {
				try realm.write{
					note.content = newContent
				}
			} catch {
				print("Failed changeNoteContent -> \(error)")
			}
		}

		static func setParent(of photo: Photo, to project: Project) {
			let realm = try! Realm()
			do {
				try realm.write{
					project.photos.append(photo)
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

		static func undDoneToDos(of project: Project) -> List<UnDoneToDo> {
			let realm = try! Realm()
			return realm.object(ofType: Project.self, forPrimaryKey: project.itemId)!.unDoneToDos
		}


		static func doneToDos(of project: Project) -> List<DoneToDo> {
			let realm = try! Realm()
			return realm.object(ofType: Project.self, forPrimaryKey: project.itemId)!.doneToDos
		}

		static func photos(of project: Project) -> List<Photo> {
			let realm = try! Realm()
			return realm.object(ofType: Project.self, forPrimaryKey: project.itemId)!.photos
		}

		static func notes(of project: Project) -> List<Note> {
			let realm = try! Realm()
			return realm.object(ofType: Project.self, forPrimaryKey: project.itemId)!.notes

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

		static func photo(identifier: String) -> Photo {
			let searchPredicate = NSPredicate(format: "photoLocalIdentifier == %@", identifier)
			let realm = try! Realm()
			let tempCat = realm.objects(Photo.self).filter(searchPredicate)
			return tempCat.first!
		}
	}

}
