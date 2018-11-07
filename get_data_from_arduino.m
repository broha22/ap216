%clear all com ports
instrreset
delete(instrfindall)

%create serial object
s = serial('COM4', 'Baudrate', 2000000);
%set end of string terminator to '\n'
s.Terminator = 'LF';

%open communication with serial object
fopen(s);

%opening communication with the arduino resets its
%USB driver. Must wait for that to reboot
pause(3);

data = 1:1:100;
t = 1:1:100;
data = zeros(size(data));

while (1)
    d = get_data(s);
    n = str2num(d);
    data = add_data(data, n);
    
    pause(0.1);
    plot(t, data);
    axis([0, 100, 0, 255])
    
end

%close comunication
fclose(s);
delete(s);
clear s;

function data = get_data(s);
    
    %clear com port
    flushinput(s);
    flushoutput(s);
    
    %ask Arduino for data
    fprintf(s,'send_data');
    
    %read data from Arduino
    data = fscanf(s);
end


function data_out = add_data(data_in, new_elmnt)
    
    %set number of iterations
    n = 99;
    
    %shift data in matrix up by 1
    while n > 0
        data_in(n+1) = data_in(n);
        n = n - 1;
    end

    %add new element
    data_in(1) = new_elmnt;
    
    %return new matrix
    data_out = data_in;
end


