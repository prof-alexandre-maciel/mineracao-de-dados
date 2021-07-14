function [conjunto] = preencheDadosMLP(entradaFim, classe, conjunto)

    saidasT   = conjunto(:,entradaFim+1);
    [dimy,dimx] = size(saidasT);
     
    for j=1:dimy
        for i=1:classe
            saidas(j,i) = 0;
        end
        saidas(j,saidasT(j,1)) = 1;
    end
    
    conjunto(:,(entradaFim+1):end) = [];
	conjunto = cat(2,conjunto, saidas);
    