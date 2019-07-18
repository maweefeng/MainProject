//
//  VoiceSampleViewController.swift
//  MainProject
//
//  Created by Alex wee on 2019/7/15.
//  Copyright © 2019 Alex wee. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
class VoiceSampleViewController: UIViewController,SweetRulerDelegate,AVAudioPlayerDelegate {
    var soundFileURL:URL?
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var againBtn: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordButton: WaveButton!//录制按钮
    private let imagescale = 0.0254//图片的缩放比
    var sweetRuler: SweetRuler?
    var volumnScale: VolumeScaleView?
    var redImageWidth:CGFloat = 14.0
    var collectionView: VoicesamplingCollectionView!
    var maxTime:Double = 60.0// 最大录制时长
    var isRecording: Bool = false{
        didSet{
       
        }
        willSet{
            if newValue {
                tipLabel.text = "点击结束"
                self.recordButton.setImage(UIImage(named: "MIc-录音中"), for: .normal)
                self.recordButton.isSelected = true
                UIView.animate(withDuration: 0.1) {
                    
                    self.againBtn.isHidden  = true
                    self.nextBtn.isHidden = true

                }
            }else{
                tipLabel.text = "上传成功"
                self.recordButton.isUserInteractionEnabled = false
                self.recordButton.setImage(UIImage(named: "上传中-成功"), for: .normal)
                self.recordButton.isSelected = false
                UIView.animate(withDuration: 0.1) {
                    self.circleImageView.isHidden  = false
                    self.againBtn.isHidden  = false
                    self.nextBtn.isHidden = false
                    
                }
                
            }
        }
    }
    /// 播放器
    private var audioPlayer: AVAudioPlayer!

    /// 录音器
    private var recorder: AVAudioRecorder!
    /// 录音器设置
    private let recorderSetting = [AVSampleRateKey : NSNumber(value: Float(44100.0)),//声音采样率
        AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),//编码格式
        AVNumberOfChannelsKey : NSNumber(value: 1),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]//声音质量
    /// 录音计时器
    private var timer: Timer?
    /// 波形更新间隔
    private let updateFequency = 0.1
    /// 声音数据数组
    private var soundMeters: [Float]! = [Float]()
    /// 声音数据数组容量
    private let soundMeterCount = 1000
    /// 录音时间
    private var recordTime = 0.00

    public var imageline: UIImageView?

    override func viewDidLoad() {
    
        super.viewDidLoad()
        navigationItem.title = "声音采集"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(pop))
        recordButton.adjustsImageWhenHighlighted = false
        againBtn.layer.borderColor = UIColor(displayP3Red: 255/255.0, green: 0, blue: 117/255.0, alpha: 1.0).cgColor
        configRecord()
        setupButtonEvent()
        configRulerUI()
        configCollectionView()
        configRedlineImage()
        configVolumnScaleUI()
        
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    
        player.stop()
        print("播放完成")
    }
    
    

    ///刻度尺代理方法
    func sweetRuler(ruler: SweetRuler, figure: Int){
        
        print("figure: \(figure)")
    }
    
    
}
// MARK: Actions
extension VoiceSampleViewController{
    
    @IBAction func refreshRecord(_ sender: UIButton) {
        if(!recorder.deleteRecording()){
            //先删除文件
            do{
                try FileManager.default.removeItem(at: soundFileURL!)
            }catch{
                print(error.localizedDescription)
            }
        }
        soundMeters.removeAll()
        recordTime = 0.0
        self.collectionView.reloadData()
        UIView.animate(withDuration: self.updateFequency) {
            self.timeLabel.text = "00:00"
            let frame = self.imageline?.frame
            self.imageline?.frame =  CGRect(x: 0, y: (frame?.origin.y)!, width: (frame?.size.width)!, height: (frame?.size.height)!)
            self.againBtn.isHidden  = true
            self.nextBtn.isHidden = true
            self.circleImageView.isHidden  = true
            self.tipLabel.text = "点击开始录制"
            self.recordButton.isUserInteractionEnabled = true
            self.recordButton.setImage(UIImage(named: "mic"), for: .normal)
            self.sweetRuler!.setSelectFigure(figure: 0)
        }
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        self.play()
    }
    @objc func pop(){
        timer?.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func changeFrame(){
        UIView.animate(withDuration: self.updateFequency) {
            let frame = self.imageline?.frame
            let originx = (frame?.origin.x)! + eachJumpoffset
            if originx > kSCREEN_WIDTH * 0.5 - self.redImageWidth*0.5{
                //使imageline刚好停留在中间的位置
                if self.imageline?.center.x !=  kSCREEN_WIDTH * 0.5{
                    self.imageline?.center.x =  kSCREEN_WIDTH * 0.5
                }
                self.sweetRuler?.changeOffset(eachOffset: eachJumpoffset)
                self.collectionView.contentOffset.x =  self.collectionView.contentOffset.x + eachJumpoffset
                return
                
            }
            
            self.imageline?.frame =  CGRect(x: originx, y: (frame?.origin.y)!, width: (frame?.size.width)!, height: (frame?.size.height)!)
        }
    }
    
    //播放
    func play() {
        
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setActive(true)
            try session.setCategory(.playback)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            try audioPlayer = AVAudioPlayer(contentsOf: soundFileURL!, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer.prepareToPlay()
            audioPlayer.delegate = self
            audioPlayer.volume = 1
            audioPlayer.numberOfLoops = 1
            audioPlayer.play()
        } catch{
            print(error)
        }
    }
 
    @objc  func stopPlay()  {
        
        audioPlayer.stop()
        
    }

    
    
}
// MARK: UICollectionView 代理事件
extension VoiceSampleViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: layoutWidth, height: collectionView.frame.size.height)
    
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let arr = soundMeters else {
            return 0
        }
        return arr.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard soundMeters != nil else {
            return 0
        }
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! VoiceCollectionViewCell
        cell.soundMeters = [soundMeters[indexPath.row]]
        return cell
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isRecording{
//            print("scrollView.contentOffset.x:\(scrollView.contentOffset.x)")
            if (scrollView.contentOffset.x > 0){
            sweetRuler?.scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x,y: (sweetRuler?.scrollView.contentOffset.y)!), animated: false)
            }
        }
    }
    
}

// MARK: - Record handlers
extension VoiceSampleViewController: AVAudioRecorderDelegate {
    
    /// 开始录音
    @objc private func beginRecordVoice() {
        if isRecording {
            self.endRecordVoice()
        }else{
            if recorder == nil {
                return
            }
            recorder.record()
            timer = Timer.scheduledTimer(timeInterval: updateFequency, target: self, selector: #selector(updateMeters), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
            RunLoop.current.run()
        }
    }
    
    /// 停止录音
    @objc private func endRecordVoice() {
        timer?.invalidate()
        recorder.stop()
    }
    
    /// 取消录音
    @objc private func cancelRecordVoice() {
        endRecordVoice()
        recorder.deleteRecording()
    }
    
    /// 上划取消录音
    @objc private func remindDragExit() {

    }
    
    /// 下滑继续录音
    @objc private func remindDragEnter() {

    }
    
    @objc private func updateMeters() {
        isRecording = true
        recorder.updateMeters()
        recordTime += updateFequency
        addSoundMeter(item: recorder.averagePower(forChannel: 0))
        self.changeFrame()
        timeLabel.text = String(format: "00:%02d",Int(recordTime))
        if recordTime >= maxTime{
            endRecordVoice()
        }
    }
    
    private func addSoundMeter(item: Float) {
        if soundMeters.count < soundMeterCount {
            soundMeters.append(item)
            self.collectionView.reloadData()
        }
    }
}

//MARK: - AVAudioRecorderDelegate
extension VoiceSampleViewController {

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if recordTime > 1.0 {
            if flag {
                do {
                    let exists = try recorder.url.checkResourceIsReachable()
                    if exists {
                        print("finish record")
                    }
                }
                catch { print("fail to load record")}
            } else {
                print("record failed")
            }
        }
        isRecording = false
        recordTime = 0
    }
}

// MARK: - Setup
extension VoiceSampleViewController {
    
    private func setupButtonEvent() {
        recordButton.addTarget(self, action: #selector(beginRecordVoice), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(cancelRecordVoice), for: .touchUpOutside)
        recordButton.addTarget(self, action: #selector(cancelRecordVoice), for: .touchCancel)
        recordButton.addTarget(self, action: #selector(remindDragExit), for: .touchDragExit)
        recordButton.addTarget(self, action: #selector(remindDragEnter), for: .touchDragEnter)
    }
    
    private func configAVAudioSession() {
        let session = AVAudioSession.sharedInstance()
        
        do { try session.setCategory(.record,options: .defaultToSpeaker) }
        catch { print("session config failed") }
    }
    
    private func configRecord() {
        AVAudioSession.sharedInstance().requestRecordPermission { (allowed) in
            if !allowed {
                return
            }
        }
        let session = AVAudioSession.sharedInstance()
        do { try  session.setCategory(.record ,options: .defaultToSpeaker) }
        catch { print("session config failed") }
        do {
            self.recorder = try AVAudioRecorder(url: self.directoryURL()!, settings: self.recorderSetting)
            self.recorder.delegate = self
            self.recorder.prepareToRecord()
            self.recorder.isMeteringEnabled = true
        } catch {
            print(error.localizedDescription)
        }
        do { try AVAudioSession.sharedInstance().setActive(true) }
        catch { print("session active failed") }
    }
    
   
    private func directoryURL() -> URL? {
    //定义并构建一个url来保存音频，音频文件名为recording-yyyy-MM-dd-HH-mm-ss.m4a
        //根据时间来设置存储文件名
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.string(from: Date())).m4a"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        print(soundFileURL as Any)
        return soundFileURL
    }
    
    fileprivate func configRulerUI() {
        sweetRuler = SweetRuler(frame: CGRect(x: 0, y: 64, width: kSCREEN_WIDTH, height: 30))
        view.addSubview(sweetRuler!)
        sweetRuler!.isUserInteractionEnabled = false
        sweetRuler!.figureRange = Range(uncheckedBounds: (0, 24000))
        sweetRuler!.setSelectFigure(figure: 0)
        sweetRuler!.delegate = self
    }
    
    fileprivate func configVolumnScaleUI() {
        volumnScale = VolumeScaleView(frame: CGRect(x: kSCREEN_WIDTH - 40, y:94 , width: 30, height: kSCREEN_HEIGHT * 0.6 - 94))
        view.addSubview(volumnScale!)
    }
    fileprivate func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = layoutminimumLineSpacing
        layout.scrollDirection = .horizontal
        self.collectionView = VoicesamplingCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.view.addSubview(self.collectionView)
        self.collectionView.delegate = self as UICollectionViewDelegate
        self.collectionView.dataSource = self as UICollectionViewDataSource
        self.collectionView.register(VoiceCollectionViewCell.self, forCellWithReuseIdentifier: "cellid")
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.sweetRuler!.bottomAnchor).isActive = true
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kSCREEN_WIDTH*0.5)
        self.collectionView.backgroundColor = UIColor(red: 42/255.0, green: 43/255.0, blue: 47/255.0, alpha: 1)
    }
    
    fileprivate func configRedlineImage() {
        let image = UIImage(named: "红色竖线")
        redImageWidth = CGFloat(imagescale) * (kSCREEN_HEIGHT * 0.6 - 64)
        //添加imageview 随着时间往后移动
        imageline = UIImageView(image: image)
        imageline?.frame = CGRect(x: 0, y: 64, width: redImageWidth, height: kSCREEN_HEIGHT * 0.6 - 64)
        self.view.addSubview(imageline!)
    }
    
   
}
