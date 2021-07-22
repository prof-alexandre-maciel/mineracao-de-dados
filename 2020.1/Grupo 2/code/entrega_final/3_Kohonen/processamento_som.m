function [entrada,entrada_som] = processamento_som(str,classe)	
	
    %1ª coluna: id único do jogador
    %2ª coluna: id do jogo (1: memorização, 2: jogo do offline, 3: tetris)
    ini = 3;
    fim = 15;
    [vetor] = processamento_auxiliar(ini,fim);
    %vetor
    
    [entrada] = processamento_kernel(str,vetor);

    entrada_som = entrada;
    %----------------------------------------------------------------------
    entrada(:,1) = [];
    [ay,ax] = size(entrada);
    entrada(:,ax+1) = classe;
%==========================================================================
function [entrada] = processamento_kernel(str,vetor)	

    entrada = [];
    index_total = 0;

    fid = fopen(str);
    remain = fgetl(fid);%ler a linha do arquivo
    total=sum(remain==';');
    while ~feof(fid)
		index_total = index_total+1;
		remain = fgetl(fid);%ler a linha do arquivo
        [entrada_temp,bool] = kernel(index_total, remain, vetor);
        %entrada_temp
        if(bool==0)
            index_total = index_total-1;
        else
            entrada(index_total, :) = entrada_temp(:);
        end
        %entrada
        %index_total
    end
    
    fclose('all');

%==========================================================================
function [entrada_temp, bool] = kernel(index_total, remain, vetor)
	
        entrada = [];
        count = 0;
        %------------Cataloga jogador--------------------------------------
        [resto, remain] = strtok(remain, ';'); %elimina a primeira coluna
        a = str2double(resto);
        count = count +1;
        if( (isempty(a)) || (isnan(a)) ) a = 0; end
        entrada(count) = a;
        %entrada
        %------------------------------------------------------------------
        %disp('##########################');
        %entrada
        %remain
        C = strsplit(remain, '\\""e\\"":');
        P = strsplit(remain, '\\""p\\"":');
        
        %disp('!!!!!!!!!!!!!!!!!!');
        if(numel(C)==1)
            entrada_temp = [];
            bool = 0;
            return;
        end
        bool=1;
        %C{2}
        %P{2}
        
        remain = C{2};
        remain_p = P{2};
        [entrada_p] = auxiliar_p(remain_p);

        %remain
        %remain_p
        %resto
        %------------------------------------------------------------------
        for i=1:vetor(numel(vetor))
            %disp('*******************');
            [a_temp, remain] = strtok(remain, ':');
            
            %a_temp
            %i
            %--------------------------------------------------------------
            if mod(i,18)==0 
                [a_temp, rem] = strtok(a_temp, '}');
                a = str2double(a_temp);
                %a
                count = count +1;
                if( (isempty(a)) || (isnan(a)) ) a = 0; end
                entrada(count) = a;
                
                %entrada
                %entrada_p
                entrada_temp = horzcat(entrada, entrada_p);
                %entrada_temp
                return;
            end
            %sentimentos + masculino +feminino
            %--------------------------------------------------------------
            if (i==vetor(count))               
                [a_temp, rem] = strtok(a_temp, '}');
                a = str2double(a_temp);
                count = count +1;
                if( (isempty(a)) || (isnan(a)) ) a = 0; end
                entrada(count) = a;
                %entrada
            end
        end
%==========================================================================
function [vetor] = processamento_auxiliar(ini,fim)	
	
    vetor = [];
	%----------------------------------------------------------------------	
    i = 0;
    for ii=ini:2:fim
        i = i+1;
        vetor(i) = ii;
    end
    vetor(i) = fim+1;
    %vetor
    for jj=ii+3:2:ii+4
        i = i+1;
        vetor(i) = jj;
    end
    vetor(i+1) = jj+1;
    
    total = numel(vetor);
%==========================================================================
function [entrada] = auxiliar_p(remain)
                count = 0;
                %disp('----------------');
                %----------------------------------------------------------
                [remain, a_temp] = strtok(remain, ':[');
                for k=1:24
                    [a_temp, remain] = strtok(remain, ',');
                    if mod(k,24)==0
                        [a_temp, remain] = strtok(a_temp, ']}""}');
                    end
                    a = str2double(a_temp);
                    count = count +1;
                    entrada(count) = a; 
                end
                %entrada
                        
        
        