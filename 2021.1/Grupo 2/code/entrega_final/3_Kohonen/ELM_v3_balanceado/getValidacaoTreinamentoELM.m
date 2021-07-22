function [conjuntoTreinamento, conjuntoTeste] = getValidacaoTreinamentoELM(entrada, aleatorio, fold)

	% 80% para treinamento
	% 20% para testes
    
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
		conjuntoTes = fold1;
    elseif (fold == 2)
		conjuntoTreino = [fold1,fold3,fold4,fold5, fold6, fold7, fold8, fold9, fold10];
		conjuntoTes = fold2;
    elseif (fold == 3)
		conjuntoTreino = [fold1, fold2, fold4, fold5, fold6, fold7, fold8, fold9, fold10];
		conjuntoTes = fold3;
    elseif (fold == 4)
		conjuntoTreino = [fold1, fold2, fold3, fold5, fold6, fold7, fold8, fold9, fold10];
		conjuntoTes = fold4;
    elseif (fold == 5)
		conjuntoTreino = [fold1, fold2, fold3, fold4, fold6, fold7, fold8, fold9, fold10];
		conjuntoTes = fold5;
    elseif(fold == 6)
		conjuntoTreino = [fold1, fold2, fold3, fold4, fold5, fold7, fold8, fold9, fold10];
		conjuntoTes = fold6;
    elseif (fold == 7)
		conjuntoTreino = [fold1, fold2, fold3, fold4, fold5, fold6, fold8, fold9, fold10];
		conjuntoTes = fold7;
    elseif (fold == 8)
		conjuntoTreino = [fold1, fold2, fold3, fold4, fold5, fold6, fold7, fold9, fold10];
		conjuntoTes = fold8;
    elseif (fold == 9)
		conjuntoTreino = [fold1, fold2, fold3, fold4, fold5, fold6, fold7, fold8, fold10];
		conjuntoTes = fold9;
    elseif (fold == 10)
		conjuntoTreino = [fold1, fold2, fold3, fold4, fold5, fold6, fold7, fold8, fold9];
		conjuntoTes = fold10;
    end
	
	
	%----------------------------------------------------------------
	[dy,numTr] = size(conjuntoTreino);    
    conjuntoTreinamento = [];
	for i=1:numTr,
		conjuntoTreinamento(i,:) = entrada(aleatorio(conjuntoTreino(i)),:);
    end
	%----------------------------------------------------------------
	[dy,numTeste] = size(conjuntoTes);
	conjuntoTeste = [];
    for i=1:numTeste,
		conjuntoTeste(i,:) = entrada(aleatorio(conjuntoTes(i)),:);
    end

    
	