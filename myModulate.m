function [ tmp ] = myModulate( h, DataSymbol )
%myModulate Modulation Implementation including MASK, MFSK
%   Uses: function modulate
%

if strcmp(h.Type, 'QAM')
    h1 = modem.qammod('M', h.M, 'SymbolOrder', 'Gray');
    tmp = modulate(h1, DataSymbol);
else if strcmp(h.Type, 'ASK') && (h.M == 4)
        tmp2 = DataSymbol;
        tmp = zeros(1, length(DataSymbol));
        
        for kk = 1:length(DataSymbol)
            switch tmp2(kk)
                case 0
                    tmp(kk) = i;
                case 1
                    tmp(kk) = 1/2*i;
                case 2
                    tmp(kk) = -1/2i;
                case 3
                    tmp(kk) = -i;
            end
        end
    end
end

end

