//import SpriteKit
//
//class CountdownLabel: SKLabelNode{
//
//    var endTime:Date!
//
//    func update(){
//        //convert remaining time to an integer
//        let timeLeftInteger = Int(timeLeft())
//        //update the label text, converting the Int to a String
//        text = String(timeLeftInteger)
//    }
//
//    func startWithDuration(duration: TimeInterval){
//        let timeNow = Date();
//        endTime = timeNow.addingTimeInterval(duration)
//    }
//
//    func hasFinished() -> Bool{
//
//        return timeLeft() == 0;
//    }
//
//    private func timeLeft() -> TimeInterval{
//
//        let now = Date();
//        let remainingSeconds = endTime.timeIntervalSince(now)
//        return max(remainingSeconds, 0)
//    }
//
//
//}
