//
//  TutorialViewController.swift
//  RingtoneZ
//
//  Created by ChuoiChien on 12/5/20.
//

import UIKit

class TutorialViewController: BaseViewController {
    
    fileprivate var pageViewController: UIPageViewController?
    fileprivate var pageControl: UIPageControl?
    fileprivate var startingViewController: PageContentViewController?
    fileprivate var viewControllers = [UIViewController]()
    fileprivate var curentIndex = 0
    fileprivate var arrPageImage = ["step1", "step2", "step3", "step4", "step5", "step6"]
    static var name: String {
        return String.className(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configPageVC()
        configPageControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLayoutSubviews() {
        pageControl!.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    
    @IBAction func clickBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension TutorialViewController {
    
    func configPageVC() -> Void {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        if IS_IPHONE_5_5S_SE {
            pageViewController?.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } else if IS_IPHONE_6_6S_7_8 {
            pageViewController?.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } else if IS_IPHONE_6PLUS_7PLUS_8PLUS {
            pageViewController?.view.frame = CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } else if IS_IPHONE_X_XS {
            pageViewController?.view.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } else if IS_IPHONE_XR_XSMAX {
            pageViewController?.view.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        } else {
            pageViewController?.view.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        
        startingViewController = viewControllerAtIndex(index: 0)!
        viewControllers = [startingViewController!]
        pageViewController?.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        addChild(pageViewController!)
        view.addSubview((pageViewController?.view)!)
        pageViewController?.didMove(toParent: self)
    }
    
    func configPageControl() -> Void {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 88,width: UIScreen.main.bounds.width,height: 88))
        pageControl?.numberOfPages = arrPageImage.count
        pageControl?.currentPage = 0
        pageControl?.tintColor = UIColor.black
        pageControl?.alpha = 1
        pageControl?.pageIndicatorTintColor = UIColor.black
        pageControl?.currentPageIndicatorTintColor = UIColor(hex: "#F16489")
        view.addSubview(pageControl!)
    }
    
    func viewControllerAtIndex(index: Int) -> PageContentViewController?
    {
        if arrPageImage.count == 0 || index >= arrPageImage.count
        {
            return nil
        }
        // Create a new view controller and pass suitable data.
        curentIndex = index
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        pageContentViewController.pageIndex = index
        pageContentViewController.nameImage = arrPageImage[index]
        return pageContentViewController
    }
}

extension TutorialViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).pageIndex
        if index == 0 {
            return nil
        }
        index -= 1
        
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).pageIndex
        index += 1
        if index == arrPageImage.count {
            return nil
        }
        
        return viewControllerAtIndex(index: index)
    }
}

extension TutorialViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController: PageContentViewController = pageViewController.viewControllers![0] as! PageContentViewController
        pageControl?.currentPage = pageContentViewController.pageIndex
    }
}

