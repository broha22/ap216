instrreset
delete(instrfindall)
s = serial('COM4', 'Baudrate', 9600);
s.Terminator = 'LF';

fopen(s);
pause(3);


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

function data = get_data(s)
    %ask Arduino for data
    flushinput(s);
    flushoutput(s);
    fprintf(s,'1');
    
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


