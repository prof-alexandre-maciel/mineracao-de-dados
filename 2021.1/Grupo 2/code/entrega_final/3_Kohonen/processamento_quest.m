function [entrada,entrada_fim] = processamento_quest(str)	
		
    %----1º questionário---------------------------------------------------
    vetor(1,1) = 5;
    vetor(1,2) = 8;
    vetor(1,3) = 11;
    vetor(1,4) = 14;
    vetor(1,5) = 17;
    vetor(1,6) = 20;
    
    %----2º questionário---------------------------------------------------
    vetor(2,1) = 5;
    vetor(2,2) = 8;
    vetor(2,3) = 11;
    vetor(2,4) = 14;
    vetor(2,5) = 17;
    vetor(2,6) = 20;
    
    %----3º questionário---------------------------------------------------
    vetor(3,1) = 5;
    vetor(3,2) = 8;
    vetor(3,3) = 11;
    vetor(3,4) = 14;
    vetor(3,5) = 17;
    vetor(3,6) = 20;
    
    %----Questionário final------------------------------------------------
    vet(1) = 5;
    vet(2) = 8;
    vet(3) = 11;
    vet(4) = 14;
    vet(5) = 17;
    vet(6) = 20;
    vet(7) = 23;
    vet(8) = 26;
    vet(9) = 29;
    vet(10) = 32;
    %----------------------------------------------------------------------
    entrada = [];
    entrada_fim = [];
    index_total = 0;
    index_total_fim = 0;
    
    fid = fopen(str);
    remain = fgetl(fid);%ler a linha do arquivo
    total=sum(remain==';');
    while ~feof(fid)
		index_total = index_total+1;
        if mod(index_total, 4)==0
            index_total_fim = index_total_fim +1;
        end

		remain = fgetl(fid);%ler a linha do arquivo
        %------------------------------------------------------------------
		count = 0;
		for i=1:(total-1)
            %------------Cataloga jogador----------------------------------
            [a_temp, remain] = strtok(remain, ';');
            a = str2double(a_temp);
            count = count +1;
            if( (isempty(a)) || (isnan(a)) ) a = 0; end
            entrada(index_total, count) = a;
            if mod(index_total, 4)==0
                entrada_fim(index_total_fim, 1) = a;
            end
            %--------------------------------------------------------------
        end
        %------------------------------------------------------------------
        remain = remain(2:end);                %elimina o primeiro ponto e virgula
        for i=1:75
            j = mod(index_total, 4);
            [a_temp, remain] = strtok(remain, ':');
            if (j==0) 
                    if (i==vet(1))||(i==vet(2))||(i==vet(3))||(i==vet(4))||(i==vet(5))||(i==vet(6))||(i==vet(7))||(i==vet(8))||(i==vet(9))||(i==vet(10))
   
                        a_temp = regexp(a_temp,'\d*','Match'); 
                        a = str2double(a_temp);
                        count = count +1;
                        if( (isempty(a)) || (isnan(a)) ) a = 0; end
                        entrada_fim(index_total_fim, count) = a;
                    end
            else
                if (i==vetor(j,1))||(i==vetor(j,2))||(i==vetor(j,3))||(i==vetor(j,4))||(i==vetor(j,5))||(i==vetor(j,6))
                    a_temp = regexp(a_temp,'\d*','Match');
                    a = str2double(a_temp);
                    count = count +1;
                    if( (isempty(a)) || (isnan(a)) ) a = 0; end
                    entrada(index_total, count) = a;
                end
            end
        end
		%------------------------------------------------------------------
    end
    %----------------------------------------------------------------------
    [ay,ax] = size(entrada);
    for i=ay:-4:4
        entrada(i,:) = [];
    end
    
    %entrada 
    %----------------------------------------------------------------------
    %entrada_fim
    [ay,ax] = size(entrada_fim);
    entrada_fim(:,ax) = [];
    %entrada_fim
	fclose('all');
%--------------------------------------------------------------------------
	

