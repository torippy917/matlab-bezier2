classdef bezier
    properties
        point
        xt
        yt
        vt
        maxVt
        distMax
        distMin
        tResolution
        numberPoints
        rootDistnace
    end
    methods
        function obj = bezier()
            
        end
        function plotPoint(obj)
            pointSize = size(obj.point);
            for n = 1:pointSize(2)
                plot(obj.point(1,n),obj.point(2,n),'-o');
                str = strcat('  p',num2str(n));
                text(obj.point(1,n),obj.point(2,n),str);
            end
            if isempty(n)
                plot(0,0);
            end
        end
        function plotCurve(obj)
            if isempty(obj.xt)||isempty(obj.yt)
                disp('there isn''t curve');
            else
                fplot(obj.xt(1),obj.yt(1),[0 1]);
            end
        end
        function obj = makeBezi(obj)
            ax = gca;
            delete(ax);
            hold on;
            syms t;
            pointSize = size(obj.point);
            obj.xt = cast(obj.point(1,:),'sym');
            obj.yt = cast(obj.point(2,:),'sym');
            for n = 1:pointSize(2)-1
                for m = 1:pointSize(2)-n
                    obj.xt(m) = (1-t)*obj.xt(m) + t*obj.xt(m+1);
                    obj.yt(m) = (1-t)*obj.yt(m) + t*obj.yt(m+1);
                end
                obj.xt(end) = [];
                obj.yt(end) = [];
                if n == 1
                    for m = 1:pointSize(2)-1
                        fplot(obj.xt(m),obj.yt(m),[0 1]);
                    end
                end
            end
            obj.plotCurve;
            obj.plotPoint;
            setFig();
            hold off;
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
        function obj = calcResolution(obj,lenResolution)
            f = sqrt(diff(obj.xt).^2 + diff(obj.yt).^2);
            obj.rootDistnace = vpaintegral(f,[0 1]);
            obj.numberPoints = obj.rootDistnace / lenResolution;
            obj.tResolution = 1 / (obj.numberPoints);
            obj.rootDistnace = cast(obj.rootDistnace,'double');
            obj.numberPoints = cast(obj.numberPoints,'double');
            obj.tResolution = cast(obj.tResolution,'double');
        end
        function obj = calcResolution2(obj,lenResolution)
            syms vt1(t);
            syms vt2(t);
            syms vt3(t);
            assume(t,'real');
            obj.vt = sqrt(diff(obj.xt).^2 + diff(obj.yt).^2);
            vt1(t) = obj.vt;
            vt2(t) = diff(obj.vt);
            vt3(t) = diff(vt2);
            buf = limit(obj.vt,t,0,'right');
            buf = [buf limit(obj.vt,t,1,'left')];
            for n = solve(vt2 == 0,t)
                if vpa(vt3(n)) < 0
                    buf = [buf vt1(n)]; %#ok<AGROW>
                end
            end
            obj.maxVt = cast(max(buf),'double');
            obj.tResolution = cast(lenResolution / obj.maxVt,'double');
            obj.numberPoints = cast(1/obj.tResolution,'double');
        end
        function obj = calcMaxDistance(obj)
            obj.distMax = 0;
            syms x(t);
            syms y(t);
            syms distF(t1,t2);
            x(t) = obj.xt;
            y(t) = obj.yt;
            distF(t1,t2) = sqrt((x(t2)-x(t1)).^2 + (y(t2)-y(t1)).^2);
            n = 0:obj.tResolution:1-obj.tResolution;
            dist = distF(n,n+obj.tResolution);
            obj.distMax = max(dist);
            obj.distMax = cast(obj.distMax,'double');
        end
        function obj = calcMinDistance(obj)
            obj.distMin = inf;
            syms x(t);
            syms y(t);
            syms distF(t1,t2);
            x(t) = obj.xt;
            y(t) = obj.yt;
            distF(t1,t2) = sqrt((x(t2)-x(t1)).^2 + (y(t2)-y(t1)).^2);
            n = 0:obj.tResolution:1-obj.tResolution;
            dist = distF(n,n+obj.tResolution);
            obj.distMin = min(dist);
            obj.distMin = cast(obj.distMin,'double');
        end
    end
end