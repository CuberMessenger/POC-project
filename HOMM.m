function [ Mpq ] = HOMM( p,q,s )
%HOMM=High Order Mixed Moment
Mpq=mean((s.^(p-q)).*(conj(s).^q));
end

  