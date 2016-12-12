function plot_results()


% cnn
data1 = csvread('~/logs/log_cnn_2.txt');
data2 = csvread('~/logs/log_cnn_3_adj.txt');
% ind1 = find(diff(data2(:,3))<0);
% data2(ind1+1:end,3) = data2(ind1+1:end,3) +data2(ind1,3);
% csvwrite('~/logs/log_cnn_3_adj.txt',data2);
data3 = csvread('~/logs/log_h50_adj.txt');
% ind1 = find(diff(data3(:,3))<0);
% data3(ind1+1:end,3) = data3(ind1+1:end,3) +data3(ind1,3);
% csvwrite('~/logs/log_h50_adj.txt',data3);
data4 = csvread('~/logs/log_h50_2.txt');
data5 = csvread('~/logs/log_h100.txt');
data6 = csvread('~/logs/log_h100_2_adj.txt');
%ind1 = find(diff(data6(:,3))<0);
%data6(ind1+1:end,3) = data6(ind1+1:end,3) +data6(ind1,3);
%csvwrite('~/logs/log_h100_2_adj.txt',data6);
data1(:,3) = data1(:,3)/(60*24);
data2(:,3) = data2(:,3)/(60*24);
data3(:,3) = data3(:,3)/(60*24);
data4(:,3) = data4(:,3)/(60*24);
data5(:,3) = data5(:,3)/(60*24);
data6(:,3) = data6(:,3)/(60*24);




% plot time versus reward
figuresize(6,4,'inches')
plot(data2(:,3),smooth(data2(:,2),30),'LineWidth',1.5,'Color','r')
hold on
plot(data3(:,3),smooth(data3(:,2),30),'LineWidth',1.5,'Color','b')
plot(data6(:,3),smooth(data6(:,2),30),'LineWidth',1.5,'Color','g')
xlabel('Time (s)','FontSize',14)
ylabel('Average Reward')
title('Training Reward by Time')
legend('CNN','H50','H100')
box off

saveas(gcf,'~/logs/time','jpg')
hold off 

% plot episode versus reward for cnn
figuresize(6,4,'inches')
plot(data1(:,1),smooth(data1(:,2),10),'LineWidth',1.5,'Color','r')
hold on
plot(data2(:,1),smooth(data2(:,2),10),'LineWidth',1.5,'Color','b')
xlabel('Episodes')
ylabel('Average Reward')
legend('Trial 1','Trial 2')
title('Training Reward by Episode')
box off

saveas(gcf,'~/logs/cnn_episodes','jpg')
hold off 


% plot episode versus reward for vectorization 
figuresize(6,4,'inches')
plot(data3(:,1),smooth(data3(:,2),50),'LineWidth',1.5,'Color','r')
hold on
plot(data4(:,1),smooth(data4(:,2),50),'LineWidth',1.5,'Color','r')
plot(data5(:,1),smooth(data5(:,2),50),'LineWidth',1.5,'Color','b')
plot(data6(:,1),smooth(data6(:,2),50),'LineWidth',1.5,'Color','b')
xlabel('Episodes')
ylabel('Average Reward')
legend('H-50','H-50','H-100','H-100')
title('Training Reward by Episode')
box off

saveas(gcf,'~/logs/vector_episodes','jpg')
hold off

% plot time 
figure
figuresize(6,4,'inches')
plot(data2(:,3),smooth(data2(:,2),50),'LineWidth',1.5,'Color','g')
hold on
plot(data3(:,3),smooth(data3(:,2),50),'LineWidth',1.5,'Color','r')
plot(data6(:,3),smooth(data6(:,2),50),'LineWidth',1.5,'Color','b')
xlabel('Time (s)')
ylabel('Reward')
legend('CNN','H-50','H-100')
title('Training Reward by Time (s)')
box off

saveas(gcf,'~/logs/cnn_vector_time','jpg')
hold off





% plot time in between episodes
figure
figuresize(6,4,'inches')
diff2 = diff(data2(:,3)); diff2(diff2<0)=[]; 
diff3 = diff(data3(:,3)); diff3(diff3<0)=[]; 
diff6 = diff(data6(:,3)); diff6(diff6<0)=[]; 
plot(smooth(diff2,10),'g');
hold on
plot(smooth(diff3,10),'b')
plot(smooth(diff6,10),'r')
xlabel('Episodes')
ylabel('Time between Episodes (ms)')
legend('CNN','H50','H100')
box off
title('Time between Episodes')
saveas(gcf,'~/logs/time_bet','jpg')
keyboard
















hold off 


 
