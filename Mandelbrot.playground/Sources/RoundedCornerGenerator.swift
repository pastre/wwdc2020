import CoreGraphics


enum Path_command{
    case path_move_to
    case path_line_to
}

public class RoundedCornerGenerator {


    static func sqr (_ a: CGFloat) -> CGFloat
    {
        return a * a
    }





    static func positive_angle (angle: CGFloat ) -> CGFloat
    {
        return angle < 0 ? angle + 2 * CGFloat.pi : angle
    }





    static func add_corner ( path: CGMutablePath,  p1: CGPoint,  p: CGPoint,  p2: CGPoint,  radius r : CGFloat,  first_add: Path_command)
    {
        var radius = r
        var angle: CGFloat = positive_angle (angle: CGFloat(atan2 (p.y - p1.y, p.x - p1.x) - atan2 (p.y - p2.y, p.x - p2.x)))

        // 3
        var segment: CGFloat = radius / abs (tan (angle / 2))
        var p_c1: CGFloat = segment
        var p_c2: CGFloat = segment

        // 4
        var p_p1: CGFloat = sqrt (sqr (p.x - p1.x) + sqr (p.y - p1.y))
        var p_p2: CGFloat = sqrt (sqr (p.x - p2.x) + sqr (p.y - p2.y))
        var _min: CGFloat = min(p_p1, p_p2)
        if (segment > _min) {
            segment = _min
            radius = segment * abs(tan (angle / 2))
        }

        // 5
        var p_o: CGFloat = sqrt (sqr (radius) + sqr (segment))

        // 6
        var c1 = CGPoint(x: (p.x - (p.x - p1.x) * p_c1 / p_p1), y: (p.y - (p.y - p1.y) * p_c1 / p_p1))
        

        //  7
        var c2 = CGPoint(x: (p.x - (p.x - p2.x) * p_c2 / p_p2), y: (p.y - (p.y - p2.y) * p_c2 / p_p2))
        

        var dx: CGFloat = p.x * 2 - c1.x - c2.x
        var dy: CGFloat = p.y * 2 - c1.y - c2.y

        var p_c: CGFloat = sqrt (sqr (dx) + sqr (dy))

        var o = CGPoint(x: p.x - dx * p_o / p_c, y: p.y - dy * p_o / p_c)
        
        var start_angle: CGFloat = positive_angle (angle: atan2 ((c1.y - o.y), (c1.x - o.x)))
        var end_angle: CGFloat = positive_angle (angle: atan2 ((c2.y - o.y), (c2.x - o.x)))


        if (first_add == .path_move_to) {
            path.move(to: c1)
        }
        else {
            path.addLine(to: c1)
        }
        path.addArc(center: o, radius: radius, startAngle: start_angle, endAngle: end_angle, clockwise: angle > .pi)
        
    }

    public static func path_with_rounded_corners (points: [CGPoint],  corner_radius: CGFloat) -> CGMutablePath
    {
        let path = CGMutablePath()
        
        var count = points.count
        for i in 0..<count {
            
            let prev = points[i > 0 ? i - 1 : count - 1]
            let p = points[i]
            let  next = points[i + 1 < count ? i + 1 : 0]
            
            RoundedCornerGenerator.add_corner (path: path, p1: prev, p: p, p2: next, radius: corner_radius, first_add: i == 0 ? .path_move_to : .path_line_to)
        }
        
        return path
    }
}
