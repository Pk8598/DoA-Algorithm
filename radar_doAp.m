

%------------- program to Test AoA Estimation function --------------------

clear all;
clc;
close all;
 %--------------------------- Inputs --------------------------------------
 global Niter i k snr res T;
 Niter=1000;               % number of iterations
 res=0.1;                 % resolution of antennas (in degrees) 
 AoAa=randi([0,359],1,Niter)+randi([0 9/(10*res)],1,Niter)*res;  
 % known Angle of Arrival of received signal
 % received signal characteristics in presence of awgn noise
 fc=100;                  % carier frequency of radar signal (Mhz)
 fs=1350;                 % sampling rate at which signal is sampled(Msps)
 T=1;                     % time for which signal is received
 snr=-15:3:15;  % signal to noise ratio
 ME=zeros(1,length(snr));   % Mean error of estimated AoA 
 MAE=zeros(1,length(snr));  % Mean Absolute error of estimated AoA 
 MaxE=zeros(1,length(snr)); % Maximum Absolute error of estimated AoA 
 MinE=zeros(1,length(snr)); % Minimum Absolute error of estimated AoA 
 Stdv=zeros(1,length(snr)); % Standard Deviation of the error
 for k=1:length(snr)
   AoAe=zeros(1,Niter);
   Error=zeros(1,Niter);
   for i=1:Niter
     %------- detecting region in which radar signal is received ----------
     regm=[((AoAa(i)>=315 && AoAa(i)<360) ||( AoAa(i)>=0 && AoAa(i)<45))...
     ,(AoAa(i)>=45 && AoAa(i)<135),(AoAa(i)>=135 && AoAa(i)<225)...
     ,(AoAa(i)>=225 && AoAa(i)<315)];
     reg=find(regm==1);
       
       %-------- function to generate signals received by two antennas-----
       %--- with given signal and channel characteristics and known AoA ---
       [SRl,SRr]=radar_doAgen(fc,fs,AoAa(i),snr(k),reg);
       
       %-------- function to calculate AoA given received signal ----------
       %--------- by the Antennas in the presence of Awgn noise  ----------
       AoAe(i) =radar_doA(reg,SRl,SRr); % Estimated AoA
       
       %------------- calculation of Error in Estimated AoA ---------------
       
       Error(i)=(AoAe(i)-AoAa(i));
       % Error in Estimated AoA with respect to Actual AoA
       
       if (AoAa(i)>=0 && AoAa(i)<45 && AoAe(i)<360 && AoAe(i)>=315)
           Error(i)=Error(i)-360;
       elseif (AoAa(i)<360 && AoAa(i)>=315 && AoAe(i)>=0 && AoAe(i)<45)
           Error(i)=mod(Error(i)+360,360);
       end
   end
   
 %------------------ Intermediate Results and Plots -----------------------

 figure('Name',...
 sprintf('Analysis of AoA Estimation function for SNR=%d db',snr(k)));
 
 subplot(211);
 scatter((1:Niter),AoAa,40,'filled','MarkerFaceColor','b');hold on;
 scatter((1:Niter),AoAe,34,'*','red');
 title(sprintf('Plot of Actual and Estimated AoA for SNR=%d db',snr(k)));
 ylabel('AoA (in degrees)');xlabel('iteration number');
 legend('Actual AoA','Estimated AoA');
 
 subplot(212);
 plot(Error,'m');
 title(sprintf('Plot of Error in Estimated AoA for SNR=%d db',snr(k)));
 ylabel('Error in Estimated AoA (in degrees)');xlabel('iteration number');
 
 %-------------- Statistical Analysis of the Result ----------------------
 ME(k)=sum(Error)/Niter;
 MAE(k)=sum(abs(Error))/Niter; 
 MaxE(k)=max(Error);
 MinE(k)=min(Error);
 Stdv(k)=std(Error,1);
 end
 
 %---------------------- Results and Plots --------------------------------
 
 figure('Name','Analysis of AoA Estimation function');
 
plot(snr,MAE,'LineWidth',2);
hold on; stem(snr,MAE,'filled','--','MarkerFacecolor','red',...
'MarkerEdgecolor','green');
title('Mean Absolute Error vs SNR Plot');
xlabel('SNR (in db)');xlim([snr(1)-1 snr(end)+1]);
ylabel('Mean Absolute Error in Estimated AoA (in degrees)'); 
 
 figure('Name','Analysis of AoA Estimation function');
 
 subplot(211);
 plot(snr,MaxE,'LineWidth',2);hold on;
 stem(snr,MaxE,'filled','--','MarkerFacecolor','red',...
 'MarkerEdgecolor','green');
 title('Maximum positive Deviation vs SNR Plot');
 xlabel('SNR (in db)');xlim([snr(1)-1 snr(end)+1]);
 ylabel('Maximum positive Deviation (in degrees)'); 
 subplot(212);
 plot(snr,MinE,'LineWidth',2);hold on;
 stem(snr,MinE,'filled','--','MarkerFacecolor','red',...
 'MarkerEdgecolor','green');
 title('Maximum negative Deviation vs SNR Plot');
 xlabel('SNR (in db)');xlim([snr(1)-1 snr(end)+1]);
 ylabel('Maximum negative Deviation (in degrees)'); 
 
 figure('Name','Analysis of AoA Estimation function');
 subplot(211)
 plot(snr,ME,'LineWidth',2);hold on;
 stem(snr,ME,'filled','--','MarkerFacecolor','red',...
 'MarkerEdgecolor','green');
 title('Mean Error vs SNR Plot');
 xlabel('SNR (in db)');xlim([snr(1)-1 snr(end)+1]);
 ylabel('Mean Error in Estimated AoA (in degrees)'); 
 subplot(212)
 plot(snr,Stdv,'LineWidth',2);hold on;
 stem(snr,Stdv,'filled','--','MarkerFacecolor','red',...
 'MarkerEdgecolor','green');
 title('Standard Deviation of Error vs SNR Plot');
 xlabel('SNR (in db)');xlim([snr(1)-1 snr(end)+1]);
 ylabel('Standard Deviation of Error(in degrees)'); 
 
 
 
 
 
 
 
 
 
 




 