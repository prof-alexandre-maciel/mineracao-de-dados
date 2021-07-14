function [entrada,entrada_som] = processamento_som_v1(str,classe)	
    
    [entrada] = processamento_kernel(str);

    entrada_som = entrada;
    %----------------------------------------------------------------------
    entrada(:,1) = [];
    [ay,ax] = size(entrada);
    entrada(:,ax+1) = classe;
    
%==========================================================================
function [entrada] = processamento_kernel(str)	

    entrada = [];
    index_total = 0;

    fid = fopen(str);
    remain = fgetl(fid);%ler a linha do arquivo
    total=sum(remain==';');
    while ~feof(fid)
		index_total = index_total+1;
		remain = fgetl(fid);%ler a linha do arquivo
        [entrada_temp] = kernel(remain);
        entrada(index_total, :) = entrada_temp(:);
    end
    
    fclose('all');

%==========================================================================
function [entrada] = kernel(remain)
	
        entrada = [];
        count = 0;
        %------------Cataloga jogador--------------------------------------
        for ii=1:34
            [resto, remain] = strtok(remain, ';'); %elimina a primeira coluna
            if (ii==1) || (ii==2)|| (ii==4) continue; end
            resto = strrep(resto,',','.');
            a = str2double(resto);
            count = count +1;
            if( (isempty(a)) || (isnan(a)) ) a = 0; end
            entrada(count) = a;
        end
        %------------------------------------------------------------------


        
        