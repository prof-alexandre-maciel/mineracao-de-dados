function readSVM(entrada, entradaFim, aleatorio)


	%----------------------------------------------------------------------
	[dy, dx] = size(entrada);
	aux = 1;
	%----------------------------------------------------------------------
	for i=1:dy,
		conjunto(i,:) = entrada(aleatorio(aux),:);
		aux = aux + 1;
    end

    %----------------------------------------------------------------------
    index = 0;
    %----------------------------------------------------------------------
    fib = fopen('SVM_v4_balanceado/entrada','w');
	%-------------------------------
    for j=1:dy
		index = index+1; 
        fprintf(fib,'%d ',conjunto(index, entradaFim+1));
        %------------------------------------------------------------------
        for i=1:entradaFim
            fprintf(fib,'%d:%s ',i, num2str(conjunto(j,i)) );
        end
        fprintf(fib,'\n');
        %------------------------------------------------------------------
                                                                                        
    end
    
    fclose(fib);
    