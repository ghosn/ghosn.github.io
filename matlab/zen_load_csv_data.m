function sample = zen_load_csv_data(csv_file)
%
% load data from a CSV file.
% W. Feng, 2014-04-26

if nargin == 0,
    csv_file = 'E:\code\Leaf2014\LeafData\Log_DC401759_140426_6f128.csv';
end

mtx = readtable(csv_file, 'delimiter', ',');

AHr = mtx.AHr;
AHr = AHr./(10.^(ceil(log10(AHr))-2));
SOC = mtx.SOC;
SOC = SOC./(10.^(ceil(log10(SOC))));

Eres = AHr.*360.*SOC;
% dt = mtx.Date_Time;
% for idx = 1:length(dt),
%     ddtt = textscan(dt{idx}, '%s %s');
%     date{idx} = ddtt{1};
%     time{idx} = ddtt{2};
% end

Lat = mtx.Lat;
Long = mtx.Long;
Lat = IL_convert_lat_long(Lat);
Long = IL_convert_lat_long(Long);

speed = mtx.Speed;
charge_mode = mtx.ChargeMode;
b_driving = IL_detect_driving(speed, charge_mode, Eres);
b_driving(1:2) = 0; % first 2 samples, throw away for sure
b_driving = logical(b_driving);

Eres_v = Eres(b_driving);
Lat_v = Lat(b_driving);
Long_v = Long(b_driving);
start_pt = [Lat_v(1:end-1), Long_v(1:end-1)];
end_pt = [Lat_v(2:end), Long_v(2:end)];

R_earth = 7918/2; % miles
[arc, az] = distance('gc', [Lat_v(1:end-1), Long_v(1:end-1)], [Lat_v(2:end), Long_v(2:end)]);
dist = 2*pi*R_earth.*arc/360;

dE = Eres_v(2:end)-Eres_v(1:end-1);


%figure; plot(dist, Eff);

sample = [start_pt, end_pt, dE];

return;


function b_driving = IL_detect_driving(speed, charge_mode, Eres)
% 
N_parking = 30;

b_driving = ones(length(speed), 1);
b_driving(charge_mode~=0) = 0;

dE = [0;Eres(2:end)-Eres(1:end-1)];
b_driving(dE==0) = 0;

idx = find(speed == 0, 1, 'first');
while ~isempty(idx),
    idx = idx+1; % skip one 
    % find the next non-zero element
    speed_cpy = speed;
    speed_cpy(1:idx-1) = 0;
    idx_next = find(speed_cpy ~= 0, 1, 'first');
    if ~isempty(idx_next),
        idx_next = idx_next - 1;
        if idx_next - idx > N_parking
            b_driving(idx:idx_next-1) = 0;
        end
        speed(1:idx_next) = 1; % mask the processed segment
    else
        b_driving(idx:end) = 0;
        break;
    end
    
    idx = find(speed==0, 1, 'first');
end

return;


function lat_d = IL_convert_lat_long(Lat)
%
% convert text Lat/long to real numbers in degrees
lat_d = zeros(length(Lat),1);
for idx = 1:length(Lat),
    cl = Lat{idx};
    if isempty(cl),
        lat_d(idx) = NaN;
        continue;
    end
    dgrmin = textscan(cl, '%f%f', 'delimiter', ':');

    lat_d(idx) = dgrmin{1}+sign(dgrmin{1}).*dgrmin{2}/60;
end
return;
