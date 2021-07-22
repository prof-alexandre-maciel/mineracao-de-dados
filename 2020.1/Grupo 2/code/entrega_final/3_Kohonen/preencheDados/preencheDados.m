function [conjuntoTreinamento, conjuntoTeste] = preencheDados(entradaFim, classes, conjuntoTreinamento, conjuntoTeste)

    %--------------Entradas Treinamento---------------------------------------------------------
	saidasT = conjuntoTreinamento(:,entradaFim+1);
    [dimy,dimx] = size(saidasT);
    
    for j=1:dimy
        for i=1:classes
            saidasTreinamento(j,i) = 0;
        end        
        saidasTreinamento(j,saidasT(j,1)) = 1; 
    end
    
    conjuntoTreinamento(:,(entradaFim+1):end) = [];
	conjuntoTreinamento = cat(2,conjuntoTreinamento, saidasTreinamento);
    %--------------Entradas Teste------------------------------------------------------------
	saidastes   = conjuntoTeste(:,entradaFim+1);
	[dimy,dimx] = size(saidastes);
	
	for j=1:dimy
        for i=1:classes
            saidasTeste(j,i) = 0;
        end        
        saidasTeste(j,saidastes(j,1)) = 1; 
    end
	
	conjuntoTeste(:,(entradaFim+1):end) = [];
	conjuntoTeste = cat(2,conjuntoTeste, saidasTeste);	