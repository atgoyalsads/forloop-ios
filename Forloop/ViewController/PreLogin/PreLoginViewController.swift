//
//  PreLoginViewController.swift
//  Forloop
//
//  Created by Tecorb on 09/12/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//

import UIKit


class PreLoginViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var aCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    
    var currentPage: Int = 0
    var introImages = ["intro_first","intro_second","intro_third"]
    var descArray = ["Decide your own rate ($/min)\nfor calls.","Earn money by providing answers\nto seekers on phone calls.","Simply search professionals by category and connect via in-app call."]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        aCollectionView.register(UINib(nibName: "IntroScreenCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IntroScreenCollectionViewCell")
        aCollectionView.dataSource = self
        aCollectionView.delegate = self
        self.aCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.pageControl.hidesForSinglePage = true
        self.pageControl.numberOfPages = self.introImages.count

        // Do any additional setup after loading the view.
    }
    

    override func viewDidLayoutSubviews() {
        self.pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onClickSkipButton(_ sender: UIButton){
        
        self.navigateToLoginScreen()
    }
    
    func navigateToLoginScreen(){
        let signInVC = AppStoryboard.Main.viewController(LoginViewController.self)
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    
    @IBAction func onClickNextButton(_ sender: UIButton){
        let collectionBounds = self.aCollectionView.bounds
          let contentOffset = CGFloat(floor(self.aCollectionView.contentOffset.x + collectionBounds.size.width))
          self.moveCollectionToFrame(contentOffset: contentOffset)
        
        if (self.currentPage+1) == self.introImages.count{
            self.navigateToLoginScreen()
            return
        }
        let pageWidth = self.aCollectionView.frame.width
        self.currentPage = Int((contentOffset + pageWidth / 2) / pageWidth)
        self.pageControl.currentPage = self.currentPage
        
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {

         let frame: CGRect = CGRect(x : contentOffset ,y : aCollectionView.contentOffset.y ,width : self.aCollectionView.frame.width,height : aCollectionView.frame.height)
         self.aCollectionView.scrollRectToVisible(frame, animated: true)
     }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return introImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroScreenCollectionViewCell", for: indexPath) as!  IntroScreenCollectionViewCell
        cell.descLabel.text = self.descArray[indexPath.item]
        cell.introImage.image = UIImage(named: self.introImages[indexPath.item])

        //self.setupViewForItem(cell)
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = collectionView.bounds.size
        //        cellSize.width -= collectionView.contentInset.left
        //        cellSize.width -= collectionView.contentInset.right
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let aCell = cell as? IntroScreenCollectionViewCell else {
            return
        }
        self.pageControl.currentPage =  self.currentPage
        aCell.layoutIfNeeded()
        aCell.setNeedsLayout()
    }
    
    

    
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == aCollectionView{
            let pageWidth = scrollView.frame.width
            self.currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            self.pageControl.currentPage = self.currentPage
        }

    }


    
}
