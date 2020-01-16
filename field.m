classdef field
    properties
        lineXt
        lineYt
    end
    methods
        function obj = field() 
            obj.lineXt = cast(obj.lineXt,'sym');
            obj.lineYt = cast(obj.lineYt,'sym');
        end
        function obj = addLine(obj,x1,y1,x2,y2)
            syms t;
            obj.lineXt(end+1) = (1-t)*x1 + t*x2;
            obj.lineYt(end+1) = (1-t)*y1 + t*y2;
        end
        function obj = addSquare(obj,x1,y1,x2,y2)
            obj = obj.addLine(x1,y1,x1,y2);
            obj = obj.addLine(x1,y2,x2,y2);
            obj = obj.addLine(x2,y2,x2,y1);
            obj = obj.addLine(x2,y1,x1,y1);
        end
        function allPlot(obj)
            ax = gca;
            delete(ax);
            hold on;
            lineSize = size(obj.lineXt);
            lineSize = lineSize(2);
            for n = 1:lineSize
                fplot(obj.lineXt(n),obj.lineYt(n),[0 1]);
            end
            hold off;
        end
    end
end