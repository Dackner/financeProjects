function res = interpolation(data, delta)
    res= zeros(data(end,1)/delta, 2);
    res(:,1) = delta:delta:data(end,1);
    res(1:1/delta,2)=data(1 ,2);
    for i=1:size(data,1)
        res(find(res(:,1)==data(i,1)),2)=data(i,2);
    end
    for i=1/delta+1:length(res)
       j = find(res(i:end,2),1)+i-1;
       a=res(i-1,2);
       b=res(j,2);
       res(i,2) = a*(res(j,1)-res(i,1))/(res(j,1)-res(i-1,1)) + b*delta/(res(j,1)-res(i-1,1));
    end
end

