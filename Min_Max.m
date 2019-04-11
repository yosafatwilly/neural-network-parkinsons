function mats_norm = Min_Max(data)
min_new=0;
max_new=1;
min_data=min(data);
max_data=max(data);
[m,n]=size(data);
mats_norm=zeros(m,n);
for i=1:m
mats_norm(i)=((data(i)-min_data)/(max_data-min_data))*(max_new-min_new)+min_new;
end
end