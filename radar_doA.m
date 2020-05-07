

%-- Function for detection of Direction of Arrival (DOA)of Radar signal ---
% Here entire 360 degrees is divided into 4 Regions (each of 90 degrees)
 % all regions share two Antennas
 % Region 1 ---> Antennas 4 and 1  (315-0-45 degree)
 % Region 2 ---> Antennas 1 and 2  (45-90-135 degree)
 % Region 3 ---> Antennas 2 and 3  (135-180-225 degree)
 % Region 4 ---> Antennas 3 and 4  (225-270-315 degree)

function [DoA] =radar_doA(reg,SRl,SRr)

global Niter XSRl XSRr i k snr res ;
 
N=180/res;       % number of samples in gaussian window 
%(each antenna has resolution of 0.1 degree)
w1=gausswin(N);  % plot of antenna 1 placed at 45  degree 
                  %----> Range(315 to 135 degree)
w2=gausswin(N);  % plot of antenna 2 placed at 135 degree 
                 % ----> Range(45 to 225 degree)
w3=gausswin(N);  % plot of antenna 3 placed at 225 degree 
                 %----> Range(135 to 315 degree)
w4=gausswin(N);  % plot of antenna 4 placed at 315 degree
                 %----> Range(225 to 45 degree) 

% for detection of doA(in degrees) in Region 1 
%( using signal received by antennas A4 and A1)
i41=[315:res:360-res,0:res:45-res]';
w41=[i41,w4((N/2)+1:N),w1(1:N/2)];
% for detection of doA(in degrees) in Region 2 
%( using signal received by antennas A1 and A2)
i12=(45:res:135-res)'; % index vector for Region 2
w12=[i12,w1((N/2)+1:N),w2(1:N/2)];
% for detection of doA(in degrees) in Region 3 
%( using signal received by antennas A2 and A3)
i23=(135:res:225-res)';
w23=[i23,w2((N/2)+1:N),w3(1:N/2)];
% for detection of doA(in degrees) in Region 4 
%( using signal received by antennas A3 and A4)
i34=(225:res:315-res)';
w34=[i34,w3((N/2)+1:N),w4(1:N/2)];
w={w41,w12,w23,w34};

%---------- Extraction of Amplitude info from received signals ------------

  XSRl=abs(fftshift(fft(SRl,length(SRl))))/length(SRl);
  % Two sided spectrum(FFT) of signal received by 1st Antenna
  XSRr=abs(fftshift(fft(SRr,length(SRr))))/length(SRr);
  % Two sided spectrum(FFT) of signal received by 1st Antenna
  ALn=2*max(XSRl); 
  % amplitude of received signal in presence of awgn noise at 1st antenna
  ARn=2*max(XSRr); 
  % amplitude of received signal in presence of awgn noise at 2nd antenna
  
%----------------------- Error calculation --------------------------------  

 Er=zeros(1,N/2);
 for j=1:N/2
     Er(j)=sqrt((ALn-w{reg}(j,2))^2 + (ARn-w{reg}(j,3))^2);
     % caculating eucleidean distance
 end
 [~,j]=min(Er);  % selecting the index with least eucleidean distance
 DoA=w{reg}(j,1);% direction of Arrival of radar signal (in degrees) 
 if reg~=1
     ind=w{reg}(:,1);
     AoA=DoA;
 else
     ind=[i41(1:N/4)-360;i41(N/4+1:N/2)];
     AoA=DoA-(DoA<360 && DoA>180)*360;
 end
 
 %------------ Plotting Antenna patterns in different Regions -------------
  if(k==length(snr)-6 && i==Niter)
   figure('Name','Antenna patterns','NumberTitle','off');
       
   subplot(211);
   
  wl=w{reg}(:,2);
  wr=w{reg}(:,3);
  plot(ind,wl,'r');hold on;plot(ind,wr);hold on;
  scatter(AoA,w{reg}(j,2),'filled','blue');
  scatter(AoA,w{reg}(j,3),'filled','red');
  scatter(AoA,ALn,32,'*','red');
  scatter(AoA,ARn,32,'*','blue');
  xlabel('Direction of Arrival with respect to NORTH(0 degree) in degrees');
  xlim([ind(1) ind(end)]);
  ylabel('Normalized power received');
  title(sprintf('Antenna Pattern in Region %d',reg)); ylim([0 1.2]);
  lgd=legend('Pattern of 1st Antenna','Pattern of 2nd Antenna',...
  'received point 1','received point 2','Actual point 1','Actual point 2');
  lgd.NumColumns=3;
   
   subplot(212);
   
  p=zeros(1,6);
  p(1)=plot((-45:res:135-res),w1(1:N),'b',...
  'LineWidth',2,'DisplayName','Pattern of Antenna 1'); hold on;
  p(2)=plot((-180:res:-135),w2((N-N/4):N),'g',...
  'LineWidth',2,'DisplayName','Pattern of Antenna 2');hold on;
  p(3)=plot((-180:res:-45),w3(N/4:N),'k',...
  'LineWidth',2,'DisplayName','Pattern of Antenna 3');hold on; 
  p(4)=plot((-135:res:45-res),w4(1:N),'r',...
  'LineWidth',2,'DisplayName','Pattern of Antenna 4'); hold on;
  p(5)=plot((45:res:180-res),w2(1:N-N/4),'g',...
  'LineWidth',2);hold on;
  p(6)=plot((135:res:180-res),w3(1:N/4),'k','LineWidth',2); 
  xlabel('Direction of Arrival with respect to NORTH(0 degree) in degrees');
  xlim([-180 180]);ylabel('Normalized power received');
  title('Antenna Patterns across all regions');ylim([0 1.2]);
  legend(p(1:4));
 end
end
     
 
 
 
 
 










