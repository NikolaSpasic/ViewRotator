//
//  ViewController.swift
//  EndlessCollectionView
//
//  Created by Nikola Spasic on 3/19/20.
//  Copyright © 2020 Nikola Spasic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rotatingView: UIView!
    @IBOutlet weak var tickView: UIView!
    @IBOutlet weak var degreeNumberLabel: UILabel!
    @IBOutlet weak var degreeLabelViewHolder: UIView!
    
    let infiniteSize = 7200
    var numberOfIterations = 1
    var minimumDegreesMinusValues = -360
    var minimummDegrees = 0
    var previousDegree: Int?
    
    var degrees = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        for _ in 0...7199 {
            if numberOfIterations <= 10 {
                degrees.append(minimumDegreesMinusValues)
                if minimumDegreesMinusValues == 0 {
                    numberOfIterations += 1
                    minimumDegreesMinusValues = -360
                }
                minimumDegreesMinusValues += 1
            } else if numberOfIterations <= 20 {
                degrees.append(minimummDegrees)
                if minimummDegrees == 360 {
                    numberOfIterations += 1
                    minimummDegrees = 0
                }
                minimummDegrees += 1
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let midIndexPath = IndexPath(row: infiniteSize / 2, section: 0)
        collectionView.scrollToItem(at: midIndexPath,
                                         at: .centeredHorizontally,
                                   animated: false)
        tickView.layer.cornerRadius = tickView.frame.width * 0.5
        degreeLabelViewHolder.layer.cornerRadius = 8
        degreeNumberLabel.text = "0°"
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infiniteSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tickCell", for: indexPath)
        cell.backgroundColor = .lightGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 3, height: 50)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerPoint = CGPoint(x: UIScreen.main.bounds.midX, y: collectionView.frame.midY)
        let collectionViewCenterPoint = self.view.convert(centerPoint, to: collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: collectionViewCenterPoint) {
            let currentDegree = degrees[indexPath.row]
            UIView.animate(withDuration: 0.4, animations: {
                self.rotatingView.transform = CGAffineTransform(rotationAngle: CGFloat(currentDegree) * CGFloat.pi / CGFloat(180))
            })
            if let previousDgr = previousDegree {
                if previousDgr != currentDegree {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            }
            previousDegree = currentDegree
            degreeNumberLabel.text = "\(currentDegree)°"
        }
    }

}

