//
//  RefreshControl.swift
//  BusinessDirectory
//
//  Created by mukesh awal on 1/22/20.
//  Copyright © 2020. All rights reserved.
//
/******************************************************************
 -uses RxSwift and RxCocoa
 -add instance of this class to background of your scroll view
 
 ******************************    points  ***********************************
                
        left top *                                      * right top
                 |                                      |
                 |                                      |
                 |                                      |
                 |                                      |
     left bottom *                                      * right bottom
                 ------------------ * -------------------
                                middle bottom
 
 ******************************************************************/

import UIKit
import RxCocoa
import RxSwift


/// add instance of this class to background of your scroll view. you can set size of refresh circle using "setRefreshCircleSize". you can set fillColor of refresh control using "setFillColor" , set Max Height Of Refresh Control using "setMaxHeightOfRefreshControl", set color of refresh circle using "setRefreshCircleColor",
class UINCRefreshControl: UIView {
    
    //MARK: - properties
    
    //enum for observers
    enum Observer{
        case contentOffset
        case panGesture
    }
    
    //enum for radius of refresh circle
    enum RefreshCircleSize : CGFloat{
        case small = 12.0
        case medium = 17.0
        case large = 22.0
    }
    
    /// indicates refreshing status
    private var refreshingStatus = false
    
    let bag = DisposeBag()
    
    //MARK: - layers
    private let shapeLayer = CAShapeLayer()
    private let circleLayer = CAShapeLayer()
    
    //MARK: - points on path of border
    var leftTop = CGPoint()
    var rightTop = CGPoint()
    var leftBottom = CGPoint()
    var rightBottom = CGPoint()
    var midBottom = CGPoint()
    
    ///content offset of scroll view that  keeps updated according to scroll detected
    private var scrollViewContentYOffset: CGFloat = 0
    
    ///dynamic xposition of panGesture over scroll view
    private var xPositionOfPan : CGFloat = 0
    
    /// y offset for middle bottom point
    private var middleBottomPointYOffset : CGFloat = 0
    
    ///y offset for bottom edge points
    private var edgeBottomPointYOffset : CGFloat = 0
    
    /// center point for circle
    private var centerForCircle : CGPoint = CGPoint(x: 0, y: 0)
    
    ///threshold drag value
    private var thresholdDrag : CGFloat = 130
    
    ///maximum height of refresh control
    private var maxHeightOfRefreshControl: CGFloat = 170
    
    ///size of refresh circle
    private var refreshCircleSize : RefreshCircleSize = .medium
    
    ///called when user refresh is triggered
    private var onRefreshing : () -> Void = {
        debugLog("refresh triggerd. Implement setOnRefreshing of RefreshControl to call your own function, and dont forget to call endRefreshing() at end of that task you perform inside that function")
    }
    
    ///fill color of refresh control
    var setFillColor : UIColor = UIColor.systemOrange {
        didSet{
            shapeLayer.fillColor = setFillColor.cgColor
        }
    }
    
    ///color of refresh circle
    var setRefreshCircleColor : UIColor = UIColor.white {
        didSet{
            circleLayer.strokeColor = setRefreshCircleColor.cgColor
        }
    }
    
    //MARK: - set
    ///set maxHeight of refreshControl. minimum is 130
    var setMaxHeightOfRefreshControl : CGFloat = 0 {
        didSet{
            maxHeightOfRefreshControl = max(setMaxHeightOfRefreshControl, 170)
        }
    }
    
    //set size of refresh circle
    var setRefreshCircleSize : RefreshCircleSize = RefreshCircleSize.medium {
        didSet{
            refreshCircleSize = setRefreshCircleSize
        }
    }
    
    //set function to be called after refresh is triggerd
    var setOnRefreshing : () -> Void = {} {
        didSet{
            onRefreshing = setOnRefreshing
        }
    }
    
    ///return super view as scroll view. may be table view or collection view too. if superView doesnot exist then return nil
    var containerScrollView : UIScrollView? {
        return superview as? UIScrollView
    }
    
    //MARK: - initializer
    override init(frame : CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addObserver(.contentOffset)
        addObserver(.panGesture)
    }
    
    //MARK: - common init
    private func commonInit(){
        shapeLayer.fillColor = setFillColor.cgColor
        shapeLayer.actions = ["path" : NSNull(), "position" : NSNull(), "bounds" : NSNull()]
        layer.addSublayer(shapeLayer)
        shapeLayer.masksToBounds = true
        
        circleLayer.lineWidth = 4
        circleLayer.strokeColor = setRefreshCircleColor.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.actions = ["path" : NSNull(), "position" : NSNull(), "bounds" : NSNull()]
        layer.addSublayer(circleLayer)
    }
    
    //MARK: - draw rect
    override func draw(_ rect: CGRect) {
        
        guard let _ = containerScrollView else {return}
        calculate(rect)
        
        leftTop = CGPoint(x: rect.minX, y: rect.minY)
        rightTop = CGPoint(x: rect.maxX, y: rect.minY)
        leftBottom = CGPoint(x: rect.minX, y: edgeBottomPointYOffset)
        rightBottom = CGPoint(x: rect.maxX, y: edgeBottomPointYOffset)
        midBottom = CGPoint(x: xPositionOfPan, y: middleBottomPointYOffset)
        
        ///border path of refresh control
        let path = CGMutablePath()
        path.move(to: leftTop)
        path.addLine(to: leftBottom)
        path.addLine(to: midBottom)
        path.addLine(to: rightBottom)
        path.addLine(to: rightTop)
        path.closeSubpath()
        
        shapeLayer.path = path
        
        if !refreshingStatus {
            ///circle refresh path
            let draggedFractionCompleted = edgeBottomPointYOffset / thresholdDrag
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: refreshCircleSize.rawValue, startAngle: getStartAngle(draggedFractionCompleted), endAngle: getStartAngle(draggedFractionCompleted + 0.85), clockwise: true)
            circleLayer.path = circlePath.cgPath
        }
    }
    
    //MARK: - observers
    /// Add scroll view content y offset and scroll view panGesture observers
    /// - Parameter observer: RefreshControl.Observer type
    private func addObserver(_ observer : Observer){
        guard let scrollView = containerScrollView else {return}
        
        switch observer {
        case .contentOffset:
            scrollView.rx.contentOffset.bind(onNext: {[weak self] offset in
                self?.scrollViewContentYOffset = -offset.y
                self?.setNeedsDisplay()
                }).disposed(by: bag)
            break
            
        case .panGesture:
            scrollView.panGestureRecognizer.rx.event.bind(onNext: {[weak self] panGesture in
                self?.xPositionOfPan = panGesture.location(in: self?.containerScrollView).x
                self?.setNeedsDisplay()
                
                switch panGesture.state{
                case .cancelled,.failed,.ended:
                    if (self?.scrollViewContentYOffset)! > (self?.thresholdDrag)!{
                        self?.refreshingStatus = true
                        self?.setNeedsDisplay()
                        self?.animateRefreshCircle()
                        self?.onRefreshing()
                    }
                    break
                default:
                    break
                }
                }).disposed(by: bag)
            break
        }
    }
    
    //MARK: - calculation
    /// calculates all required dynamic variables and sets frame of layers
    /// - Parameter rect: CGRect of view's frame
    private func calculate(_ rect : CGRect){
        
        //guard "scrollViewContentYOffset" to be greater than zero
        //i.e. user is dragging scroll view downward such that actual content offset of scroll view is negative
        guard scrollViewContentYOffset >= 0 else {
            middleBottomPointYOffset = 0
            edgeBottomPointYOffset = 0
            return
            
        }
        
        //calculating y offsets of points
        //if refreshing status is false then we have to draw V shape at bottom
        if !refreshingStatus{
            middleBottomPointYOffset = min(scrollViewContentYOffset, maxHeightOfRefreshControl)
            edgeBottomPointYOffset = max((middleBottomPointYOffset - 20),0)
        }else{
            //else if refreshing status is true then --- straight line at bottom
            middleBottomPointYOffset = min(scrollViewContentYOffset, thresholdDrag)
            edgeBottomPointYOffset = middleBottomPointYOffset
            
            //then set scroll view's content inset
            containerScrollView?.contentInset.top = middleBottomPointYOffset
        }
        
        //calculating frame of layer
        shapeLayer.frame = CGRect(x: 0, y: 0, width: rect.width, height: middleBottomPointYOffset)
        
        //calculate center of circle
        centerForCircle = CGPoint(x: rect.midX, y: edgeBottomPointYOffset - (thresholdDrag / 2))
        circleLayer.frame = CGRect(x: centerForCircle.x, y: centerForCircle.y, width: 0, height: 0)
        //wondering why are we providing frame with height and width zero and origin to center of circle??
        //since animating a layer about z axis by default rotates whole frame of that layer about its origin
        //so setting origin of frame of circle layer to center of circle with height and width as zero(basically a pin point \ (•◡•) /)
        //then applying rotation about z-axis will rotate our circle in desired way
        // kinda hack you want to use if you are ever stuck in these rotation stuff ¯\_(ツ)_/¯
        
    }
    
    
    /// calculating starting angle to draw circle according to fraction of drag completed
    /// - Parameter fractionCompleted: fraction of drag completed
    private func getStartAngle(_ fractionCompleted : CGFloat) -> CGFloat{
        return ((2 * CGFloat.pi) * (fractionCompleted))
    }
    
    //MARK: - animation
    /// animates refresh circle
    private func animateRefreshCircle(){
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = CGFloat.pi * CGFloat(2.0)
        animation.duration = 1.5
        animation.repeatCount = .infinity
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        circleLayer.add(animation, forKey: "rotate")
    }
    
    // call this function after your desired task after refreshing is completed
    func endRefreshing(){
        circleLayer.removeAllAnimations()
        UIView.animate(withDuration: 0.35, animations: {[weak self] in
            self?.containerScrollView?.contentInset.top = 0.0
        }, completion: {[weak self] _ in
            self?.refreshingStatus = false
        })
    }
    
    func isRefreshing() -> Bool {
        return refreshingStatus
    }
}
