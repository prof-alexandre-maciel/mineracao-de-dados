function [saidasTreinamento, entradasTreinamento,saidasTeste, entradasTeste, pesos]...
         = getValidacaoTreinamentoSVM_v4(classes, label, inst, aleatorio, fold)

	% 90% para treinamento
	% 10% para testes
	%----------------------------------------------------------------
	k = 10;
	numElem = floor(size(aleatorio,2)/k);

	fold1 = 1:numElem;
	fold2 = numElem+1: 2*numElem;
	fold3 = (2*numElem)+1: 3*numElem;
	fold4 = (3*numElem)+1: 4*numElem;
    fold5 = (4*numElem)+1: 5*numElem;
    fold6 = (5*numElem)+1: 6*numElem;
    fold7 = (6*numElem)+1: 7*numElem;
    fold8 = (7*numElem)+1: 8*numElem;
    fold9 = (8*numElem)+1: 9*numElem;                   
	fold10 = (9*numElem)+1: size(aleatorio,2);
    
	%----------------------------------------------------------------
	if(fold == 1)
		conjuntoTreino = [fold2, fold3, fold4, fold5, fold6, fold7, fold8, fold9, fold10];
		conjuntoTeste = fold1;
    elseif (fold == 2)
		conjuntoTreino = [fold1,fold3,fold4,fold5, fold6, fold7, fold8, fold9, fold10];
		conjuntoTeste = fold2;
    elseif (fold == 3)
		conjuntoTreino = [fold1, fold2, fold4, fold5, fold6, fold7, fold8, fold9, fold10];
		conjuntoTeste = fold3;
    elseif (fold == 4)
		conjuntoTreino = [fold1, fold2, fold3, fold5, fold6, fold7, fold8, fold9, fold10];
		conjuntoTeste = fold4;
    elseif (fold == 5)
		conjuntoTreino = [fold1, fold2, fold3, fold4, fold6, fold7, fold8, fold9, fold10];
		conjuntoTeste = fold5;
    elseif(fold == 6)
		conjuntoTreino = [fold1, fold2, fold3, fold4, fold5, fold7, fold8, fold9, fold10];
		conjuntoTeste = fold6;
    elseif (fold == 7)
		conjuntoTreino = [fold1, fold2, fold3, fold4, fold5, fold6, fold8, fold9, fold10];
		conjuntoTeste = fold7;
    elseif (fold == 8)
		conjuntoTreino = [fold1, fold2, fold3, fold4, fold5, fold6, fold7, fold9, fold10];
		conjuntoTeste = fold8;
    elseif (fold == 9)
		conjuntoTreino = [fold1, fold2, fold3, fold4, fold5, fold6, fold7, fold8, fold10];
		conjuntoTeste = fold9;
    elseif (fold == 10)
		conjuntoTreino = [fold1, fold2, fold3, fold4, fold5, fold6, fold7, fold8, fold9];
		conjuntoTeste = fold10;
    end

    %----------------------------------------------------------------------
    saidasTreinamento = label(conjuntoTreino(:), :);
    %----------------------------------------------------------------------
    entradasTreinamento = inst(conjuntoTreino(:), :); 
    %----------------------------------------------------------------------
    saidasTeste = label(conjuntoTeste(:), :);
    %----------------------------------------------------------------------
	entradasTeste = inst(conjuntoTeste(:), :);
    %======================================================================
    qtd_classes = zeros(classes,1,'double');
    for i=1:numel(saidasTreinamento)
        qtd_classes(saidasTreinamento(i)) = qtd_classes(saidasTreinamento(i)) + 1;  
    end
    %----------------------------------------------------------------------
    total = numel(saidasTreinamento);
    perc_classes = zeros(classes,1,'double');
    for k=1:classes
        perc_classes(k) = qtd_classes(k)/total;
    end
    %----------------------------------------------------------------------
    for k=1:classes
         pesos(k) = 1-perc_classes(k);
    end
    

   