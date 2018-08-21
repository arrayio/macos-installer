//
//  ProgressVC.swift
//  Installer
//
//  Created by Mikhail Lutskiy on 16.07.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Cocoa
import Alamofire
import ObjectMapper
import tarkit
import ObjectivePGP
import LocalAuthentication

class ProgressVC: NSViewController {
    
    let kEXTENSION = ".app"
    let kSEARCH_PATH_DIR: FileManager.SearchPathDirectory = .downloadsDirectory
    
    private var primaryLink = ""

    @IBOutlet weak var startDownloadButton: NSButton!
    @IBOutlet weak var partStatusLabel: NSTextField!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var partProgressIndicator: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Loader.shared.loadConfig()
    }
    
    func downloadFileDestination(fileName: String) -> DownloadRequest.DownloadFileDestination {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsPath = NSSearchPathForDirectoriesInDomains(self.kSEARCH_PATH_DIR, .userDomainMask, true)[0]
            let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
            let fileURL = documentsURL.appendingPathComponent(fileName)
            print(fileURL)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        return destination
    }
    
    func untar () {
        let documentsPath = NSSearchPathForDirectoriesInDomains(kSEARCH_PATH_DIR, .userDomainMask, true)[0]
        let dataPath = documentsPath.appending("/\(Loader.shared.config.name ?? "installer")")
        let filePath = dataPath.appending("/file.tar.gz")
        let toPath = documentsPath.appending("/\(Loader.shared.config.name ?? "installer")/application")
        print(toPath)
        print(dataPath)
        
        
        let script = NSAppleScript(source: "do shell script \"cd '" + dataPath + "' && tar -xzvf '" + filePath + "'\"")
        var errorInfo: NSDictionary?
        script?.executeAndReturnError(&errorInfo)
        if let error = errorInfo {
            print("ERROR: \(error)")
            self.errorReadingResults(text: "progress.unzipping_error".localized)
        } else {
            self.progressIndicator.doubleValue += 20
            self.verifySignature()
        }
    }
    
    func loadSignature() {
        self.partProgressIndicator.doubleValue = 0.0
        DispatchQueue.main.async {
            self.statusLabel.stringValue = "progress.downloading_sign".localized
            self.partStatusLabel.stringValue = "progress.downloading".localized
        }
        Alamofire.download(URL(string: primaryLink + ".sig")!, to: downloadFileDestination(fileName: "/\(Loader.shared.config.name ?? "installer")/file.sig"))
            .downloadProgress { progress in
                self.partProgressIndicator.doubleValue =  progress.fractionCompleted * 100.0
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseData { response in
                print(response.result.value)
                print(response)
                print(response.response)
                print(response.request)
                print(response.result)
                if let data = response.result.value {
                    print(data)
                    //let image = UIImage(data: data)
                }
                switch response.result {
                case .success:
                    self.progressIndicator.doubleValue += 20
                    self.loadArchive()
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                    self.errorReadingResults(text: error.localizedDescription)
                }
        }
    }
    
    fileprivate func verifySignature() {
        DispatchQueue.main.async {
            self.statusLabel.stringValue = "progress.sign_verification".localized
        }
        let bundle = Bundle.main
        let path = bundle.path(forResource: Loader.shared.config.gpgKey, ofType: nil)
        let key = try! ObjectivePGP.readKeys(fromPath: path!)
        print(key)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(kSEARCH_PATH_DIR, .userDomainMask, true)[0]
        let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
        let files = documentsURL.appendingPathComponent("/\(Loader.shared.config.name ?? "installer")/file.sig")
        let fileURL = documentsURL.appendingPathComponent("/\(Loader.shared.config.name ?? "installer")/file.tar.gz")
        
        print(try! Data(contentsOf: fileURL))
        
        let isVerify = try! VerifySigning.isVerifyFile(Data(contentsOf: fileURL), withSignatureData: Data(contentsOf: files), with: key)
        print(isVerify)
        self.progressIndicator.doubleValue += 20
        if (isVerify) {
            self.copyAppToApplication()
        } else {
            self.deleteFileAtPath(files.path)
            self.deleteFileAtPath(fileURL.path)
            self.errorReadingResults(text: "progress.sign_verification_error".localized)
        }
    }
    
    func loadArchive() {
        print(primaryLink)
        self.partProgressIndicator.doubleValue = 0.0
        DispatchQueue.main.async {
            self.statusLabel.stringValue = "progress.downloading_archive".localized
            self.partStatusLabel.stringValue = "progress.downloading".localized
        }
        Alamofire.download(URL(string: primaryLink)!, to: downloadFileDestination(fileName: "/\(Loader.shared.config.name ?? "installer")/file.tar.gz"))
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
                self.partProgressIndicator.doubleValue =  progress.fractionCompleted * 100.0
            }
            .responseData { response in
                print(response.result.value)
                print(response)
                print(response.response)
                print(response.request)
                print(response.result)
                if let data = response.result.value {
                    print(data)
                    //let image = UIImage(data: data)
                }
                switch response.result {
                case .success:
                    DispatchQueue.main.async {
                        self.statusLabel.stringValue = "progress.unzipping".localized
                    }
                    self.progressIndicator.doubleValue += 20
                    self.untar()
                case .failure(let error):
                    print(error)
                    self.errorReadingResults(text: error.localizedDescription)
                }
        }
    }
    
    func copyAppToApplication () {
        let documentsPath = NSSearchPathForDirectoriesInDomains(kSEARCH_PATH_DIR, .userDomainMask, true)[0]
        let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
        let fileURL = documentsURL.appendingPathComponent("\(Loader.shared.config.name ?? "installer")")

        let applicationsPath = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask, true)[0]
        let destURL = URL(fileURLWithPath: applicationsPath, isDirectory: true)
        let completelyDestURL = destURL.appendingPathComponent(Loader.shared.config.name ?? "Application", isDirectory: true)
        print(completelyDestURL)
        
        let fileManager = FileManager.default
        
        do {
            try fileManager.createDirectory(at: completelyDestURL, withIntermediateDirectories: false, attributes: nil)
        } catch let error {
            print(error)
        }
        
        let enumerator = fileManager.enumerator(atPath: fileURL.path)
        print(fileURL.path)
        print(enumerator)
        let filePaths = enumerator?.allObjects as! [String]
        let appFilePaths = filePaths.filter{$0.contains(kEXTENSION)}
        for appFilePath in appFilePaths{
            if String(appFilePath.suffix(4)) == kEXTENSION {
                var fullNameArr = appFilePath.components(separatedBy: "/")
                let appFilePathNew = fullNameArr[fullNameArr.count-1]
                NameStorage.shared.data.append(appFilePathNew)

                if !fileManager.fileExists(atPath: completelyDestURL.appendingPathComponent(appFilePathNew).path) {
                    do {
                        try fileManager.copyItem(at: fileURL.appendingPathComponent(appFilePath, isDirectory: false), to: completelyDestURL.appendingPathComponent(appFilePathNew))
                        print(destURL)
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                } else {
                    do {
                        try fileManager.removeItem(at: completelyDestURL.appendingPathComponent(appFilePathNew))
                        try fileManager.copyItem(at: fileURL.appendingPathComponent(appFilePath), to: completelyDestURL.appendingPathComponent(appFilePathNew))
                    }
                    catch let error as NSError {
                        print("Ooops! Something went wrong: \(error)")
                    }
                }
                self.deleteFileAtPath(fileURL.appendingPathComponent(appFilePath).path)
                print(destURL)
            }
        }
        if NameStorage.shared.data.count == 0 {
            self.errorReadingResults(text: "progress.archive_error".localized)
        } else {
            self.changeProgress(withText: "progress.copy_completed".localized, toProgress: 20)
            NotificationCenter.default.post(name: .navigationForward, object: nil)
        }
    }
    
    func deleteFileAtPath (_ file: String) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: file) {
            do {
                try fileManager.removeItem(atPath: file)
            } catch let error as NSError {
                print(error)
            }
        }
    }

    func generateLink() -> String {
        let link = Loader.shared.config.downloadLinks?.randomItem()
        return link!
    }
    
    func errorReadingResults(text: String) {
        let alert = NSAlert()
        alert.messageText = "alert.error".localized
        alert.informativeText = text
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "alert.try_again".localized)
        alert.alertStyle = .warning
        alert.beginSheetModal(for: self.view.window!) { (modalResponse) in
            if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
                NSApplication.shared.terminate(self)
            } else if modalResponse == NSApplication.ModalResponse.alertSecondButtonReturn {
                self.loadSignature()
            }
        }
    }
    
    func changeProgress (withText: String, toProgress: Double) {
        DispatchQueue.main.async {
            self.statusLabel.stringValue = withText
            self.progressIndicator.increment(by: toProgress)
        }
    }
    
    @IBAction func startDownloadAction(_ sender: Any) {
        self.primaryLink = self.generateLink()
        self.startDownloadButton.isHidden = true
        self.loadSignature()
    }
    
}
