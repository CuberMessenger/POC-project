clear all;
close all;
clc;

rate=0;

for test_num=1:100
    % signal generation;
    %if you want to conduct 100 seperate tests,set up 100 times iteration
    for j = 1:1  % bit per symbol: 1. PSK; 2. QPSK; 3.8QAM; 4. 16QAM; 5. 32QAM; 6.64QAM...
        System.BitPerSymbol = j;
        snr = 12:15;  %the position of SNR unit:dB
        for snrIndex= 1:length(snr)
            
            Tx.SampleRate = 32e9; %symbol Rate: the rate of code, can be modified
            Tx.Linewidth = 0;%the line breadth of carrier wave,it is related to phase noise,can be modified ,default value is 0
            Tx.Carrier = 0;%frequency of carrier wave, can be modified, default value is 0
            M = 2^System.BitPerSymbol;
            
            
            
            Tx.DataSymbol = randi([0 M-1],1,10000);%the number of data for each random process,default value is 10000
            
            %generate different modulation mode: here specifies 2^3(8QAM),to get the best constellation
            if M ~= 8;
                h = modem.qammod('M', M, 'SymbolOrder', 'Gray');
                Tx.DataConstel = modulate(h,Tx.DataSymbol);
            else
                tmp = Tx.DataSymbol;
                tmp2  = zeros(1,length(Tx.DataSymbol));
                for kk = 1:length(Tx.DataSymbol)
                    
                    switch tmp(kk)
                        case 0
                            tmp2(kk) = 1 + 1i;
                        case 1
                            tmp2(kk) = -1 + 1i;
                        case 2
                            tmp2(kk) = -1 - 1i;
                        case 3
                            tmp2(kk) = 1 - 1i;
                        case 4
                            tmp2(kk) = 1+sqrt(3);
                        case 5
                            tmp2(kk) = 0 + 1i .* (1+sqrt(3));
                        case 6
                            tmp2(kk) = 0 - 1i .* (1+sqrt(3));
                        case 7
                            tmp2(kk) = -1-sqrt(3);
                    end
                end
                Tx.DataConstel = tmp2;
                clear tmp tmp2;
            end
            
            
            Tx.Signal = Tx.DataConstel;
            
            %load the signal to carrier wave, taking phase noise into account
            N = length(Tx.Signal);
            dt = 1/Tx.SampleRate;
            t = dt*(0:N-1);
            Phase1 = [0, cumsum(normrnd(0,sqrt(2*pi*Tx.Linewidth/(Tx.SampleRate)), 1, N-1))];
            carrier1 = exp(1i*(2*pi*t*Tx.Carrier + Phase1));
            Tx.Signal = Tx.Signal.*carrier1;
            
            Rx.Signal = awgn(Tx.Signal,snr(snrIndex),'measured');%recieve signal which was transfered in AWGN channel
            CMAOUT = Rx.Signal;
            
            %normalization of recieved signal
            CMAOUT=CMAOUT/sqrt(mean(abs(CMAOUT).^2));
            
            subplot(1,7,snrIndex);
            plot(Rx.Signal,'.');
        end
        
        if (HOCMC(Rx.Signal)=='BPSK')
            rate=rate+1;
        end
    end
end
rate/test_num*100

