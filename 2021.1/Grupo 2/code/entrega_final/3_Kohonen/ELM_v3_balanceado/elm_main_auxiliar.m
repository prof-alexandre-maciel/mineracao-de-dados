function [train_accuracy_total,test_accuracy_total,TrainingTime_total,TestingTime_total] =....
        elm_main_auxiliar(train_accuracy_total,test_accuracy_total,TrainingTime_total,TestingTime_total,...
        iteracao, NumberofHiddenNeurons_vetor, custos_vetor, gammas_vetor, entradaFim, classes, kELM, normalizar_entrada, entrada, aleatorio, nucleos)

     
	strb = 'int32';
	 
    [index_total, ex] = size(entrada);
    %----------------------------------------------------------------------
    NumberofInputNeurons=ex-1;
    %----------------------------------------------------------------------
	if exist( strcat('ELM_v3_balanceado/iteracao/',  strcat(num2str(iteracao))) )~=7
		mkdir( 'ELM_v3_balanceado/iteracao', strcat(num2str(iteracao)) );
	end
	if exist( strcat('ELM_v3_balanceado/boxplot/',  strcat(num2str(iteracao))) )~=7
		mkdir( 'ELM_v3_balanceado/boxplot', strcat(num2str(iteracao)) );
	end
	if exist( strcat('ELM_v3_balanceado/confusao/',  strcat(num2str(iteracao))) )~=7
		mkdir( 'ELM_v3_balanceado/confusao', strcat(num2str(iteracao)) );
	end	
    %----------------------------------------------------------------------	
    for u=1:14
		%------------------------------------------------------------------
										%com balanceamento(duas técnicas) e sem
		vetortrain_accuracy = zeros(kELM, numel(NumberofHiddenNeurons_vetor), numel(custos_vetor), numel(gammas_vetor),'double');
		vetortest_accuracy = zeros(kELM, numel(NumberofHiddenNeurons_vetor), numel(custos_vetor), numel(gammas_vetor),'double');
		vetorTrainingTime = zeros(kELM, numel(NumberofHiddenNeurons_vetor), numel(custos_vetor), numel(gammas_vetor),'double');
		vetorTestingTime = zeros(kELM, numel(NumberofHiddenNeurons_vetor), numel(custos_vetor), numel(gammas_vetor),'double');                              
		%------------------------------------------------------------------
		if u==1
			kernel = 'RBF_kernel';
		elseif u==2
			kernel = 'lin_kernel';
		elseif u==3
			kernel = 'poly_kernel';
		elseif u==4
			kernel = 'wav_kernel';
		elseif u==5
			kernel = 'sigmoid';
		elseif u==6
			kernel = 'sine';
		elseif u==7
			kernel = 'hardlim';
		elseif u==8    
			kernel = 'tribas';
		elseif u==9
			kernel = 'dilatacao';
		elseif u==10
			kernel = 'erosao';
		elseif u==11
			kernel = 'dilatacao_classica';
		elseif u==12
			kernel = 'erosao_classica';			
		elseif u==13
			kernel = 'dilatacao_bitwise';
		elseif u==14
			kernel = 'erosao_bitwise';			
		end
		%------------------------------------------------------------------
		if exist( strcat('ELM_v3_balanceado/iteracao/',num2str(iteracao),'/',kernel) )~=7
			mkdir( strcat('ELM_v3_balanceado/iteracao/', num2str(iteracao)), kernel);
		end		
		
		if exist( strcat('ELM_v3_balanceado/boxplot/',num2str(iteracao),'/',kernel) )~=7
			mkdir( strcat('ELM_v3_balanceado/boxplot/', num2str(iteracao)), kernel);
		end
	
		if exist( strcat('ELM_v3_balanceado/confusao/',num2str(iteracao),'/',kernel) )~=7
			mkdir( strcat('ELM_v3_balanceado/confusao/', num2str(iteracao)), kernel);
		end
		%------------------------------------------------------------------
        kernel
		for e_index=1:numel(NumberofHiddenNeurons_vetor)
            NumberofHiddenNeurons = NumberofHiddenNeurons_vetor(e_index);
			%--------------------------------------------------------------
			if( (strcmp(kernel,'dilatacao_bitwise')==1) || (strcmp(kernel,'erosao_bitwise')==1) )
				[InputWeight,BiasofHiddenNeurons,estatistica] = pesos_bitwise(iteracao,NumberofHiddenNeurons,NumberofInputNeurons,strb);          
			else
				[InputWeight,BiasofHiddenNeurons,estatistica] = pesos(iteracao,NumberofHiddenNeurons,NumberofInputNeurons);	
			end
			%--------------------------------------------------------------
            for c_index=1:numel(custos_vetor)
                c = custos_vetor(c_index);
                %---------------------------------------------------------- 
				for g_index=1:numel(gammas_vetor)
                    g = gammas_vetor(g_index);
					%------------------------------------------------------  
                    [condicao] = valida_condicoes(u, e_index, c_index, g_index, iteracao);
					if (condicao==0)
						continue;
                    end 
                    %----------Estratégias de Paralelismo------------------
                    for mm=1:nucleos:kELM
                        min = mm;
                        max = mm+nucleos-1;
                        if(max>kELM) max = kELM; end
                        %----------estratégias para paralelismo------------
                        delete(gcp('nocreate'));
                        parpool('local',nucleos);
                        parfor fold=min:max
                        %for fold=min:max
                            fold
                            [conjuntoTreinamentoELM, conjuntoTesteELM] = getValidacaoTreinamentoELM(entrada, aleatorio,fold);

                                [vetortrain_accuracy(fold,e_index,c_index,g_index), vetortest_accuracy(fold,e_index,c_index,g_index),...
                                vetorTrainingTime(fold,e_index,c_index,g_index), vetorTestingTime(fold,e_index,c_index,g_index)] = ...
                            rodaELM(u, kernel, c_index, c, g_index, g, strb,...
								entradaFim, classes, normalizar_entrada, conjuntoTreinamentoELM, conjuntoTesteELM,...
								InputWeight, BiasofHiddenNeurons, NumberofHiddenNeurons, e_index,...
								iteracao, fold, aleatorio);	               
                        end
                    end
                    
                    %------------------------------------------------------
                    path1 = strcat('ELM_v3_balanceado/iteracao/',num2str(iteracao),'/',kernel,'/resultadoValidacaoCruzada_escondida_',num2str(e_index),'_custos_', num2str(c_index),'_gamma_', num2str(g_index),'.txt');
									[train_accuracy_total, test_accuracy_total, TrainingTime_total, TestingTime_total] = ...
					imprime_resultados(train_accuracy_total, test_accuracy_total, TrainingTime_total, TestingTime_total,...
									iteracao,u,path1,kernel, e_index, c_index, g_index, ...
									vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime);   				
					%------------------------------------------------------
                end	
            end
        end
    end
    cria_cabecalho(iteracao);
    imprime(estatistica, 1, iteracao);
    imprime(estatistica, 2, iteracao);
	
	%resultado_best = max(vetortest_accuracy(:));
%==========================================================================
function [train_accuracy_total, test_accuracy_total, TrainingTime_total, TestingTime_total] = ...
         imprime_resultados(train_accuracy_total, test_accuracy_total, TrainingTime_total, TestingTime_total,...
                            iteracao,u,path1,kernel, e_index, c_index, g_index, ...
                            vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime)

		fid = fopen(path1,'w');
        
		metodo = 'sem_pesos';
	
		train_accuracy_total(iteracao,u,:,e_index,c_index,g_index) = vetortrain_accuracy(:,e_index,c_index,g_index);
		test_accuracy_total(iteracao,u,:,e_index,c_index,g_index) = vetortest_accuracy(:,e_index,c_index,g_index);
		TrainingTime_total(iteracao,u,:,e_index,c_index,g_index) = vetorTrainingTime(:,e_index,c_index,g_index);
		TestingTime_total(iteracao,u,:,e_index,c_index,g_index) = vetorTestingTime(:,e_index,c_index,g_index);		
		
		patha = strcat('media_train_accuracy_',metodo);
		fprintf(fid,'%s %f\n',patha, mean(vetortrain_accuracy(:,e_index, c_index, g_index)));
		patha = strcat('std_train_accuracy_',metodo);
		fprintf(fid,'%s %f\n',patha,std(vetortrain_accuracy(:,e_index, c_index, g_index)));
		
		pathb = strcat('media_test_accuracy_',metodo);
		fprintf(fid,'%s %f\n',pathb, mean(vetortest_accuracy(:,e_index, c_index, g_index)));
		pathb = strcat('std_test_accuracy_',metodo);
		fprintf(fid,'%s %f\n',pathb,std(vetortest_accuracy(:,e_index, c_index, g_index)));
		
		pathc = strcat('media_TrainingTime_',metodo);
		fprintf(fid,'%s %f\n',pathc,mean(vetorTrainingTime(:,e_index, c_index, g_index)));
		pathc = strcat('std_TrainingTime_',metodo);
		fprintf(fid,'%s %f\n',pathc,std(vetorTrainingTime(:,e_index, c_index, g_index)));
		
		pathd = strcat('media_TestingTime_',metodo);
		fprintf(fid,'%s %f\n',pathd,mean(vetorTestingTime(:,e_index, c_index, g_index)));
		pathd = strcat('std_TestingTime_',metodo);
		fprintf(fid,'%s %f\n',pathd,std(vetorTestingTime(:,e_index, c_index, g_index)));
		fprintf(fid,'==============================\n'); 
		%------------------------------------------------------------------
        fclose(fid);
    
		bloxplot_funcao_elm('ELM_v3_balanceado', iteracao, kernel,e_index, c_index, g_index,...
                           vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime);
    

%--------------------------------------------------------------------------
function imprime(estatistica, index, iteracao)


        if index==1
            path1 = strcat('ELM_v3_balanceado/iteracao/',num2str(iteracao),'/resultado_estatistica_pesos.csv'); 
        else
            path1 = strcat('ELM_v3_balanceado/iteracao/',num2str(iteracao),'/resultado_estatistica_bias.csv');
        end
        fid = fopen(char(path1),'a');        
        
        fprintf(fid,'%d;',iteracao);

        for k=1:6 %são6 variáveis estatísticas que Wel sugeriu
            fprintf(fid,'%f;',estatistica(k,index));
        end 
        
        fprintf(fid,'\n');
        fclose(fid);
    
%==========================================================================
function cria_cabecalho(iteracao)

    %----------------------------------------------------------------------
    str = strcat('iteracao;minimo;maximo;media;std;moda;curtose;',...
                 'acerto_sigmoid;tempo_sigmoid;',...
                 'acerto_sine;tempo_sine;',...
                 'acerto_hardlim;tempo_hardlim;',...
                 'acerto_tribas;tempo_tribas;',...
                 'acerto_dilatacao;tempo_dilatacao;',...
                 'acerto_erosao;tempo_erosao\n');
    
    path1 = strcat('ELM_v3_balanceado/iteracao/',num2str(iteracao),'/resultado_estatistica_pesos.csv'); 
    fid = fopen(char(path1),'w');
    fprintf(fid,str);
    fclose(fid);
    
    path1 = strcat('ELM_v3_balanceado/iteracao/',num2str(iteracao),'/resultado_estatistica_bias.csv'); 
    fid = fopen(char(path1),'w');
    fprintf(fid,str);
    fclose(fid);     
%==========================================================================
function [InputWeight,BiasofHiddenNeurons,estatistica] = pesos(iteracao,NumberofHiddenNeurons,NumberofInputNeurons)
    
    
    %----------------------------------------------------------------------
    rng(iteracao);
    InputWeight=rand(NumberofHiddenNeurons,NumberofInputNeurons)*2-1;
    %----------------------------------------------------------------------
    rng(iteracao);
    BiasofHiddenNeurons=rand(NumberofHiddenNeurons,1);
    %----------------------------------------------------------------------
    InputWeight = normalizar_pesos(InputWeight);
    BiasofHiddenNeurons = normalizar_pesos(BiasofHiddenNeurons);
    
    %1ª dimensão: variáveis estatísticas
    %2ª dimensão: NumberofHiddenNeurons , BiasofHiddenNeurons
    estatistica = zeros(6, 2, 'double');
    %----------------------------------------------------------------------
    [estatistica] = estatistica_populacao(InputWeight, BiasofHiddenNeurons,...
                                          estatistica);
                                   
%==========================================================================
function [InputWeight,BiasofHiddenNeurons,estatistica] = pesos_bitwise(iteracao,NumberofHiddenNeurons,NumberofInputNeurons,strb)
    %----------------------------------------------------------------------
    rng(iteracao);
    InputWeight=rand(NumberofHiddenNeurons,NumberofInputNeurons)*2-1;
    %----------------------------------------------------------------------
    rng(iteracao);
    BiasofHiddenNeurons=rand(NumberofHiddenNeurons,1);
    %----------------------------------------------------------------------
    InputWeight = normalizar_pesos(InputWeight);
    BiasofHiddenNeurons = normalizar_pesos(BiasofHiddenNeurons);   
     
	%1ª dimensão: variáveis estatísticas
    %2ª dimensão: NumberofHiddenNeurons , BiasofHiddenNeurons
    estatistica = zeros(6, 2, 'double');
    %----------------------------------------------------------------------
    [estatistica] = estatistica_populacao(InputWeight, BiasofHiddenNeurons,...
                                          estatistica);
										  
    InputWeight = InputWeight*1000000;
    BiasofHiddenNeurons = BiasofHiddenNeurons*1000000;
    
    InputWeight = round(InputWeight);
    BiasofHiddenNeurons = round(BiasofHiddenNeurons); 
    
    if(strcmp(strb,'int8')==1)
        InputWeight = int8(InputWeight);
        BiasofHiddenNeurons = int8(BiasofHiddenNeurons);
    elseif(strcmp(strb,'int16')==1)
        InputWeight = int16(InputWeight);
        BiasofHiddenNeurons = int16(BiasofHiddenNeurons);
    elseif(strcmp(strb,'int32')==1)
        InputWeight = int32(InputWeight);
        BiasofHiddenNeurons = int32(BiasofHiddenNeurons);
    end
    

										  