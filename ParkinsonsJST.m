function Akurasi = ParkinsonsJST(InputTrain, TargetTrain, InputTest, TargetTest, JumlahNeuron, Aktivasi, TrainFunction)

rand('seed', 491218382)

net = newff(InputTrain, TargetTrain, JumlahNeuron, Aktivasi, TrainFunction);

[net,~]=train(net, InputTrain, TargetTrain);

out = sim(net, InputTest);

luaran=round(out);

Hasil=confusionmat(TargetTest, luaran);

Akurasi=(sum(diag(Hasil))/sum(sum(Hasil)))*100;

end