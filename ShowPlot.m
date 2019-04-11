function ShowPlot(CellPlot, SumbuX, legendLabel)
figure
des = {'r', 'g', 'b', 'c', 'm', 'y', 'k', 'r--', 'g--', 'b--', 'c--', 'm--', 'y--', 'k--','r:', 'g:', 'b:', 'c:', 'm:', 'y:', 'k:'};
for k = 1:length(CellPlot)
    h = plot(SumbuX,CellPlot{k}, des{k});
    set(h(1),'linewidth',2);
    if k == 1
       hold on
    end
end
hold off
title('Variasi Akurasi berdasarkan jumlah Neuron, Fungsi Aktivasi dan Train Function');
xlabel('Jumlah Newron');
ylabel('Akurasi (%)');
legend(legendLabel);
end