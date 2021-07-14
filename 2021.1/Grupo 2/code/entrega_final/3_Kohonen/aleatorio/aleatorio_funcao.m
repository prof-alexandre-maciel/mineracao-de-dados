function [entrada, aleatorio, atributos] =...
		 aleatorio_funcao(entrada_benigno,entrada_maligno,...
                         index_total_benigno,index_total_maligno)
%--------------------------------------------------------------------------
    aleatorio = [];
    
   	aleatorio_benigno = randperm(index_total_benigno);
	aleatorio_maligno = randperm(index_total_maligno);
    
    minimo = min(length(aleatorio_benigno), length(aleatorio_maligno));
    maximo = max(length(aleatorio_benigno), length(aleatorio_maligno));
     
    count = 0;
    for i=1:minimo
        count = count + 1;
        aleatorio(count) = aleatorio_benigno(i);
        count = count + 1;
        aleatorio(count) = index_total_benigno+aleatorio_maligno(i);
    end	

    for i=(minimo+1):maximo
        count = count + 1;
        aleatorio(count) = index_total_benigno+aleatorio_maligno(i);
    end
    entrada = cat(1,entrada_benigno,entrada_maligno);
    
    [linhas, colunas] = size(entrada);
    atributos = colunas -1;
%--------------------------------------------------------------------------
	