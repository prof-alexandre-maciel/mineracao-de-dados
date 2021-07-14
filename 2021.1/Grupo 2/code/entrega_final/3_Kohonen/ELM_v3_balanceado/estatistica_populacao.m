function [estatistica] = estatistica_populacao(InputWeight, BiasofHiddenNeurons,...
                                               estatistica)
    
    [estatistica] =...
    estatistica_populacao_auxiliar(InputWeight, estatistica, 1);


    [estatistica] =...
    estatistica_populacao_auxiliar(BiasofHiddenNeurons, estatistica, 2);

%--------------------------------------------------------------------------
function [estatistica] =...
         estatistica_populacao_auxiliar(entrada, estatistica,index)
    
    [sy,sx] = size(entrada);

    if sx>1
        count = 0;
        for j=1:sy
            for i=1:sx
                count = count +1;
                new(count) = entrada(j,i);
            end
        end
    else
        new = entrada;
    end
     
    estatistica(1, index) = min(new);
    estatistica(2, index) = max(new);
    estatistica(3, index) = mean(new);
    estatistica(4, index) = std(new);
    estatistica(5, index) = mode(new);
    estatistica(6, index) = kurtosis(new);
    