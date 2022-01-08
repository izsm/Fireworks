//
//  ViewController.swift
//  ARDemo
//
//  Created by zhangshumeng on 2022/1/7.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // 创建一个平面几何形状SCNPlane 宽为0.5米，高为1米
        let plane = SCNPlane(width: 0.5, height: 1)
        // 基于几何图形创建节点
        // 节点的创建不仅仅可以基于平面，长方体、圆球、圆锥、圆环、金字塔形 等等都可以创建。
        let node = SCNNode(geometry: plane)
        node.position = SCNVector3Make(0, 0.1, -1)
        // 创建渲染器
        let material = SCNMaterial()
        // 这个 contents 属性可以设置很多东西，UILabel，                UIImage，甚至 AVPlayer 都可以
        material.diffuse.contents = createFireWorksView()
        // 用渲染器对几何图形进行渲染
        node.geometry?.materials = [material]
        // 添加节点
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

extension ViewController {
    
    // 烟花View
    private func createFireWorksView() -> UIView {
        let fireworksBgView = UIView()
        fireworksBgView.isOpaque = false
        fireworksBgView.frame = CGRect(x: 0, y: 0, width: 500, height: 1000)
        let viewSize = fireworksBgView.bounds.size
        
        // 设置CAEmitterLayer
        let fireworksEmitter = CAEmitterLayer()
        fireworksEmitter.preservesDepth = true
        // 1、设置发射的位置
        fireworksEmitter.emitterPosition = CGPoint(x: viewSize.width/2, y: viewSize.height)
        // 发射源的size 决定了发射源的大小
        fireworksEmitter.emitterSize = CGSize(width: viewSize.width/2, height: 0)
        // 发射模式
        fireworksEmitter.emitterMode = .outline
        // 发射形状
        fireworksEmitter.emitterShape = .line
        // 渲染模式
        fireworksEmitter.renderMode = .additive
        // 用于初始化随机函数的种子
        fireworksEmitter.seed = arc4random()%100 + 1
        // 每秒产生的粒子数量的系数
        fireworksEmitter.birthRate = 1

        // 2、发射
        let rocket = CAEmitterCell()
        // 粒子参数的速度乘数因子
        rocket.birthRate = 1
        // 发射角度
        rocket.emissionRange = 0
        // 速度
        rocket.velocity = 500
        // 速度范围
        rocket.velocityRange = 100
        // y方向的加速度分量
        rocket.yAcceleration = 70
        rocket.lifetime = 1.02
        // 粒子要展示的图片
        rocket.contents = UIImage(named: "01")?.cgImage
        // 缩放比例
        rocket.scale = 1
        // 粒子颜色
        rocket.color = UIColor.red.cgColor
        rocket.greenRange = 1
        rocket.redRange = 1
        rocket.blueRange = 1
        // 粒子旋转角度范围
        rocket.spinRange = 0

        // 3、爆炸
        let burst = CAEmitterCell()
        // 粒子参数的速度乘数因子
        burst.birthRate = 1.0
        // 速度
        burst.velocity = 10
        burst.scale = 1
        burst.redSpeed = -1.5
        burst.blueSpeed = 1.5
        burst.greenSpeed = 1.0
        burst.lifetime = 0.1

        // 4、爆炸后飞溅的火花
        let spark = CAEmitterCell()
        spark.birthRate = 400
        spark.velocity = 300
        spark.emissionRange = 2 * CGFloat.pi
        spark.yAcceleration = 200
        // 生命周期范围
        spark.lifetime = 1.5
        // 粒子内容
        spark.contents = UIImage(named: "01")?.cgImage
        spark.scaleSpeed = -0.4
        spark.greenSpeed = -0.1
        spark.redSpeed = 0.4
        spark.blueSpeed = -0.1
        spark.alphaSpeed = -0.25
        spark.spin = 2 * CGFloat.pi
        spark.spinRange = 2 * CGFloat.pi

        // 粒子添加到CAEmitterLayer上
        fireworksEmitter.emitterCells = [rocket]
        rocket.emitterCells = [burst]
        burst.emitterCells = [spark]
        fireworksBgView.layer.addSublayer(fireworksEmitter)
        return fireworksBgView
    }
}
