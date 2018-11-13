function m = couponFreqNum(cFreq)

%COUPONFREQNUM returns the parameter m representing coupon payments per year.

n = length(cFreq);
m = ones(n,1);
for i = 1:n
    
    if cFreq{i} == 'ANNUAL  ' 
       m(i) = 1; 
    end
    %TODO: other freqs
    
end

end

