function [ MT ] = HOCMC( S )
    %HOCMC=High Order Cumulant Modulation Classification 
    %S=signal
    %MT=Modulation Type

    % S=possible_pre_dealing(S);

    %Theoretical TF-value
    TF1=[16,8.32,7.189,4,2.08]; 
    TF2=[34,1,0];
    TF3=[16,0.549,4.257];

    %Mpq=p-Order Mixed Moment
    M20=HOMM(2,0,S);
    M21=HOMM(2,1,S);
    M40=HOMM(4,0,S);
    M41=HOMM(4,1,S);
    M42=HOMM(4,2,S);
    M60=HOMM(6,0,S);
    M63=HOMM(6,3,S);
    M80=HOMM(8,0,S);

    %Cpq=p-Order Cumulant 
    % C20=M20;
    C21=M21;
    C40=M40-3*(M20^2);
    C63=M63-6*M41*M20-9*M42*M21 +18*(M20^2)*M21 +12*(M21^3);
    C80=M80-28*M20*M60-35*(M40^2)+420*(M20^2)*M40-630*(M20^4);


    % F1=abs(C80)/((abs(C21))^4);
    % F1=abs(C40)/((abs(C21))^2);
    F1=abs(C63)/(abs(C21)^3);
%     F1=abs(C80)/(abs(C63)*abs(C21));
    derta1=abs(abs(F1)-TF1);
    index1=find(derta1==min(derta1));

    if (index1~=4)
        switch (index1)
            case 1
                MT='BPSK';
            case 2
                MT='4ASK';
            case 3
                MT='8ASK';
            case 5
                MT='16QAM';
        end
        return ;
    end

    F2=abs(C80)/((abs(C21))^4);
    derta2=abs(abs(F2)-TF2);
    index2=find(derta2==min(derta2));
    
    if (index2~=3)
        switch (index2)
            case 1
                MT='QPSK';
            case 2
                MT='8PSK';
        end
        return ;
    end

    DS=diff(S);

    M20=HOMM(2,0,DS);
    M21=HOMM(2,1,DS);
    M41=HOMM(4,1,DS);
    M42=HOMM(4,2,DS);
    M63=HOMM(6,3,DS);

    CD42=M42-M20^2-2*(M21^2);
    CD63=M63-6*M41*M20-9*M42*M21+18*(M20^2)*M21+12*(M21^3);

    F3=(abs(CD63)^2)/(abs(CD42)^3);
    derta3=abs(F3-TF3);
    index3=find(derta3==min(derta3));

    switch (index3)
        case 1
            MT='2FSK';
        case 2
            MT='4FSK';
        case 3
            MT='8FSK';
    end
end