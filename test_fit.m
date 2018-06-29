close all
clear
clc

x = -100 : 0.1 : +100;

l = 100;

figure
hold on

for k = 2:10

y = 1 - exp(-( (x+100) /l).^k);

plot(x,y)

end