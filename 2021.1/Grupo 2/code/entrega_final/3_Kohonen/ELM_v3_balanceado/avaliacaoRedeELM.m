 function [accuracy] = avaliacaoRedeELM(numTeste, saidasRede, saidasDesejada)

	%     Calculando o erro de classificacao para o conjunto de teste
    %     (A regra de classificacao e' winner-takes-all, ou seja, o nodo de saida que gerar o maior valor de saida
    %      corresponde a classe do padrao).
    %     Obs.: Esse erro so' faz sentido se o problema for de classificacao. Para problemas que nao sao de classificacao,
    %           esse trecho do script deve ser eliminado.

    [maiorSaidaRede, nodoVencedorRede] = max (saidasRede);
    [maiorSaidaDesejada, nodoVencedorDesejado] = max (saidasDesejada);

    %      Obs.: O comando 'max' aplicado a uma matriz gera dois vetores: um contendo os maiores elementos de cada coluna
    %            e outro contendo as linhas onde ocorreram os maiores elementos de cada coluna.
        
	classificacoesErradas = 0;
    for padrao = 1 : numTeste
       
        %------------------------------------------------------------------ 
        if nodoVencedorRede(padrao) ~= nodoVencedorDesejado(padrao)
            classificacoesErradas = classificacoesErradas + 1;
        end
        %------------------------------------------------------------------
    end
        
    accuracy=1-(classificacoesErradas/numTeste);
    
	