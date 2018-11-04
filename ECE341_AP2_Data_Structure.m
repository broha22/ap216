%The data matix holds 100 elements. 10s of data, 10 data points per sec.
%The newest data points are added to the front of the matrix
%Add values to the matix using the function 'add_data'. Pass it the current
%matrix and the new element, and it returns the new matrix with the new
%element at the front



%********** EXAMPLE PROGRAM *********** 

%create a matrix and set all elements to 0
%NOTE: the matrix must go from 1 to 100. Other indices will not work
data = 1:1:100;
data = zeros(size(data));

%add values to the matrix
data = add_data(data, 5);
data = add_data(data, 8);

%print values within the matix
disp(data(1))
disp(data(2))
disp(data(3))
disp(data(4))

%******** END EXAMPLE PROGRAM ********* 



%****************************************************
%* Function: add_data
%* Description: Shifts each element up by 1 and
%*              adds a new element to the front
%*              of the matrix
%* Input: data_in - the current matrix
%*        new_elmnt - the new element to add
%* Output: data_out - the new matrix with new_elmnt
%*                    at the beginning of the matrix
%****************************************************
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