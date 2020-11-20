function cons = qam(value)
    cons = [];
    
    bound = log(value)/log(4);
    floorbound = floor(bound);
    square = 2*floor(sqrt(value)/2);
    deci = bound - floorbound;

    for row =  (0:2:(2*square - 1)) 
        for col = (0:2:(2*square+(16*deci)-1))
            cons = [cons (row - square + 1 +1j - square*j - 8*deci*j + col*1j)];
        end
    end
end
