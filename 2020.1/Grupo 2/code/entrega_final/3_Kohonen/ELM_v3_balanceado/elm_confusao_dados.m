%==========================================================================	
function elm_confusao_dados(e_index_max_vetor, c_index_max_vetor, g_index_max_vetor,...
                            NumberofHiddenNeurons_vetor, custos_vetor, gammas_vetor,classes, classificador, total)

    
    str = strcat(classificador,'/confusao/ELM_confusao.txt');
	if exist(str, 'file') == 2
        delete(str);
    end

    str_perc = strcat(classificador,'/confusao/ELM_confusao_perc.txt');
	if exist(str_perc, 'file') == 2
        delete(str_perc);
    end
    
    for u=1:14
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
        kernel
		for e_index=1:numel(NumberofHiddenNeurons_vetor)
			NumberofHiddenNeurons = NumberofHiddenNeurons_vetor(e_index);
            
			for c_index=1:numel(custos_vetor)
				for g_index=1:numel(gammas_vetor)
                    %------------------------------------------------------                          
					[condicao] = valida_condicoes(u, e_index_max_vetor(u), c_index_max_vetor(u), g_index_max_vetor(u));
					if (condicao==0)
						continue;
                    end
					%------------------------------------------------------ 
					matrix_train_perc = [];
					matrix_test_perc = [];
					matrix_train = [];
                    matrix_test = [];
					count_train = 0;
                    count_test = 0;
					%------------------------------------------------------
                            
					for concatenacao=1:1 %concatenação dos vetores de extração de características da imagem
						for iteracao=1:total	%pesos iniciais das ligações sinapticas	
                                %------------------------------------------
                                [matrix_train,matrix_train_perc,count_train] =...
                                auxiliar(...
                                matrix_train,matrix_train_perc,'train',count_train,...
                                iteracao,classificador,kernel,e_index_max_vetor(u), c_index_max_vetor(u), g_index_max_vetor(u));
                            
                                [matrix_test,matrix_test_perc,count_test] =...
                                auxiliar(...
                                matrix_test,matrix_test_perc,'test',count_test,...
                                iteracao,classificador,kernel,e_index_max_vetor(u), c_index_max_vetor(u), g_index_max_vetor(u));
                                %------------------------------------------
						end
                    end	
	
                    if (count_train==0) continue; end
					fid = fopen(str,'a');
					fprintf(fid,'===============================%s=========================\n',kernel);  
                    fprintf(fid,'--escondida %d custos %d gamma %d total_iteracoes (train,test) (%d,%d)---\n',e_index_max_vetor(u), c_index_max_vetor(u), g_index_max_vetor(u), count_train,count_test);            
                    fprintf(fid,'-----------train------------------------------------------\n');            
					for jj=1:classes
						for ii=1:classes
							media = mean(matrix_train(:,jj,ii));
							desvio = std(matrix_train(:,jj,ii));
							fprintf(fid,'(%d,%d) %.2f ± %.2f\n', jj,ii, media, desvio);
						end
                    end
                    
                    fprintf(fid,'-----------test------------------------------------------\n');            
					for jj=1:classes
						for ii=1:classes
							media = mean(matrix_test(:,jj,ii));
							desvio = std(matrix_test(:,jj,ii));
							fprintf(fid,'(%d,%d) %.2f ± %.2f\n', jj,ii, media, desvio);
						end
                    end
					%--------------------------------------------------------------
					fie = fopen(str_perc,'a');
					fprintf(fie,'===============================%s=========================\n',kernel);  
                    fprintf(fie,'--escondida %d custos %d gamma %d total_iteracoes (train,test) (%d,%d)---\n',e_index_max_vetor(u), c_index_max_vetor(u), g_index_max_vetor(u), count_train,count_test);            
                    fprintf(fie,'-----------train------------------------------------------\n');        
					for jj=1:classes
						for ii=1:classes
							media = mean(matrix_train_perc(:,jj,ii));
							desvio = std(matrix_train_perc(:,jj,ii));
							fprintf(fie,'(%d,%d) %.2f std %.2f\n', jj,ii, media, desvio);
						end
					end
					
                    fprintf(fie,'-----------test------------------------------------------\n');            
					for jj=1:classes
						for ii=1:classes
							media = mean(matrix_test_perc(:,jj,ii));
							desvio = std(matrix_test_perc(:,jj,ii));
							fprintf(fie,'(%d,%d) %.2f std %.2f\n', jj,ii, media, desvio);
						end
					end
					fclose('all');			
					%------------------------------------------------------ 
                    break;
                end	
                break;
            end
            break;
        end
    end
%==========================================================================
function [matrix,matrix_perc,count] =...
          auxiliar(...
          matrix,matrix_perc,vetor_str,count,...
         iteracao, classificador,kernel,escondida,c,g)
        
    sy = 2; 
    sx = 2;
    fold = 1; 
    str = strcat(classificador,'/confusao/',num2str(iteracao),'/',kernel,'/vetor_C_',vetor_str,'_fold_',num2str(fold),'_escondida_',num2str(escondida),'_custo_',num2str(c),'_gamma_',num2str(g),'.txt');

    while(exist(str, 'file') == 2)
        temp = load(str);        
        count = count + 1;        
        [sy,sx] = size(temp);
        for jj=1:sy
            for ii=1:sx
                matrix(count,jj,ii) = temp(jj,ii);
            end
        end
        fold = fold + 1;
        str = strcat(classificador,'/confusao/',num2str(iteracao),'/',kernel,'/vetor_C_',vetor_str,'_fold_',num2str(fold),'_escondida_',num2str(escondida),'_custo_',num2str(c),'_gamma_',num2str(g),'.txt');
    end    
	%----------------------------------------------------------------------
    for fold=1:count
		for jj=1:sy
			for ii=1:sx
				%----------------------------------------------------------
				soma = 0;
				for kk=1:sy
					soma = soma + matrix(fold,kk,ii);
                end
				%----------------------------------------------------------
				matrix_perc(fold,jj,ii) = (matrix(fold,jj,ii)/soma)*100;
                if isnan(matrix_perc(fold,jj,ii)) matrix_perc(fold,jj,ii) = 0; end
            end
		end 
    end
	%----------------------------------------------------------------------
	
%==========================================================================	  
    