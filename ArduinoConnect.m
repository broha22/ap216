classdef ArduinoConnect
    
    properties
        s = 0; %initialize empty property to store serial connection
    end
    
    methods
        function out = open(obj, port, baud)
            %get comm ready
            instrreset
            delete(instrfindall)
            %initialize the serial connection
            obj.s = serial(port, 'Baudrate', baud);
            %set new line to end of serial command
            obj.s.Terminator = 'LF';
            %open the serial connection
            fopen(obj.s);
            %wait for connection open
            pause(3);
            %returnnew connected object
            out = obj;
        end
        
        function outputArg = read(obj)
            %clear comm
            flushinput(obj.s);
            flushoutput(obj.s);
            %send the read command to the arduino
            fprintf(obj.s,'1');
            %return the arduinos response
            outputArg = fscanf(obj.s);
        end
        function close(obj)
            fclose(obj.s);
            delete(obj.s);
            clear obj.s;
        end
    end
end

