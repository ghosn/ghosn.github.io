function zen_write_json(sample, saveto)
%

fid = fopen(saveto, 'wt');
fprintf(fid, '{\n');
fprintf(fid, '"nodes": [\n');
for idx = 1:size(sample, 1),
    cs = sample(idx, :);
    if any(isnan(cs)),
        continue;
    end
    fprintf(fid, '{\n');
    fprintf(fid, '"Long1": %f,\n', cs(2));
    fprintf(fid, '"Lat1": %f,\n', cs(1));
    fprintf(fid, '"Long2": %f,\n', cs(4));
    fprintf(fid, '"Lat2": %f,\n', cs(3));
    fprintf(fid, '"Eff": %f\n', cs(5));
    if idx ~= size(sample, 1)
        fprintf(fid, '},\n');
    else
        fprintf(fid, '}\n');
    end
end
fprintf(fid, ']\n');
fprintf(fid, '}\n');
fclose(fid);
end
