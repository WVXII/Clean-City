//
//  photoDetailViewController.swift
//  Clean City
//
//  Created by Alexandre GILBERT on 17/09/2020.
//  Copyright © 2020 Alexandre GILBERT. All rights reserved.
//

import UIKit

protocol DeleteDetailDelegate{
    func didDeleteSelectedItem(indexPaths:[IndexPath], indexPath: IndexPath, isTrashButtonPushed: Bool )
}

class photoDetailViewController: UIViewController {

    var rubbishItem: Rubbish?
    var indexPath: IndexPath = []
    var waste = [Rubbish]()
    var ButtonPushed: Bool = false
    var delegate: DeleteDetailDelegate! = nil
    @IBOutlet weak var photoDetail: UIImageView!
    @IBOutlet weak var trashDetail: UIBarButtonItem!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func deleteExitDetail(_ sender: Any) {
        var indexPaths: [IndexPath] = []
        ButtonPushed = true
        indexPaths.append(indexPath)
        delegate.didDeleteSelectedItem(indexPaths: indexPaths, indexPath: indexPath, isTrashButtonPushed: ButtonPushed)
        _ = navigationController?.popViewController(animated: true)
        print("exit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let imagePath = getDocumentsDirectory().appendingPathComponent(rubbishItem?.image ?? "")

        let latitudePath = getDocumentsDirectory().appendingPathComponent(rubbishItem?.latitude ?? "")

        let longitudePath = getDocumentsDirectory().appendingPathComponent(rubbishItem?.longitude ?? "")

        photoDetail.image = UIImage(contentsOfFile: imagePath.path)

        do {
            print("longitudePath=\(longitudePath)")
            try longitudeLabel.text = String(contentsOf: longitudePath)
        } catch {
            print(error.localizedDescription)
        }
        do {
            print("latitudePath=\(latitudePath)")
            try latitudeLabel.text = String(contentsOf: latitudePath)
        } catch {
            print(error.localizedDescription)
        }
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //}
    

}
