function sample = zen_read_csv_data(csv_file)
%
% load data from a CSV file.
% W. Feng, 2014-04-26

if nargin == 0,
    csv_file = 'Log_DC401759_140426_6f128.csv';
end

%mtx = readtable(csv_file, 'delimiter', ',');
%saveto = [csv_file(1:end-4), '.mat'];
%save(saveto, 'mtx');

loadfrom = [csv_file(1:end-4), '.mat'];
load(loadfrom, 'mtx');

sample = zen_get_samples(mtx);

return;
