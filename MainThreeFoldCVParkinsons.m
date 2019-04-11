% Import Data
fid = fopen('parkinsons.data');
C = textscan(fid,'%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','delimiter',','); 
fclose(fid);

% Import data dimana 
% Colom 1 adalah ASCII subject name and recording number
% C18 adalah Health status of the subject (one) - Parkinson's, (zero) - healthy
% Lainnya Input Attribut

% normalisasi minmax
InputMinMax = [Min_Max(C{2}) Min_Max(C{3}) Min_Max(C{4}) Min_Max(C{5}) Min_Max(C{6}) Min_Max(C{7}) Min_Max(C{8}) Min_Max(C{9}) Min_Max(C{10}) Min_Max(C{11}) Min_Max(C{12}) Min_Max(C{13}) Min_Max(C{14}) Min_Max(C{15}) Min_Max(C{16}) Min_Max(C{17}) C{18} Min_Max(C{19}) Min_Max(C{20}) Min_Max(C{21}) Min_Max(C{22}) Min_Max(C{23}) Min_Max(C{24})];

% normalisasi zscore
InputZScore = [zscore(C{2}) zscore(C{3}) zscore(C{4}) zscore(C{5}) zscore(C{6}) zscore(C{7}) zscore(C{8}) zscore(C{9}) zscore(C{10}) zscore(C{11}) zscore(C{12}) zscore(C{13}) zscore(C{14}) zscore(C{15}) zscore(C{16}) zscore(C{17}) C{18} zscore(C{19}) zscore(C{20}) zscore(C{21}) zscore(C{22}) zscore(C{23}) zscore(C{24})];

% tidak di normalisasi
Input = [C{2} C{3} C{4} C{5} C{6} C{7} C{8} C{9} C{10} C{11} C{12} C{13} C{14} C{15} C{16} C{17} C{18} C{19} C{20} C{21} C{22} C{23} C{24}];

% Target 1 adalah Parkinsons, 2 adalah Sehat

% SortInput = sortrows(Input, [17 22]);
% SortInput = sortrows(InputMinMax, [17 22]);
SortInput = sortrows(InputZScore, [17 22]);

% Sehat
Health= SortInput(1:48,:);

% Kena Parkinson
Parkinsons = SortInput(49:end, :);

ParkinsonsInput = [Parkinsons(:,1:16) Parkinsons(:,18:23)];

ParkinsonsTarget = Parkinsons(:,17);

HealthInput = [Health(:,1:16) Health(:,18:23)];

HealthTarget = Health(:,17);

ParkinsonsInput = ParkinsonsInput';

ParkinsonsTarget = ParkinsonsTarget';

HealthInput = HealthInput';

HealthTarget = HealthTarget';

jumlahDataP=length(ParkinsonsTarget);

jumlahDataH=length(HealthTarget);

PI1 = ParkinsonsInput(:,1:round(jumlahDataP*(1/3)));
PI2 = ParkinsonsInput(:,round(jumlahDataP*(1/3)):round(jumlahDataP*(2/3))-1);
PI3 = ParkinsonsInput(:,round(jumlahDataP*(2/3))+1:end);

PT1 = ParkinsonsTarget(:,1:round(jumlahDataP*(1/3)));
PT2 = ParkinsonsTarget(:,round(jumlahDataP*(1/3)):round(jumlahDataP*(2/3))-1);
PT3 = ParkinsonsTarget(:,round(jumlahDataP*(2/3))+1:end);

HI1 = HealthInput(:,1:round(jumlahDataH*(1/3)));
HI2 = HealthInput(:,round(jumlahDataH*(1/3)):round(jumlahDataH*(2/3))-1);
HI3 = HealthInput(:,round(jumlahDataH*(2/3))+1:end);

HT1 = HealthTarget(:,1:round(jumlahDataH*(1/3)));
HT2 = HealthTarget(:,round(jumlahDataH*(1/3)):round(jumlahDataH*(2/3))-1);
HT3 = HealthTarget(:,round(jumlahDataH*(2/3))+1:end);

%--------------------------------------------------------------------------
% Train = 1,2 / Testing = 3
InputTrain1 = [PI1 PI2 HI1 HI2];
TargetTrain1 = [PT1 PT2 HT1 HT2];

InputTest1 = [PI3 HI3];
TargetTest1 = [PT3 HT3];

%--------------------------------------------------------------------------
% Train = 1,3 / Testing = 2
InputTrain2 = [PI1 PI3 HI1 HI3];
TargetTrain2 = [PT1 PT3 HT1 HT3];

InputTest2 = [PI2 HI2];
TargetTest2 = [PT2 HT2];

%--------------------------------------------------------------------------
% Train = 2,3 / Testing = 1
InputTrain3 = [PI2 PI3 HI2 HI3];
TargetTrain3 = [PT2 PT3 HT2 HT3];

InputTest3 = [PI1 HI1];
TargetTest3 = [PT1 HT1];


% Init var u/ Plot
Plot = [];
CellPlot = {};
legendLabel = {};
SumbuX = [];
Iterasi = 10;
trainFunction = {'trainlm', 'trainrp', 'trainbfg', 'trainscg', 'traincgb', 'traincgf', 'traincgp', 'trainoss', 'traingdx'};
% activationFunction = {'tansig', 'logsig'};
activationFunction = {'purelin'};

for i=1:length(trainFunction)
    for j=1:length(activationFunction)
        Plot = [];
        SumbuX = [];
        legendLabel{end+1} = [ trainFunction{i} ', ' activationFunction{j}];
        for n = 5:5:Iterasi
            Akurasi1 = ParkinsonsJST(InputTrain1, TargetTrain1, InputTest1, TargetTest1, n, string(activationFunction{j}), trainFunction{i});
            Akurasi2 = ParkinsonsJST(InputTrain2, TargetTrain2, InputTest2, TargetTest2, n, string(activationFunction{j}), trainFunction{i});
            Akurasi3 = ParkinsonsJST(InputTrain3, TargetTrain3, InputTest3, TargetTest3, n, string(activationFunction{j}), trainFunction{i});
            Average = (Akurasi1 + Akurasi2 + Akurasi3)/3;
            Plot = [Plot; Average];
            SumbuX = [SumbuX; n];
            disp ([ trainFunction{i} ', ' activationFunction{j} ', neuron ' num2str(n) ' = ' num2str(Average) ' persen (' num2str(Akurasi1) ', ' num2str(Akurasi2) ', ' num2str(Akurasi3) ')']);
        end
        CellPlot{end+1} = Plot;
    end
end

% Menampilkan Plot
ShowPlot(CellPlot, SumbuX, legendLabel);
