function [R] = normalizarSaida(matriz)
	
	[dy, dx] = size(matriz);
	
    R = [];
	for j=1 : dy;
		for i=1 : dx;
			if matriz(j,i)==0
				R(j,i) = 0.1;
			else
				R(j,i) = 0.9;
			end
		end
	end
	
end