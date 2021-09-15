//
//  CheatFlgExplanationVC.swift
//  Roulette
//
//  Created by Takumi Sakai on 2021/09/12.
//

import UIKit

class CheatFlgExplanationVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
        
        // AutoLayout
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        pageControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scrollView.contentOffset.x = 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UI setting method
    func setUI() {
        scrollView.contentSize = CGSize(width: scrollView.frame.width * 3, height: scrollView.frame.size.height)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        let imageView1 = createImageView(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height, imageName: "cheatFlgExplanation1")
        let imageView2 = createImageView(x: scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height, imageName: "cheatFlgExplanation2")
        let imageView3 = createImageView(x: scrollView.frame.size.width * 2, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height, imageName: "cheatFlgExplanation3")
        
        scrollView.addSubview(imageView1)
        scrollView.addSubview(imageView2)
        scrollView.addSubview(imageView3)

        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
    }
    
    func createImageView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, imageName: String) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
        imageView.image = UIImage(named: imageName)
        
        return imageView
    }
    
    
    // MARK: - UIScrollViewDelegate method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    // MARK: - UI tap action method
    @IBAction func pageControllTap(_ sender: Any) {
        scrollView.contentOffset.x = scrollView.frame.size.width * CGFloat(pageControl.currentPage)
    }
    
}
