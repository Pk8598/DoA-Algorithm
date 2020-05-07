

%------ detection(generation) of received signal in presence of AWGN ------


function [SRl,SRr]=radar_doAgen(fc,fs,aoaA,SNR,reg)

global Niter XSRl XSRr i k snr res T;


N=180/res;       % number of samples in gaussian window  
%(each antenna has resolution of 0.1 degree)
w1=gausswin(N);  % plot of antenna 1 placed at 45  degree 
                 %----> Range(315 to 135 degree)
w2=gausswin(N);  % plot of antenna 2 placed at 135 degree 
                 %----> Range(45 to 225 degree)
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
  ind=find(abs(aoaA-w{reg}(:,1))<0.000000001);
  ALa=w{reg}(ind,2);
  ARa=w{reg}(ind,3);
  t=0:1/fs:T-1/fs;
  %signal generated(received) for T seconds
  SRl=awgn(ALa*cos(2*pi*fc*t),SNR,'measured');
  % signal received at 1st Antenna
  SRr=awgn(ARa*cos(2*pi*fc*t),SNR,'measured');
  % signal received at 2nd Antenna
  %Adding wgn with specified noise power and load impedance
  %SRl=ALa*cos(2*pi*fc*t)+wgn(1,length(t),noise power,50);
  %SRr=ARa*cos(2*pi*fc*t)+wgn(1,length(t),noise power,50);
   if(k==length(snr)-6 && i==Niter)
    %------- plotting of signals received at 1st and 2nd Antennas ---------   
    figure('Name','Received Signals','NumberTitle','off');
    
    subplot(211);
    plot(t,SRl);xlabel('time in seconds');ylabel('amplitude');
    title(sprintf(...
    'signal received at 1st Antenna in region %d with SNR=%d db',reg,SNR));
    
    subplot(212);
    plot(t,SRr,'r');xlabel('time in seconds');ylabel('amplitude');
    title(sprintf(...
    'signal received at 2nd Antenna in region %d with SNR=%d db',reg,SNR));
    
    %----- plotting FFTs of signals received at 1st and 2nd Antennas ------
    
    tf=-(1-1/length(XSRl))/2:1/length(XSRl):(1-1/length(XSRl))/2;
    figure('Name','FFT of Received Signals','NumberTitle','off');
    
    subplot(211);
    plot(tf*fs,XSRl);xlabel('frequency in Mhz');ylabel('mag');
    title(sprintf(...
   'FFT of signal received at 1st Antenna in region %d with SNR=%d db',...
    reg,SNR));
    
    subplot(212);
    plot(tf*fs,XSRr,'r');xlabel('frequency in Mhz');ylabel('mag');
    title(sprintf(...
    'FFT of signal received at 1st Antenna in region %d with SNR=%d db',...
    reg,SNR));
   end
 end