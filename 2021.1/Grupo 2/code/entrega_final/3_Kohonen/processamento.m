function [entrada,index_total] = processamento(str,classe)	
	
    %---------------------------------------------------------------
	%fid = fopen(str);
    %lines = 0;
    %while ~feof(fid)
    %    remain = fgetl(fid);%ler a linha do arquivo
    %    lines = lines + 1;
    %end
    %fclose(fid);
	%time_vetor = zeros(lines,1,'double');
	%----------------------------------------------------------------------	
    entrada = [];
    index_total = 0;
    
    fid = fopen(str);
    remain = fgetl(fid);%ler a linha do arquivo
    total=sum(remain==';');
    while ~feof(fid)
		index_total = index_total+1;
		remain = fgetl(fid);%ler a linha do arquivo
		%------------------------------------------------------------------
        [resto, remain] = strtok(remain, ';'); %elimina a primeira coluna
        remain = remain(2:end);                %elimina o primeiro ponto e vírgula
        %------------------------------------------------------------------
		count = 0;
		for i=1:(total-1)
            [a_temp, remain] = strtok(remain, ';');
            a = str2double(a_temp);
            count = count +1;
            if( (isempty(a)) || (isnan(a)) )
                a = 0; 
            end
            entrada(index_total, count) = a;
        end
        count = count +1;
        entrada(index_total, count) = classe;
        index_total
		%------------------------------------------------------------------
    end
    %index_total
    %count


	fclose('all');
%--------------------------------------------------------------------------
	