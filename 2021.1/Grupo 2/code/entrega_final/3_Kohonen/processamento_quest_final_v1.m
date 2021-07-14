function [entrada] = processamento_quest_final_v1(str)	

    %----------------------------------------------------------------------
    entrada = [];
    index_total = 0;

    fid = fopen(str);
    remain = fgetl(fid);%ler a linha do arquivo
    total=sum(remain==';')+1;
    total
    while ~feof(fid)
		index_total = index_total+1;
		remain = fgetl(fid);%ler a linha do arquivo
        [entrada_temp] = kernel(remain,total);
        entrada(index_total, 1:total-3) = entrada_temp(:);
    end
    
    fclose('all');

%==========================================================================
function [entrada] = kernel(remain,total)
	
        entrada = [];
        count = 0;
        %------------Cataloga jogador--------------------------------------
        for ii=1:total
            [resto, remain] = strtok(remain, ';'); %elimina a primeira coluna
            if (ii==1) || (ii==2)|| (ii==4) continue; end
            [resto, lixo] = strtok(resto, ' ');
            resto = strrep(resto,',','.');
            a = str2double(resto);
            count = count +1;
            if( (isempty(a)) || (isnan(a)) ) a = 0; end
            entrada(count) = a;
        end
        %------------------------------------------------------------------



        