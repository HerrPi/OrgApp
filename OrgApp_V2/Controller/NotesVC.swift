import UIKit
import RealmSwift
import Firebase

class NotesVC: UIViewController {
	@IBOutlet weak var notesTableView: UITableView!
	@IBOutlet weak var addNoteButton: UIButton!

	var tabBarVC: ProjectTabBarVC!

	var notesDataBase: DatabaseReference!
	var thisProject: DatabaseReference!
	var notes: [FBNote] = []

	var hideContent: Bool = true
	var editNotesButton: UIBarButtonItem!



    override func viewDidLoad() {
        super.viewDidLoad()

		tabBarVC = self.parent as? ProjectTabBarVC
		thisProject = tabBarVC.thisProject

		notesDataBase = Database.database().reference().child("\(S.notes)")

		thisProject.child(S.notes).observeSingleEvent(of: .value) { (notes) in
			self.notes.removeAll()
			for noteEnum in notes.children {
				let noteUID = noteEnum as! DataSnapshot
				let note = self.notesDataBase.child(noteUID.key)
				let newNote = FBNote(uID: note.key!, name: note.value(forKey: S.name) as! String, content: note.value(forKey: S.content) as! String, parentProjectUID: note.value(forKey: S.parentProject) as! String)
				self.notes.append(newNote)
			}
		}



		notesTableView.rowHeight = UITableView.automaticDimension
		notesTableView.estimatedRowHeight = 600
		notesTableView.delegate = self
		notesTableView.dataSource = self
		notesTableView.register(UINib(nibName: K.CustomCells.noteCell, bundle: nil), forCellReuseIdentifier: K.CustomCells.noteCell)

		let tableTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapTableNil))
		notesTableView.addGestureRecognizer(tableTapRecognizer)
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		hideContent = true
		notesTableView.reloadData()

		self.parent?.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Show note", style: .plain, target: self, action: #selector(previewNoteButton))]
		editNotesButton = self.parent?.navigationItem.rightBarButtonItem

	}


	@IBAction func addNoteAction(_ sender: UIButton) {
//		performSegue(withIdentifier: K.Segues.showNote, sender: createNewNote())
		print("Dummy Add Note")
	}



	@objc func previewNoteButton() {
		hideContent = !hideContent
		if hideContent {
			editNotesButton.title = "Show note"

		}else {
			editNotesButton.title = "Hide note"
		}

		notesTableView.reloadData()
	}


	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		print("Dummy Note Detail")
//		if segue.identifier == K.Segues.showNote {
//			let noteDetail = segue.destination as! NoteDetailVC
//			noteDetail.thisProject = thisProject
//			if sender is NoteTCC {
//				noteDetail.thisNote = (sender as! NoteTCC).thisNote
//			}else {
//				noteDetail.thisNote = sender as? Note
//			}
//
//
//		}
	}

	func createNewNote() -> Note {
		print("Dummy Create Note")
		let newNote = Note()
		newNote.name = ""
		newNote.content = "Input content here..."
//		RealmFuncs.Edit.setParent(of: newNote, to: thisProject)
		return Note()

	}

	@objc func tapTableNil(tap: UITapGestureRecognizer) {
		let tappedIndexPath: IndexPath? = notesTableView.indexPathForRow(at: tap.location(in: notesTableView))
		if tappedIndexPath == nil {
			print("Tapped in Nil -> Create NEw Note")
//			performSegue(withIdentifier: K.Segues.showNote, sender: createNewNote())

		}else {
			print("Tapped a Note -> Go to DetailVC")
//			performSegue(withIdentifier: K.Segues.showNote, sender: notesTableView.cellForRow(at: tappedIndexPath!))

		}
	}



}

//MARK: -  TABLE VIEW DELEGATE AND DATASOURCE
extension NotesVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notes.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.CustomCells.noteCell, for: indexPath) as! NoteTCC

		cell.thisNote = notes[indexPath.row]
		cell.titleLabel.text = cell.thisNote.name
		cell.contentPreviewLabel.text = cell.thisNote.content

		if hideContent {
			cell.contentPreviewLabel.isHidden = true
		}else {
			cell.contentPreviewLabel.isHidden = false

		}

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		notesTableView.deselectRow(at: indexPath, animated: true)
		print("Dummy Select")
//		performSegue(withIdentifier: K.Segues.showNote, sender: notesTableView.cellForRow(at: indexPath))

	}

	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
//			RealmFuncs.Edit.deleteObject((self.notesTableView.cellForRow(at: indexPath) as! NoteTCC).thisNote)
//			self.notesTableView.deleteRows(at: [indexPath], with: .fade)
			print("Dummy Delete")
		}

		return UISwipeActionsConfiguration(actions: [delete])

	}



}



