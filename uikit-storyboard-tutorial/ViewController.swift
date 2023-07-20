//
//  ViewController.swift
//  uikit-storyboard-tutorial
//
//  Created by dhui on 2023/07/06.
//

import UIKit
import Cosmos
import PhotosUI

class ViewController: UIViewController, PHPickerViewControllerDelegate {

    @IBOutlet weak var reviewView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var countRatings: UILabel!
    @IBOutlet weak var photoDetail: UIView!
    
    @IBOutlet weak var pickedPhotoView: UIImageView!
    
    
    // https://www.youtube.com/watch?v=EuqUcn_p0tk
    // 사진을 선택 후 그 사진들을 results에 넣는다
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 사진 선택 후 modal이 dismiss
        dismiss(animated: true)
        
        
        for item in results {
            item.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    // print(image)
                    
                    // 선택한 사진을 초록색 imageView에 넣는다. (앨범의 처음 사진은 왜 안되는지 모르겠다.)
                    DispatchQueue.main.async {
                        self.pickedPhotoView.image = image
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // https://declan.tistory.com/14 참고
        
        // textView에 delegate 상속
        reviewView.delegate = self
        
        //처음 화면이 로드되었을 때 placeholder 처럼 띄우기
        reviewView.text = "내용을 입력해주세요."
        reviewView.textColor = UIColor.lightGray
        
        // textView border
        reviewView.layer.borderWidth = 1
        reviewView.layer.borderColor = UIColor.black.cgColor
        
    }
    
    // cameraBtn 클릭시 action
    @IBAction func cameraBtnClicked(_ sender: Any) {
        presentPickerView()
    }
    
    func presentPickerView() {
        
        // PHPickerConfiguration(설정)
        var configuration: PHPickerConfiguration = PHPickerConfiguration()
        // asset의 type 결정(images, video, livePhoto, panorama 등등 가능)
        configuration.filter = PHPickerFilter.images
        // 선택 가능한 사진 수
        configuration.selectionLimit = 1
        
        // picker를 PHPickerViewController로 만들기
        let picker: PHPickerViewController = PHPickerViewController(configuration: configuration)
        // picker의 delegate를 자기 자신으로 설정. (delegate: 위임, 대리)
        picker.delegate = self
        // modal로 사진 설정하는 view 올라옴.
        self.present(picker, animated: true)
    }
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.reviewView.resignFirstResponder()
        
    }
}

// delegate 패턴에 대해서 - https://velog.io/@nala/iOS-Delegate-%ED%8C%A8%ED%84%B4%EC%9D%84-%EC%9D%B4%ED%95%B4%ED%95%B4%EB%B3%B4%EC%9E%90



extension ViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
            if reviewView.text.isEmpty {
                reviewView.text =  "내용을 입력해주세요."
                reviewView.textColor = UIColor.lightGray
            }
        }

        
    func textViewDidBeginEditing(_ textView: UITextView) {
            if reviewView.textColor == UIColor.lightGray {
                reviewView.text = nil
                reviewView.textColor = UIColor.black
            }
        }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = reviewView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        countLabel.text = "\(changedText.count) / 20"
        return changedText.count <= 19
    }
}


