classdef bezier
    properties
        point
        resolution = 0.01;
        t
        num
        curves
    end
    methods
        function obj = bezier()
            obj.t = (0:obj.resolution:1);
            obj.num = (1:1:101);
        end
        function plotPoint(obj)
            pointSize = size(obj.point);
            for n = 1:pointSize(2)
                plot(obj.point(1,n),obj.point(2,n),'-o');
                str = strcat('  p',num2str(n));
                text(obj.point(1,n),obj.point(2,n),str);
                hold on
            end
            if isempty(n)
                plot(0,0);
            end
        end
        function plotCurve(obj)
            curveSize = size(obj.curves);
            for n = 1:curveSize(1)/2
                plot(obj.curves(2*n-1,obj.num),obj.curves(2*n,obj.num))
                hold on
            end
        end
        function line = makeLine(obj,x1,y1,x2,y2)
            x = (1-obj.t(obj.num)) * x1 + obj.t(obj.num) * x2;
            y = (1-obj.t(obj.num)) * y1 + obj.t(obj.num) * y2;
            line = [x;y];
        end
        function line = makeLine2(obj,point0,point1)
            line = makeLine(obj,point0(1,1),point0(2,1),point1(1,1),point1(2,1));
        end
        function curve = makeCurve(obj,line0,line1)
            x = (1-obj.t(obj.num)) .* line0(1,obj.num) + obj.t(obj.num) .* line1(1,obj.num);
            y = (1-obj.t(obj.num)) .* line0(2,obj.num) + obj.t(obj.num) .* line1(2,obj.num);
            curve = [x;y];
        end
        function obj = makeBezi(obj)
            pointSize = size(obj.point);
            for n = 1:pointSize(2)-1
                x = (1-obj.t(obj.num)) * obj.point(1,n) + obj.t(obj.num) * obj.point(1,n+1);
                y = (1-obj.t(obj.num)) * obj.point(2,n) + obj.t(obj.num) * obj.point(2,n+1);
                obj.curves(2*n-1,:) = x;
                obj.curves(2*n,:) = y;
            end
            obj.plotCurve;
            curveSize = size(obj.curves);
            for n = 1:curveSize(1)/2-1
                for m = 1:curveSize(1)/2-1
                    curve0(1,:) = obj.curves(2*m-1,:);
                    curve0(2,:) = obj.curves(2*m,:);
                    curve1(1,:) = obj.curves(2*m+1,:);
                    curve1(2,:) = obj.curves(2*m+2,:);
                    curve2 = obj.makeCurve(curve0,curve1);
                    obj.curves(2*m-1,:) = curve2(1,:);
                    obj.curves(2*m,:) = curve2(2,:);
                end
                obj.curves(end-1,:) = [];
                obj.curves(end,:) = [];
                curveSize = size(obj.curves);
            end
            obj.plotCurve;
            obj.plotPoint;
            hold off
        end
        function obj = addPoint(obj,x,y)
            obj.point(:,end+1) = [x;y];
        end
        function obj = addNextPoint(obj,pNum,x,y)
            obj = obj.addBeforePoint(pNum+1,x,y);
            pointSize = size(obj.point);
            pointSize = pointSize(2);
            if 0 < pNum && pNum <= pointSize
                for n = pointSize:-1:pNum+1
                    obj.point(:,n+1) = obj.point(:,n);
                end
                obj.point(:,pNum+1) = [x;y];
            end
        end
        function obj = addBeforePoint(obj,pNum,x,y)
            pointSize = size(obj.point);
            pointSize = pointSize(2);
            if 0 < pNum && pNum <= pointSize
                for n = pointSize:-1:pNum
                    obj.point(:,n+1) = obj.point(:,n);
                end
                obj.point(:,pNum) = [x;y];
            end
        end
        function obj = clearPoint(obj,pNum)
            pointSize = size(obj.point);
            pointSize = pointSize(2);
            if 0 < pNum && pNum <= pointSize
                obj.point(:,pNum) = [];
            end
        end
        function obj = changePoint(obj,pNum,x,y)
            pointSize = size(obj.point);
            pointSize = pointSize(2);
            if 0 < pNum && pNum <= pointSize
                obj.point(:,pNum) = [x;y];
            end
        end
    end
end