//
//  CollectionViewController.swift
//  Clean City
//
//  Created by Alexandre GILBERT on 26/08/2020.
//  Copyright © 2020 Alexandre GILBERT. All rights reserved.
//

import UIKit
import CoreLocation
import MultipeerConnectivity
import PhotosUI

protocol RubbishDataDelegate{
    func ImportRubbishData(rubbishData: [Rubbish])
}

class CollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, DeleteDetailDelegate, PHPickerViewControllerDelegate, CLLocationManagerDelegate{
    
    //,MCSessionDelegate, MCBrowserViewControllerDelegate
    
    var images = [UIImage]()
    var waste = [Rubbish]()
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    var currentItem: Rubbish?
    var currentIndexPath: IndexPath = []
    @IBOutlet weak var trash: UIBarButtonItem!
    var configuration = PHPickerConfiguration()
    var locationManager: CLLocationManager! //This is the Core Location class that lets us configure how we want to be notified about location
    
    //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error \(error)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let center = CLLocationCoordinate2D(latitude: locations.last!.coordinate.latitude, longitude: locations.last!.coordinate.longitude)
        print("Latitude :\(center.latitude)")
        print("Longitude :\(center.longitude)")
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

   /* func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            case .connected:
                print("Connected: \(peerID.displayName)")

            case .connecting:
                print("Connecting: \(peerID.displayName)")

            case .notConnected:
                print("Not Connected: \(peerID.displayName)")

            @unknown default:
                print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
    //Not used but declaration required for build
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rubish Selfie"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePicture))
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        //Should be visible only when trashButton is enable
        navigationController?.setToolbarHidden(false, animated: false)


        //Cell selected on long press
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressGR.minimumPressDuration = 0.5
        longPressGR.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(longPressGR)


        //mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        //mcSession?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager.requestAlwaysAuthorization()
            //locationManager?.requestWhenInUseAuthorization()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
        }
        //Loading images from phone memory
        let defaults = UserDefaults.standard
           if let savedWaste = defaults.object(forKey: "waste") as? Data {
               if let decodedWaste = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedWaste) as? [Rubbish] {
                   waste = decodedWaste
                print("viewWillAppear waste count: \(waste.count)")
               }
            }
    }

    /*func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }

    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }*/
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: waste, requiringSecureCoding: false) {// converts our array into a Data object,
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "waste") //save that data object to UserDefaults
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            trash.isEnabled = false
        } else {
            trash.isEnabled = true
        }
    }
    
    //1 Cell selected on long press
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }
        let p = gestureRecognizer.location(in: collectionView)

        if let indexPath = collectionView?.indexPathForItem(at: p) {
            currentItem = waste[indexPath.item]
            currentIndexPath = indexPath
            performSegue(withIdentifier: "showDetail", sender: nil)
        }
    }

    @IBAction func deleteItem(_ sender: Any) {
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            // 1
            let items = selectedCells.map { $0.item }.sorted().reversed()
            // 2
            for item in items {
                waste.remove(at: item)
            }
            // 3
            collectionView.deleteItems(at: selectedCells)
            self.collectionView.reloadData()
            trash.isEnabled = false
            save()
        }
    }
    
    // 2 Did Deselect Cell
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
            trash.isEnabled = false
        }
    }
    
    //Pass the data to the next ViewController here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetail"){
            let photoDetailVC = segue.destination as! photoDetailViewController
            photoDetailVC.delegate = self
            photoDetailVC.rubbishItem = currentItem
            photoDetailVC.indexPath = currentIndexPath
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return waste.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Rubbish", for: indexPath) as? RubbishCell else {
            fatalError("Unable to dequeue RubbishCell.")
        }

        let rubbish = waste[indexPath.item]
        print("indexPath item=\(indexPath.item)")
        
        let path = getDocumentsDirectory().appendingPathComponent(rubbish.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
    
        // collection view into editing mode.
        setEditing(true, animated: true)
        cell.isInEditingMode = isEditing

        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        collectionView.allowsMultipleSelection = editing
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! RubbishCell
            cell.isInEditingMode = editing
        }
    }

    @objc func importPicture(){
        if PHPhotoLibrary.authorizationStatus() == .notDetermined { // 1
           DispatchQueue.main.async { // 2
              PHPhotoLibrary.requestAuthorization { _ in // 3
                 DispatchQueue.main.async { // 4
                    self.importPicture() // 5
                 }
              }
           }
           return
        }
        configuration.selectionLimit = 0
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        }
    
    @objc func takePicture(){
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    
   /* @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }*/

    //Delegates:
   /* func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }*/
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        guard !results.isEmpty else {
        return
        }
        
        let latitudeName = UUID().uuidString
        let longitudeName = UUID().uuidString
        
        let longitudePath = getDocumentsDirectory().appendingPathComponent(longitudeName)
        let latitudePath = getDocumentsDirectory().appendingPathComponent(latitudeName)

        for result in results {
           result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
              if let image = object as? UIImage {
                DispatchQueue.main.async { [self] in
                    let assetId = result.assetIdentifier
                    let asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil).firstObject
                    print(asset?.creationDate ?? "No date")
                    print(asset?.location?.coordinate ?? "No location")
                    PHImageManager.default().requestImage(for: asset!, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil, resultHandler: { (image, info) in print("requested image is \(String(describing: image))")
                        })
                    // Use UIImage
                    let imageName = UUID().uuidString
                    let imagePath = self.getDocumentsDirectory().appendingPathComponent(imageName)
                    print("Selected image: \(image)")
                    if let jpegData = image.jpegData(compressionQuality: 0.8) {
                        try? jpegData.write(to: imagePath)
                        }
                    let rubbish = Rubbish(longitude: "", latitude: "" , image: imageName)
                    waste.append(rubbish)
                    print("Picker waste count=\(waste.count)")
                    collectionView.reloadData()
                    save()
                 }
              }
           })
        }
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        //var url: [URL] = []
        let imageName = UUID().uuidString
        let latitudeName = UUID().uuidString
        let longitudeName = UUID().uuidString
        let longitudeData = ((locationManager?.location?.coordinate.longitude) ?? 0.0) as CLLocationDegrees
        let latitudeData = ((locationManager?.location?.coordinate.latitude) ?? 0.0) as CLLocationDegrees
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        let longitudePath = getDocumentsDirectory().appendingPathComponent(longitudeName)
        let latitudePath = getDocumentsDirectory().appendingPathComponent(latitudeName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        do {
            try String(longitudeData).write(to: longitudePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("error cannot write longitude to disk")
        }
        do {
            try String(latitudeData).write(to: latitudePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("error cannot write latitude to disk")
        }
        
        let rubbish = Rubbish(longitude: longitudeName, latitude: latitudeName , image: imageName )

        waste.append(rubbish)
        collectionView.reloadData()
        
        /*// 1
        guard let mcSession = mcSession else { return }

        // 2
        if mcSession.connectedPeers.count > 0 {
            // 3
            if let imageData = image.pngData() {
                // 4
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    // 5
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }*/
        save()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //MARK: - location delegate methods
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation

        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

        //self.labelLat.text = "\(userLocation.coordinate.latitude)"
        //self.labelLongi.text = "\(userLocation.coordinate.longitude)"

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)

                //self.labelAdd.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
            }
        }
    }
*/

    func didDeleteSelectedItem(indexPaths: [IndexPath], indexPath: IndexPath, isTrashButtonPushed: Bool) {
        if isTrashButtonPushed {
            print("indexPath: \(indexPath.item)")
            waste.remove(at: indexPath.item)
            collectionView.deleteItems(at: indexPaths)
            save()
        }
    }
}
