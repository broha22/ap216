%==== Main Script ====%

%set up data structures
global photo_res 
photo_res = Queue;
global therm_res 
therm_res = Queue;
global linear_q
linear_q = Queue;
global stein_q
stein_q = Queue;
global avg_q
avg_q = Queue;

%set up arduino
%list serial ports to user
disp('Ports available: ') 
disp(seriallist)

%prompt them to choose a port to use
prompt = '\nChoose a serial port to use: ';
com_port = input(prompt, 's');

global arduino
arduino = ArduinoConnect;
arduino = arduino.open(com_port, 9600);

%set up timer, 0.1s periodic call
mainLoop = timer;
mainLoop.period = 0.1;
mainLoop.TimerFcn = @ExecuteCycle;
mainLoop.ExecutionMode = 'fixedSpacing';

%start timer
start(mainLoop)

function ExecuteCycle(~,~)
    %initialize global refs
    global photo_res
    global therm_res
    global linear_q
    global stein_q
    global avg_q
    global arduino
    
    %request Arduino Data
    out = strsplit(arduino.read(), ',');    %split comma delimitted string into cell array
    out = str2double(out);                  %change cell array into double array
    photo_r = out(2);                       %store photoresistor resistance
    temp_r = out(1);                        %store temperature resistance
    
    %put data into structures
    photo_res = photo_res.add(photo_r);
    therm_res = therm_res.add(temp_r);
    stein_temp = calc_stein(temp_r);
    stein_q = stein_q.add(stein_temp);
    linear_temp = calc_linear(temp_r);
    linear_q = linear_q.add(linear_temp);
    avg_q = avg_q.add((stein_temp + linear_temp)/2);
    
    %plot data structures
    subplot(2,1,1);
    plot(photo_res.read())
    hold on;                                    %plot on the same graph
    plot(therm_res.read())
    hold off;                                   %end of plots for graph one
    legend({'Photoresistor', 'Thermistor'})
    title('Resistance Values')
    subplot(2,1,2);
    plot(stein_q.read())
    hold on;                                    %plot on same graph
    plot(linear_q.read())
    plot(avg_q.read())
    hold off;                                   %end of plots for second graph
    legend({'Steinhart Model', 'Linear Model', 'Average'})
    title('Temperature Values')
    drawnow;                                    %force drawing instantly
end

function output = calc_stein(r_val)
    %steinhart coefficients
     a_co = 0.00277904;
     b_co = -0.00000692823;
     c_co = 0.000000889873;
     
     %steinhart formula
     output = 1.0 / (a_co + b_co * log(r_val) + c_co * (log(r_val))^3);
end
 
function output = calc_linear(r_val)
     %linear approximation based on testing
     output = 317.724 - 0.00148957 * r_val;
end

%=== Models were Based on the following table ===%
% ------------------------------------
% Degrees (Kelvin) | Resistance (Ohms)
% ------------------------------------
%          272.150 |         30595.23
%          289.817 |         11952.79
%          312.778 |          3320.31

