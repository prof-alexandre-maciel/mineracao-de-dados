function [temp] = processamento_cluster_som(cc,entrada_quest_fim,entrada,classe)	

    %1ª coluna: id único do jogador
    %2ª coluna: id do jogo (1: memorização, 2: jogo do offline, 3: tetris)
    
    cluster = load(strcat('dados/with_cluster/som.csv'));
    %----------------------------------------------------------------------
    temp = [];
    temp_total = 0; 
        
    [ay,ax] = size(entrada);    
    for k=1:numel(cluster)
        if(cluster(k)~=cc)
            continue;
        end
        %------------------------------------------------------------------
        id = entrada_quest_fim(k,1);
        for j=1:ay
            if (entrada(j,1)==id)
                temp_total = temp_total +1;
                temp(temp_total,:) = entrada(j, 2:ax); 
            end
        end
        %------------------------------------------------------------------
    end

    [ay,ax] = size(temp);
    temp(:,ax+1) = classe;