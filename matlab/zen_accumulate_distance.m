function samples_avg = zen_accumulate_distance(samples, DST)
%

samples_avg = [];

idx = 1;

while idx < size(samples, 1),
    start_pt = samples(idx, :);
    E = 0;
    dist = 0;
    
    while dist < DST,
        cs = samples(idx,:);
        if isnan(cs(1)),
            idx = idx + 1;
            break;
        end
        ns = samples(idx+1,:);
        c_dist = cs(6);
        if any(cs(3:4)-ns(1:2)), % a break to another car
            idx = idx + 1;
            break;
        end
        dist = dist + c_dist;
        E = E + cs(5);
        
        if idx>=size(samples, 1)-1,
            idx = idx + 1;
            break;
        end
        idx = idx + 1;
    end
    end_pt = samples(idx-1, :);
    
    
    if isnan(dist./E)
        continue;
    else
        samples_avg = [samples_avg; [start_pt(1:2), end_pt(1:2), dist./E]];
    end
    
end

stophere = 1;

