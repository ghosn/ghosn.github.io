% read all csv data and save them to matlab format
ddir = 'E:\code\Leaf2014\LeafData';
ll = dir(ddir);
cd(ddir);
samples = [];
for idx = 3:length(ll),
%for idx = 3:40,
    c_f = ll(idx).name;
    if strcmpi(c_f(end-3:end), '.mat'),
        %try
            samples = [samples; zen_read_csv_data(c_f)];
        %catch
        %    fprintf(1, '%s\n', c_f);
        %end
    end
end


DST = 0.5;
% now accumulate the distance and reduce # of samples
samples_avg = zen_accumulate_distance(samples(:, :), DST);
tmp = samples_avg(:, 5);
tmp(tmp<0) = 20;
tmp(tmp>10) = 20;
%tmp(isnan(tmp)) = 10;
samples_avg(:,5) = tmp;

saveto = fullfile(ddir, 'aggregate.json');
zen_write_json(samples_avg, saveto);

