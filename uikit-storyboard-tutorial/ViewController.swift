//
//  ViewController.swift
//  uikit-storyboard-tutorial
//
//  Created by dhui on 2023/07/06.
//

import Foundation
import UIKit
import Cosmos
import PhotosUI
import UITextView_Placeholder

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
        
        reviewView.placeholder = "내용을 입력해주세요."
        reviewView.placeholderColor = .lightGray
        
        // https://declan.tistory.com/14 참고
        
        // textView에 delegate 상속
        reviewView.delegate = self
        
        // textView border
        reviewView.layer.borderWidth = 1
        reviewView.layer.borderColor = UIColor.black.cgColor
        
        // 코스모스 별점 업데이트하기
        cosmosView.didFinishTouchingCosmos = { rating in
            var ratings = Int(rating)
            self.countRatings.text = "\(ratings)점"
        }
        
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
    
    
    

   
}

// delegate 패턴에 대해서 - https://velog.io/@nala/iOS-Delegate-%ED%8C%A8%ED%84%B4%EC%9D%84-%EC%9D%B4%ED%95%B4%ED%95%B4%EB%B3%B4%EC%9E%90



extension ViewController: UITextViewDelegate {
    
    
   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = reviewView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        countLabel.text = "\(changedText.count) / 20"
        return changedText.count <= 19
    }
}


class MyTextView: UITextView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // swift textview restrict paste
        
        // 복사는 안되는데 왜 클릭만 해도 밑에 로그가 뜰까요?
        // UIResponderStandardEditActions.cut(_:)으로 하면 복사는 가능합니다.
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            print(#fileID, #function, #line, "- 복사할겨?")
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
