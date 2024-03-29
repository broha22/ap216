classdef Queue
    properties
        data(1,100) = 0; %initialize an array of 100 0s
        currentIndex = 1;
    end
    methods
        function output = add(obj, value)
            obj.data(obj.currentIndex) = value;      %set the currentIndex value to the add value
            obj.currentIndex = obj.currentIndex + 1; %increase the index to the next spot in the array
            if (obj.currentIndex > 100)              %if the index goes out of the bounds reset it
                obj.currentIndex = 1;
            end
            output = obj;                            %return the new object with added data
        end
        function outputArg = read(obj)
            %When read value at currentIndex is the oldest value
            %currentIndex - 1, is the newest value
            %the expected result is a chronological array
            %to achieve this the array is split at current index
            %the lower half's indexes are flipped, and the upper half's
            %indexes are flipped
            outputArg = [fliplr(obj.data(1:obj.currentIndex-1)) fliplr(obj.data(obj.currentIndex:100))];
        end
    end
end