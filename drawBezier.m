function bezi = drawBezier
bezi = bezier;
prompt = '>>>';
plot(0,0);
while(1)
    argv = strsplit(input(prompt,'s'));
    argc = size(argv);
    argc = argc(2);
    if argc >= 1
        command = cell2mat(argv(1));
        argv(1) = [];
        if(strcmp(command,'end'))
            break;
            
        elseif strcmp(command,'add')
            if argc >= 3
                numbers = str2double(argv);
                bezi = bezi.addPoint(numbers(1),numbers(2));
            else
                disp('Too few value(need 2 numbers)')
            end
            
        elseif strcmp(command,'addNext')
            if argc >= 4
                numbers = str2double(argv);
                pNum = numbers(1);
                pointSize = size(bezi.point);
                pointSize = pointSize(2);
                if 0 < pNum && pNum <= pointSize
                    numbers = str2double(argv);
                    bezi = bezi.addNextPoint(pNum,numbers(2),numbers(3));
                else
                    str = 'There is no point of the number';
                    disp(str);
                end
            else
                disp('Too few value(need 3 numbers)')
            end
            
        elseif strcmp(command,'addBefore')
            if argc >= 4
                numbers = str2double(argv);
                pNum = numbers(1);
                pointSize = size(bezi.point);
                pointSize = pointSize(2);
                if 0 < pNum && pNum <= pointSize
                    numbers = str2double(argv);
                    bezi = bezi.addBeforePoint(pNum,numbers(2),numbers(3));
                else
                    disp('There is no point of the number');
                end
            else
                disp('Too few value(need 3 numbers)');
            end
            
        elseif strcmp(command,'clear')
            if argc >= 2
                numbers = str2double(argv);
                pointSize = size(bezi.point);
                pointSize = pointSize(2);
                pNum = numbers(1);
                if 0 < pNum && pNum <= pointSize
                    bezi = bezi.clearPoint(pNum);
                else
                    disp('There is no point of the number');
                end
            else
                disp('Too few value(need 1 numbers)');
            end
            
        elseif strcmp(command,'change')
            if argc >= 4
                numbers = str2double(argv);
                pointSize = size(bezi.point);
                pointSize = pointSize(2);
                pNum = numbers(1);
                if 0 < pNum && pNum <= pointSize
                    bezi = bezi.changePoint(pNum,numbers(2),numbers(3));
                else
                    disp('There is no point of the number');
                end
            else
                disp('Too few value(need 3 numbers)');
            end
            
        elseif strcmp(command,'load')
            if argc >= 2
                beziBuf = importdata(cell2mat(argv(1)));
                bezi.point = beziBuf.point;
            end
            
        elseif strcmp(command,'save')
            if argc >= 2
                fileName = cell2mat(argv(1));
                save(fileName,'bezi');
            end
        else
            disp(strcat(command,':command not found'));
        end
    end
    bezi = bezi.makeBezi;
end
end