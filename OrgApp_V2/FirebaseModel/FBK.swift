//
//  FBK.swift
//  OrgApp_V2
//
//  Created by Jan Manuel Brenner on 25.06.20.
//  Copyright © 2020 Jan Manuel Brenner. All rights reserved.
//

import Foundation
import Firebase


struct FBK {
	struct Categorys {
		//MARK: -  CATEGORYS
		static func createNewCategory(named name: String) -> String{
			let dataBase = Database.database().reference().child(S.categorys).childByAutoId()
			dataBase.child(S.name).setValue(name)
			return dataBase.key!

		}

		static func deleteCategory(withID catID: String) {
			let dataBase = Database.database().reference().child(S.categorys)
			dataBase.child(catID).setValue(nil)
		}

		static func loadAllCategorysAndProjects(projectsVC: ProjectsVC, loadingDispatcher: DispatchGroup) {
			let catRef = Database.database().reference().child(S.categorys)
			var allCats: [FBCategory] = []


			// Hole alle Categorys vom Server
			catRef.observeSingleEvent(of: .value) { (categoryList) in

				// Loope durch jede einzelne Category
				for categoryEnum in categoryList.children {
					let onlineCategory = categoryEnum as! DataSnapshot

					// erstelle eine neue Category
					let newCat = FBCategory(uID: onlineCategory.key, name: onlineCategory.childSnapshot(forPath: S.name).value as! String)

					// Loope nun durch alle Online-Projecte der Category auf dem Server
					for projectEnum in	onlineCategory.childSnapshot(forPath: S.projects).children {
						let onlineProject = projectEnum as! DataSnapshot
						print("\(onlineProject.key)")

						// hänge das neue project an das Array in der neuen Category
						newCat.projects.append(FBProject(uID: onlineProject.key, name: onlineProject.value as! String, parentCategoryUID: newCat.uID))
					}

					// Hänge an das allCatsArray die einzelne Category welche alle nötigen PRojecte enthält
					allCats.append(newCat)


					// For-Loop fertig, starte wieder mit nächster Category
				}

				// setze nun im ViewController die allCategorys ein
				projectsVC.allCategorys = allCats

				// und verlasse den loadingDispatcher um im ViewController das UI zu laden
				loadingDispatcher.leave()
			}
		}


		//MARK: -  CATEGORY OBSERVERS
		static func childAddedObserver(projectsVC: ProjectsVC) {
			let catRef = Database.database().reference().child(S.categorys)
			catRef.observe(.childAdded) { (addedCategory) in
				// Wenn die Category noch nicht Local vorhanden ist füge sie hinzu
				if !projectsVC.allCategorys.contains(where: { (localCat) -> Bool in
					return localCat.uID == addedCategory.key
				}) {
					projectsVC.allCategorys.append(FBCategory(uID: addedCategory.key, name: addedCategory.childSnapshot(forPath: S.name).value as! String))
				}

				projectsVC.projectsCollectionView.reloadData()

			}

		}

		static func childChangedObserver() {

		}

		static func childRemovedObserver(projectsVC: ProjectsVC) {
			let catRef = Database.database().reference().child(S.categorys)
			catRef.observe(.childRemoved) { (deletedCategory) in

				// Lösche die Locale Category wenn vorhanden
				projectsVC.allCategorys.removeAll(where: { (localCategory) -> Bool in
					return localCategory.uID == deletedCategory.key
				})
				projectsVC.projectsCollectionView.reloadData()
			}

		}
	}

	struct Projects {
		//MARK: -  PROJECTS
		static func createNewProject(named name: String, in category: FBCategory) {
			let projectUID = Database.database().reference().child("\(S.categorys)/\(category.uID)/\(S.projects)").childByAutoId()
			projectUID.setValue(name)

			let projectsRef = Database.database().reference().child(S.projects)
			projectsRef.child(projectUID.key!).updateChildValues([S.name: name, S.parentCategory: category.uID])
		}

		static func renameProject(withID: String, to newName: String) {
			let dataBase = Database.database().reference()
			dataBase.child("\(S.projects)/\(withID)/\(S.name)").setValue(newName)
		}

		static func deleteProject(project: FBProject) {
			let dataBase = Database.database().reference()

			// LÖösche alle ToDos
			dataBase.child("\(S.projects)/\(project.uID)/\(S.toDos)").observeSingleEvent(of: .value) { (toDoList) in
				for toDoEnum in toDoList.children {
					let toDo = toDoEnum as! DataSnapshot
					FBK.ToDos.deleteToDo(with: toDo.key, in: project.uID)
				}


			}

			// Lösche alle Notes
			dataBase.child("\(S.projects)/\(project.uID)/\(S.notes)").observeSingleEvent(of: .value) { (noteList) in
				for noteEnum in noteList.children {
					let note = noteEnum as! DataSnapshot
					FBK.Notes.deleteNote(with: note.key, in: project.uID)
				}
			}


			dataBase.child("\(S.projects)/\(project.uID)").setValue(nil)
			dataBase.child("\(S.categorys)/\(project.parentCategoryUID)/\(S.projects)/\(project.uID)").setValue(nil)

		}


		//MARK: -  PROJECT OBSERVERS

		static func childAddedObserver(projectsVC: ProjectsVC) {
			let projectsRef = Database.database().reference().child(S.projects)

			projectsRef.observe(.childAdded) { (addedProject) in

				// Hole die Category in der sich das Project befindet und speicher es als parentCategory
				if let parentCategory = projectsVC.allCategorys.first(where: { (localCategory) -> Bool in
					return localCategory.uID == (addedProject.childSnapshot(forPath: S.parentCategory).value as! String)
				}) {

					// Dann überprüfe ob das PRoject schon in den Projekten der Category existiert
					if !parentCategory.projects.contains(where: { (localProject) -> Bool in
						return localProject.uID == addedProject.key
					}) {

						// Wenn nicht, füge es hinzu
						parentCategory.projects.append(FBProject(uID: addedProject.key, name: addedProject.childSnapshot(forPath: S.name).value as! String, parentCategoryUID: addedProject.childSnapshot(forPath: S.parentCategory).value as! String))
						projectsVC.projectsCollectionView.reloadData()
					}
				}
			}
		}

		static func childChangedObserver(projectsVC: ProjectsVC) {

		}

		static func childRemovedObserver(projectsVC: ProjectsVC) {
			let projectRef = Database.database().reference().child(S.projects)
			projectRef.observe(.childRemoved) { (deletedProject) in

				// Hole die Category in der sich das Project befindet und speicher es als parentCategory
				if let parentCategory = projectsVC.allCategorys.first(where: { (localCategory) -> Bool in
					return localCategory.uID == (deletedProject.childSnapshot(forPath: S.parentCategory).value as! String)
				}) {

					// Dann lösche alle Projekte (sollte nur eins sein) mit der UID aus dieser Category
					parentCategory.projects.removeAll(where: { (localProject) -> Bool in
						return localProject.uID == deletedProject.key
					})
					projectsVC.projectsCollectionView.reloadData()

				}
			}

		}


	}

	struct ToDos {
		//MARK: -  TODOS
		static func createNewToDo(in projectID: String, unDoneToDosCountPlusOne nextPriority: Int){
			let dataBase = Database.database().reference()
			let projectToDoUID = dataBase.child("\(S.projects)/\(projectID)/\(S.toDos)").childByAutoId()
			projectToDoUID.setValue("Undone #\(nextPriority)", andPriority: nextPriority)
			
			
			let newToDoDict: [String: Any] = [S.name: "", S.toDoDescription: "", S.parentProject: projectID, S.done: false]
			dataBase.child("\(S.toDos)/\(projectToDoUID.key!)").updateChildValues(newToDoDict)
		}
		
		
		static func deleteToDo(with UID: String, in projectID: String) {
			let projectToDoRef = Database.database().reference().child("\(S.projects)/\(projectID)/\(S.toDos)/\(UID)")
			let toDoRef = Database.database().reference().child(S.toDos)
			projectToDoRef.removeValue()
			toDoRef.child(UID).removeValue()
			
		}

		//MARK: -  ToDo Single Time Loading
		static func loadAlltoDosSingleTime(of thisProject: DatabaseReference, dispatcher: DispatchGroup, toDoVC: ToDosVC) {
			var allToDoUIDs: [String] = []
			thisProject.child(S.toDos).observeSingleEvent(of: .value) { (toDoList) in
				for toDoEnum in toDoList.children {
					let toDo = toDoEnum as! DataSnapshot
					allToDoUIDs.append(toDo.key)
				}
				FBK.ToDos.loadToDos(of: allToDoUIDs, dispatcher: dispatcher, toDoVC: toDoVC)
			}
		}

		static func loadToDos(of allToDoUIDs: [String], dispatcher: DispatchGroup, toDoVC: ToDosVC) {
			let	toDosDataBase = Database.database().reference().child(S.toDos)
			var unDoneToDos: [FBToDo] = []
			var doneToDos: [FBToDo] = []
			let secondGroup = DispatchGroup()

			for toDo in allToDoUIDs {
				secondGroup.enter()
				toDosDataBase.child(toDo).observeSingleEvent(of: .value) { (onlineToDo) in
					if (onlineToDo.childSnapshot(forPath: S.done).value as! Bool) == false {
						unDoneToDos.append(FBToDo(uID: toDo, data: onlineToDo.value as? [String: AnyObject] ?? [:]))
					}else {
						doneToDos.append(FBToDo(uID: toDo, data: onlineToDo.value as? [String: AnyObject] ?? [:]))
					}
					secondGroup.leave()

				}
			}

			secondGroup.notify(queue: .main) {
				toDoVC.unDoneToDos = unDoneToDos
				toDoVC.doneToDos = doneToDos
				toDoVC.allToDoUIDs = allToDoUIDs
				dispatcher.leave()
			}


		}

		//MARK: -  ToDo Observers
		static func childAddedObserver(allToDoUIDs: [String], toDoVC: ToDosVC, thisProject: DatabaseReference) {
			let toDoRef = Database.database().reference().child(S.toDos)
			toDoRef.observe(.childAdded) { (addedToDo) in
				if !allToDoUIDs.contains(where: { (toDo) -> Bool in // IF DONETODOS DOESNT CONTAIN THE ADDED TODO
					return addedToDo.key == toDo
				}) { // THEN ADD THE TODO
					if toDoVC.creationProcess {
						toDoVC.creationProcess = false
						toDoVC.unDoneToDos.append(FBToDo(uID: addedToDo.key, data: addedToDo.value as? [String: AnyObject] ?? [:]))
						toDoVC.toDosTableView.insertRows(at: [IndexPath(row: toDoVC.toDosTableView.numberOfRows(inSection: 0), section: 0)] , with: .left)
						(toDoVC.toDosTableView.cellForRow(at: IndexPath(row: toDoVC.toDosTableView.numberOfRows(inSection: 0) - 1, section: 0)) as! ToDoTCC).toDoTitle.becomeFirstResponder()
					}
				}
			}
		}


		static func childRemovedObserver(toDoVC: ToDosVC) {
			let toDoRef = Database.database().reference().child(S.toDos)
			toDoRef.observe(.childRemoved) { (removedChild) in
				if (removedChild.childSnapshot(forPath: S.done).value as! Bool) {
					if let toDoIndex = toDoVC.doneToDos.firstIndex(where: { (toDo) -> Bool in
						return toDo.uID == removedChild.key
					}) {
						toDoVC.doneToDos.remove(at: toDoIndex)
						toDoVC.toDosTableView.deleteRows(at: [IndexPath(row: toDoIndex, section: 1)], with: .bottom)
					}
				}else {
					if let toDoIndex = toDoVC.unDoneToDos.firstIndex(where: { (toDo) -> Bool in
						return toDo.uID == removedChild.key
					}) {
						toDoVC.unDoneToDos.remove(at: toDoIndex)
						toDoVC.toDosTableView.deleteRows(at: [IndexPath(row: toDoIndex, section: 0)], with: .bottom)
					}
				}
			}
		}

		static func toDoChangedObserver(toDoVC: ToDosVC) {
			let toDosRef = Database.database().reference().child(S.toDos)
			toDosRef.observe(.childChanged) { (toDoSnap) in
				// VARIABLES
				let onlineToDo = FBToDo(uID: toDoSnap.key, data: toDoSnap.value as? [String: AnyObject] ?? [:])
				let allToDos: [FBToDo] = toDoVC.unDoneToDos + toDoVC.doneToDos


				// GET CHANGED TO DO
				if let changedToDo = allToDos.first(where: { (toDo) -> Bool in
					return toDo.uID == onlineToDo.uID
				}) {
					// CHECK IF NAME IS SAME
					if changedToDo.name == onlineToDo.name {
						if changedToDo.done == onlineToDo.done {
							toDoVC.toDosTableView.reloadData()
						}else {
							// IF YES - Change DoneState
							if onlineToDo.done {

								// IF THE TODO IS DONE GET INDEX OF LOCAL UNDONETODOS
								if let changeAtIndex = toDoVC.unDoneToDos.firstIndex(where: { (toDo) -> Bool in
									return toDo.uID == onlineToDo.uID
								}) {
									toDoVC.unDoneToDos[changeAtIndex].done = onlineToDo.done
									toDoVC.doneToDos.append(toDoVC.unDoneToDos[changeAtIndex])
									toDoVC.unDoneToDos.remove(at: changeAtIndex)
								}
							}else {

								// THE TODO IS UNDONE SO GET THE INDEX OF LOCAL DONETODOS
								if let changeAtIndex = toDoVC.doneToDos.firstIndex(where: { (toDo) -> Bool in
									return toDo.uID == onlineToDo.uID
								}) {
									toDoVC.doneToDos[changeAtIndex].done = onlineToDo.done
									toDoVC.unDoneToDos.append(toDoVC.doneToDos[changeAtIndex])
									toDoVC.doneToDos.remove(at: changeAtIndex)
								}

							}
							toDoVC.toDosTableView.reloadData()
						}
					}else {
						// IF NAMES ARE DIFFERENT - CHANGE NAMES
						if changedToDo.done {
							if let changeAtIndex = toDoVC.doneToDos.firstIndex(where: { (toDo) -> Bool in
								return toDo.uID == onlineToDo.uID
							}) {
								toDoVC.doneToDos[changeAtIndex].name = onlineToDo.name
								toDoVC.toDosTableView.reloadRows(at: [IndexPath(row: changeAtIndex, section: 1)], with: .none)
							}
						}else {
							if let changeAtIndex = toDoVC.unDoneToDos.firstIndex(where: { (toDo) -> Bool in
								return toDo.uID == onlineToDo.uID
							}) {
								toDoVC.unDoneToDos[changeAtIndex].name = onlineToDo.name
								toDoVC.toDosTableView.reloadRows(at: [IndexPath(row: changeAtIndex, section: 0)], with: .none)
							}
						}
					}
				}else {
					toDoVC.unDoneToDos.append(onlineToDo)
					toDoVC.toDosTableView.reloadData()

				}
			}
		}

	}

	struct Notes {
		//MARK: -  NOTES
		static func saveNew(note: FBNote, in parentProject: String) {
			let dataBase = Database.database().reference()
			let newNoteRef = dataBase.child(S.notes).childByAutoId()
			
			let newNoteData = [S.name: note.name, S.content: note.content, S.parentProject: parentProject]
			newNoteRef.updateChildValues(newNoteData)
			dataBase.child("\(S.projects)/\(note.parentProjectUID)/\(S.notes)/\(newNoteRef.key!)").setValue(note.name)
		}

		static func updateExisting(note: FBNote, in thisProject: DatabaseReference) {
			let noteRef = Database.database().reference().child("\(S.notes)/\(note.uID)")


			noteRef.updateChildValues([S.name: note.name, S.content: note.content, S.parentProject: note.parentProjectUID])
			thisProject.child("\(S.notes)/\(note.uID)").setValue(note.name)


		}
		
		static func deleteNote(with noteUID: String, in thisProject: String) {
			let noteRef = Database.database().reference().child(S.notes)
			noteRef.child(noteUID).removeValue()

			let projectNoteRef = Database.database().reference().child("\(S.projects)/\(thisProject)/\(S.notes)/\(noteUID)")
			projectNoteRef.removeValue()



		}

		//MARK: -  Note Single Time Loading

		static func loadAllNotes(of thisProject: DatabaseReference, mainDispatcher: DispatchGroup, noteVC: NotesVC) {
			var allNoteUIDS: [String] = []
			var allNotes: [FBNote] = []
			let notesRef = Database.database().reference().child(S.notes)
			let loadingDispatcher = DispatchGroup()

			thisProject.child(S.notes).observeSingleEvent(of: .value) { (noteList) in
				for noteEnum in noteList.children {
					let note = noteEnum as! DataSnapshot
					allNoteUIDS.append(note.key)
				}

				for note in allNoteUIDS {
					loadingDispatcher.enter()
					notesRef.child(note).observeSingleEvent(of: .value) { (noteDownload) in
						allNotes.append(FBNote(uID: note, data: noteDownload.value as? [String: String] ?? [:]))
						loadingDispatcher.leave()
					}
				}

				loadingDispatcher.notify(queue: .main) {
					noteVC.notes = allNotes
					mainDispatcher.leave()
					//
				}
			}
		}

		//MARK: -  Note Observers
		static func childAddedObserver(notesVC: NotesVC) {
			let toDosRef = Database.database().reference().child(S.notes)
			toDosRef.observe(.childAdded) { (noteAdded) in
				if !notesVC.notes.contains(where: { (localNote) -> Bool in
					return localNote.uID == noteAdded.key
				}) {
					notesVC.notes.append(FBNote(uID: noteAdded.key, data: noteAdded.value as? [String : String] ?? [:]))
					notesVC.notesTableView.reloadData()
				}
			}
		}

		static func childRemovedObserver(notesVC: NotesVC) {
			let toDosRef = Database.database().reference().child(S.notes)
			toDosRef.observe(.childRemoved) { (removedNote) in
				if notesVC.notes.contains(where: { (localNote) -> Bool in
					return localNote.uID == removedNote.key
				}) {
					notesVC.notes.removeAll { (localNote) -> Bool in
						return localNote.uID == removedNote.key
					}
					notesVC.notesTableView.reloadData()
				}
			}
		}

		static func childChangedObserver(notesVC: NotesVC) {
			let toDosRef = Database.database().reference().child(S.notes)
			toDosRef.observe(.childChanged) { (changedNote) in
				if let noteIndex = notesVC.notes.firstIndex(where: { (localNote) -> Bool in
					return localNote.uID == changedNote.key
				}) {
					notesVC.notes[noteIndex].updateData(name: changedNote.childSnapshot(forPath: S.name).value as! String, content: changedNote.childSnapshot(forPath: S.content).value as! String)
					notesVC.notesTableView.reloadData()
				}
			}
		}



	}

	struct Photos {

	}

}
