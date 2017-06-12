function [ MT ] = HOCMC( S )
%HOCMC=High Order Cumulant Modulation Classification 
%S=signal
%MT=Modulation Type
TF=[2.000,1.000,0.680,0.619];           %Theoretical F-value
PMT=['BPSK','QPSK','16QAM','64QAM'];    %Possible Modulation Tormat

%Cpq=p-Order Cumulant 
C20=HOMM(2,0,S);
C21=HOMM(2,1,S);
C40=HOMM(4,0,S)-3*(C20^2);
%C41=HOMM(4,1,S)-3*C20*C21;
C42=HOMM(4,2,S)-C20^2-2*(C21^2);
F=abs(C40)/((abs(C21))^2);
derta=abs(F-TF);
index=find(derta==min(derta));
switch (index)
    case 1
        MT='BPSK';
    case 2
        MT='QPSK';
    case 3
        MT='16QAM';
    case 4
        MT='64QAM';
end
end